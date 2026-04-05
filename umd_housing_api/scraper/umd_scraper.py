import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from curl_cffi import requests
import time
from database import SessionLocal, init_db
from models import UMDHousingListing

class UMDHousingScraper:
    def __init__(self):
        self.base_url = "https://ochdatabase.umd.edu/bff/listing/search/combined"
        # Make sure DB is initialized
        init_db()
        
    def fetch_all_listings(self):
        """
        Fetches all housing listings across all pages and saves them to SQLite.
        """
        headers = {
            "Accept": "*/*",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
        }
        
        all_processed_listings = []
        page = 1
        
        try:
            db = SessionLocal()
            while True:
                # Append pagination if page > 1
                page_path = f"/housing/page-{page}" if page > 1 else "/housing"
                url_with_params = f"{self.base_url}?url={page_path}&v=4&seed=1234&locale=en"
                
                print(f"Fetching page {page}...")
                session = requests.Session(impersonate="chrome110")
                response = session.get(url_with_params, headers=headers)
                
                if response.status_code != 200:
                    return {
                        "status": "error",
                        "message": f"HTTP {response.status_code} on page {page}",
                        "data": []
                    }
                
                data = response.json()
                raw_listings = data.get("data", {}).get("placards", [])
                
                if not raw_listings:
                    print("No more listings found. Pagination complete.")
                    break
                
                for item in raw_listings:
                    geography = item.get("geography", {})
                    target_college = geography.get("targetCollege", {})
                    
                    media_items = item.get("media")
                    primary_image = None
                    if isinstance(media_items, list) and len(media_items) > 0:
                        primary_image = media_items[0].get("url") if isinstance(media_items[0], dict) else None
                    elif isinstance(media_items, dict) and len(media_items) > 0:
                        first_key = list(media_items.keys())[0]
                        first_item = media_items[first_key]
                        primary_image = first_item.get("url") if isinstance(first_item, dict) else media_items.get("url")
    
                    price_string = item.get("totalMonthlyPrice", "")
                    property_id = item.get("ocpId") or item.get("siteId")
                    
                    if not property_id:
                        continue
                        
                    parsed_item = {
                        "property_id": int(property_id),
                        "name": item.get("name"),
                        "address": geography.get("streetAddress", ""),
                        "city": geography.get("cityName", "College Park"),
                        "state": geography.get("stateCode", "MD"),
                        "zip_code": geography.get("zipCode", ""),
                        "distance_miles": target_college.get("distance", 0.0),
                        "price_summary": price_string,
                        "floor_plan_summary": item.get("floorPlanSummary", {}),
                        "phone_number": item.get("leads", {}).get("phone", {}).get("formatted", ""),
                        "image_url": primary_image
                    }
                    all_processed_listings.append(parsed_item)
                    
                    # UPSERT Logic (Update if exists, Insert if not)
                    existing = db.query(UMDHousingListing).filter(UMDHousingListing.property_id == parsed_item["property_id"]).first()
                    if existing:
                        for key, value in parsed_item.items():
                            setattr(existing, key, value)
                    else:
                        new_listing = UMDHousingListing(**parsed_item)
                        db.add(new_listing)
                        
                db.commit()
                page += 1
                time.sleep(1) # Be polite to the server
                
            db.close()
            return {
                "status": "success",
                "total_count": len(all_processed_listings),
                "data": all_processed_listings
            }
            
        except Exception as e:
            import traceback
            traceback.print_exc()
            return {
                "status": "error",
                "message": f"Failed to fetch data: {str(e)}",
                "data": []
            }

if __name__ == "__main__":
    scraper = UMDHousingScraper()
    result = scraper.fetch_all_listings()
    print(f"Status: {result['status']}")
    print(f"Total Listings Scraped and Saved to DB: {result.get('total_count')}")
