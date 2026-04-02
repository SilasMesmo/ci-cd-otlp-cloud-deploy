import os
from fastapi import APIRouter, HTTPException

router = APIRouter(prefix="/health", tags=["Health"])

@router.get("")
def health_check():
    # Simulates a failure if the SIMULATE_FAILURE environment variable is 'true'
    simulate_failure = os.getenv("SIMULATE_FAILURE", "").lower() == "true"
    if simulate_failure:
        raise HTTPException(
            status_code=500, detail="Simulated failure for Kubernetes probes testing"
        )
    return {"status": "ok"}
