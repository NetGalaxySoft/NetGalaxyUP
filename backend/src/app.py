from fastapi import FastAPI
from .config import settings

app = FastAPI(
    title="NetGalaxyUP API",
    version=settings.API_VERSION
)

@app.get("/health")
async def health_check():
    return {"status": "ok"}
