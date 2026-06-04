# TOGA Mock FastAPI

Run locally with a standard Windows Python installation:

```bash
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r backend/requirements.txt
uvicorn backend.main:app --reload --port 8000

Login with `POST /auth/login`, then pass `Authorization: Bearer mock.jwt.cadet-arjun-menon` to protected TOGA endpoints.
