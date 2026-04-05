from fastapi import FastAPI, HTTPException
from scraper.umd_scraper import UMDHousingScraper

app = FastAPI(
    title="UMD Housing Internal API",
    description="API for fetching live housing data from ochdatabase.umd.edu. Built for AI Agents and Flutter Apps.",
    version="1.0.0"
)

# Initialize scraper 
scraper = UMDHousingScraper()

@app.get("/")
def read_root():
    return {
        "message": "Welcome to the UMD Housing API. Visit /docs for the interactive documentation."
    }

@app.get("/api/v1/housing")
def get_housing_data():
    """
    Fetches the latest housing data.
    This fetches directly from the site on each call to guarantee live data.
    """
    result = scraper.fetch_all_listings()
    if result["status"] == "error":
        raise HTTPException(status_code=500, detail=result["message"])
    
    return result

# Run with: uvicorn main:app --reload
