from datetime import datetime
from typing import Annotated

from fastapi import Depends, FastAPI, Header, HTTPException
from pydantic import BaseModel, Field

app = FastAPI(title="TOGA Mock API", version="0.1.0")

MOCK_TOKEN = "mock.jwt.cadet-arjun-menon"


class LoginRequest(BaseModel):
    username: str = Field(default="arjun.menon")
    password: str = Field(default="mock-password")


class StudyNoteRequest(BaseModel):
    subject_id: str
    subject: str
    body: str = Field(min_length=1)


profile = {
    "id": "cadet-arjun-menon",
    "name": "Arjun Menon",
    "role": "Cadet",
    "course": "PPL",
    "base": "Chennai",
    "fto": {"id": "fto-airman", "name": "AIRMAN Flight Academy", "base": "Chennai"},
    "instructor": {"id": "inst-sharma", "name": "Capt. R. Sharma", "rating": "CFI"},
}

dashboard = {
    "cadet_name": "Arjun Menon",
    "course": "PPL",
    "training_stage": "Navigation Phase",
    "assigned_fto": "AIRMAN Flight Academy",
    "assigned_instructor": "Capt. R. Sharma",
    "overall_study_progress": 64,
    "upcoming_flight": {
        "aircraft": "Cessna 172",
        "date": "2026-05-18",
        "time": "07:30 AM",
        "lesson": "Navigation Exercise",
    },
    "logbook": {"total_hours": 42.5, "solo_hours": 6.2, "last_flight": "2026-05-10"},
}

subjects = [
    {
        "id": "met",
        "subject": "Meteorology",
        "progress": 72,
        "lessons_completed": 18,
        "total_lessons": 25,
        "quiz_score": 81,
        "status": "In Progress",
        "chapters": [
            {"id": "met-1", "chapter": "Atmosphere", "completed": True},
            {"id": "met-2", "chapter": "Pressure Systems", "completed": True},
            {"id": "met-3", "chapter": "Clouds and Precipitation", "completed": False},
            {"id": "met-4", "chapter": "Thunderstorms", "completed": False},
        ],
    },
    {
        "id": "air-reg",
        "subject": "Air Regulations",
        "progress": 100,
        "lessons_completed": 30,
        "total_lessons": 30,
        "quiz_score": 92,
        "status": "Completed",
        "chapters": [{"id": "reg-1", "chapter": "Rules of the Air", "completed": True}],
    },
    {
        "id": "nav",
        "subject": "Navigation",
        "progress": 58,
        "lessons_completed": 14,
        "total_lessons": 24,
        "quiz_score": 76,
        "status": "In Progress",
        "chapters": [
            {"id": "nav-1", "chapter": "Dead Reckoning", "completed": True},
            {"id": "nav-2", "chapter": "VOR Tracking", "completed": True},
            {"id": "nav-3", "chapter": "Flight Planning", "completed": False},
        ],
    },
    {
        "id": "tech-gen",
        "subject": "Technical General",
        "progress": 35,
        "lessons_completed": 7,
        "total_lessons": 20,
        "quiz_score": 69,
        "status": "In Progress",
        "chapters": [
            {"id": "tg-1", "chapter": "Airframes", "completed": True},
            {"id": "tg-2", "chapter": "Engines", "completed": False},
        ],
    },
    {
        "id": "tech-spec",
        "subject": "Technical Specific",
        "progress": 0,
        "lessons_completed": 0,
        "total_lessons": 16,
        "quiz_score": 0,
        "status": "Not Started",
        "chapters": [
            {"id": "ts-1", "chapter": "C172 Systems Overview", "completed": False},
            {"id": "ts-2", "chapter": "Limitations", "completed": False},
        ],
    },
    {
        "id": "air-nav",
        "subject": "Air Navigation",
        "progress": 44,
        "lessons_completed": 10,
        "total_lessons": 22,
        "quiz_score": 73,
        "status": "In Progress",
        "chapters": [
            {"id": "an-1", "chapter": "Charts and Symbols", "completed": True},
            {"id": "an-2", "chapter": "Wind Triangle", "completed": False},
        ],
    },
    {
        "id": "rtr",
        "subject": "RTR / Communication",
        "progress": 18,
        "lessons_completed": 3,
        "total_lessons": 17,
        "quiz_score": 61,
        "status": "In Progress",
        "chapters": [
            {"id": "rtr-1", "chapter": "Standard Phraseology", "completed": True},
            {"id": "rtr-2", "chapter": "Emergency Calls", "completed": False},
        ],
    },
]

logbook = {
    "total_hours": 42.5,
    "dual_hours": 36.3,
    "solo_hours": 6.2,
    "last_flight": "2026-05-10",
    "recent_entries": [
        {
            "id": "log-1",
            "date": "2026-05-10",
            "aircraft": "C172",
            "route": "VOMM - Training Area - VOMM",
            "duration": 1.2,
            "lesson": "Navigation",
        }
    ],
}

notifications = [
    {
        "id": "n1",
        "title": "Upcoming flight reminder",
        "message": "Navigation Exercise departs at 07:30 AM on Cessna 172.",
        "type": "flight",
        "time": "2026-05-17T18:00:00Z",
        "is_read": False,
    },
    {
        "id": "n2",
        "title": "Study reminder",
        "message": "Complete Thunderstorms before your next Meteorology quiz.",
        "type": "study",
        "time": "2026-05-16T12:30:00Z",
        "is_read": False,
    },
]


def require_cadet(authorization: Annotated[str | None, Header()] = None) -> dict:
    if authorization != f"Bearer {MOCK_TOKEN}":
        raise HTTPException(status_code=401, detail="Invalid or missing JWT")
    if profile["role"] != "Cadet":
        raise HTTPException(status_code=403, detail="Cadet role required")
    return profile


@app.post("/auth/login")
def login(_: LoginRequest):
    return {"access_token": MOCK_TOKEN, "token_type": "bearer", "profile": profile}


@app.get("/toga/cadet/me")
def cadet_me(_: Annotated[dict, Depends(require_cadet)]):
    return profile


@app.get("/toga/cadet/dashboard")
def cadet_dashboard(_: Annotated[dict, Depends(require_cadet)]):
    return dashboard


@app.get("/toga/study/subjects")
def study_subjects(_: Annotated[dict, Depends(require_cadet)]):
    return subjects


@app.get("/toga/study/subjects/{subject_id}")
def study_subject(subject_id: str, _: Annotated[dict, Depends(require_cadet)]):
    for subject in subjects:
        if subject["id"] == subject_id:
            return subject
    raise HTTPException(status_code=404, detail="Subject not found")


@app.post("/toga/study/notes")
def create_note(payload: StudyNoteRequest, _: Annotated[dict, Depends(require_cadet)]):
    return {
        "id": f"note-{int(datetime.utcnow().timestamp())}",
        "subject_id": payload.subject_id,
        "subject": payload.subject,
        "body": payload.body,
        "sync_status": "Synced",
        "created_at": datetime.utcnow().isoformat(),
    }


@app.get("/toga/logbook/summary")
def logbook_summary(_: Annotated[dict, Depends(require_cadet)]):
    return logbook


@app.get("/toga/notifications")
def notification_list(_: Annotated[dict, Depends(require_cadet)]):
    return notifications


@app.patch("/toga/notifications/{notification_id}/read")
def read_notification(notification_id: str, _: Annotated[dict, Depends(require_cadet)]):
    for item in notifications:
        if item["id"] == notification_id:
            item["is_read"] = True
            return item
    raise HTTPException(status_code=404, detail="Notification not found")
