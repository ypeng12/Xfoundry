from sqlalchemy import Column, Integer, String, Float, JSON
from database import Base

class UMDHousingListing(Base):
    __tablename__ = "housing_listings"

    property_id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    address = Column(String)
    city = Column(String)
    state = Column(String)
    zip_code = Column(String)
    distance_miles = Column(Float)
    price_summary = Column(String)
    
    # Store dynamic nested data seamlessly for Flutter / AI consumption
    floor_plan_summary = Column(JSON)
    contact = Column(JSON)
    image_url = Column(String)
