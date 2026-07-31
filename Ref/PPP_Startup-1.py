'''  PPPP using:
     FastAPI application with a simple SQLite database and Jinja2 templating.
This example (will) demonstrates how to set up a FastAPI application with a SQLite database,
use SQLAlchemy for ORM, and render HTML templates using Jinja2. '''

# Lifted from: https://fastapi.tiangolo.com/tutorial/sql-databases/
# and https://fastapi.tiangolo.com/advanced/templates/

# To run from command line: fastapi dev PPP_Startup-1.py  
# 
# For more detailed instructions, see: instructions.md
# Ensure you have the required packages installed: fastapi, uvicorn ?? , sqlalchemy, jinja2

# DB specifics to be moved to PPPP app, but work a basic DB interface first.
# adding Debug and Cookie support :ToDo: define DB schema:
# Tables: Pundits, PPPP-test, Users, PPPP-Results Sessions, Cookies, Ads, Trackers
# first up:  Cookies

# What is this? : favicon.ico

# --- Imports ---

from fastapi import FastAPI, Request, Depends
from fastapi.concurrency import asynccontextmanager
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

from sqlalchemy import Column, Integer, String, create_engine
from sqlalchemy.orm import declarative_base, sessionmaker, Session

# For Cookies:
from typing import Annotated
from fastapi import Cookie
from pydantic import BaseModel

import platform
import sys

import PPP_Utils


class Cookies(BaseModel):
    session_id: str
    fatebook_tracker: str | None = None  # Fake test cookie for Facebook tracking
    googall_tracker: str | None = None

__MyDBG__ = True

# --- App Initialization ---
if __debug__:
    print(" Debug mode is ON ") 

app = FastAPI()


#@app.on_event("startup")  

@asynccontextmanager
async def lifespan(app: FastAPI):
#    async def startup_event():
    fake_headers = {"user-agent": "Startup/1.0"}
    class _DummyRequest:
        def __init__(self, headers):
            self.headers = headers
    info = get_browser_info(_DummyRequest(fake_headers))
    print("Startup browser info helper ready:", info)

# Get cookie support:
@app.get("/items/")
async def read_items(ads_id: Annotated[str | None, Cookie()] = None):
    return {"ads_id": ads_id}

@app.get("/browser-info")
async def browser_info(request: Request):
    return get_browser_info(request)

cookies = Cookies(session_id="abc123", fatebook_tracker="fbtrack456", googall_tracker="gat789")
if __MyDBG__:
    print(" Cookie :",cookies ) 

templates = Jinja2Templates(directory="templates")

if __MyDBG__:
    print(" templates initialized -", templates )

# Parameters example
@app.get("/items/{item_id}")
async def read_item(item_id: int):
    return {"item_id": item_id}   

# just experimenting with debug print statements and scope of variables here.
if __MyDBG__:
#    print(" item ID: ", item_id )  # Cannot print item_id here, it's out of scope
    pass

# --- Model ---
Base = declarative_base()
engine = create_engine("sqlite:///./test.db")  # ToDo: document path to the database.

SessionLocal = sessionmaker(bind=engine)

class Item(Base):
    __tablename__ = "items"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)

Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# --- Controller ---
@app.get("/", response_class=HTMLResponse)
def read_items(request: Request, db: Session = Depends(get_db)):
    items = db.query(Item).all()
    return templates.TemplateResponse("index.html", {"request": request, "items": items})

# Note:  Update view 
# --- View is in subfolder  <>/templates/index.html

