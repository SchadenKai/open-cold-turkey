from contextlib import asynccontextmanager
from starlette.middleware.cors import CORSMiddleware
from fastapi import FastAPI, HTTPException
from python_hosts import Hosts, HostsEntry
from pydantic import BaseModel
import sys
import os

@asynccontextmanager
async def lifespan(app: FastAPI):
    print("App started")
    yield

app = FastAPI(
    title="API Server",
    lifespan=lifespan
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Detect OS for correct hosts file path
HOSTS_PATH = r"C:\Windows\System32\drivers\etc\hosts" if sys.platform == "win32" else "/etc/hosts"

class BlockRequest(BaseModel):
    sites: list[str]

@app.get("/status")
def get_status():
    """Check what is currently blocked"""
    hosts = Hosts(path=HOSTS_PATH)
    blocked_domains = [entry.names[0] for entry in hosts.entries if entry.entry_type == 'ipv4' and entry.address == '127.0.0.1']
    return {"blocked": blocked_domains}

@app.post("/block")
def block_sites(req: BlockRequest):
    """The 'Cold Turkey' Logic: Redirect sites to localhost"""
    if not os.access(HOSTS_PATH, os.W_OK):
         raise HTTPException(status_code=500, detail="Permission Denied: Run as Admin/Root")

    hosts = Hosts(path=HOSTS_PATH)
    new_entries = []
    
    for site in req.sites:
        # Create an entry mapping the site to 127.0.0.1 (Localhole)
        entry = HostsEntry(entry_type='ipv4', address='127.0.0.1', names=[site, f"www.{site}"])
        new_entries.append(entry)
        
    hosts.add(new_entries)
    hosts.write() # Writes to system file
    return {"status": "blocked", "sites": req.sites}

@app.post("/unblock")
def unblock_sites(req: BlockRequest):
    """Release the lock"""
    hosts = Hosts(path=HOSTS_PATH)
    for site in req.sites:
        hosts.remove_all_matching(name=site)
        hosts.remove_all_matching(name=f"www.{site}")
    
    hosts.write()
    return {"status": "unblocked", "sites": req.sites}