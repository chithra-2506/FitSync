# FitSync API Contracts

## Overview

FitSync uses Next.js API routes to communicate between the frontend and the Supabase database. Protected endpoints require an authenticated user session. The backend must use the authenticated user's ID and must not trust a user ID supplied by the client.

## 1. Profile API

### GET `/api/profile`

**Purpose:** Retrieve the authenticated user's profile.

**Success response — `200 OK`:**
```json
{
  "profile": {
    "id": "user-uuid",
    "display_name": "Example User",
    "date_of_birth": "2005-01-15",
    "height_cm": 165,
    "created_at": "timestamp",
    "updated_at": "timestamp"
  }
}
```

### PATCH `/api/profile`

**Purpose:** Update permitted profile fields.

**Request body:**
```json
{
  "display_name": "Example User",
  "date_of_birth": "2005-01-15",
  "height_cm": 165
}
```

Only supplied, valid fields should be updated. The user ID must come from the authenticated session.

## 2. Health Logs API

### GET `/api/health-logs`

**Purpose:** Retrieve the authenticated user's health logs.

**Success response — `200 OK`:**
```json
{
  "health_logs": []
}
```

Return only the current user's records, ordered by `logged_at` descending. Pagination can be added as the dataset grows.

### POST `/api/health-logs`

**Purpose:** Create a health log for the authenticated user.

**Request body example:**
```json
{
  "weight_kg": 60.5,
  "water_intake_ml": 1800,
  "sleep_hours": 7.5,
  "steps": 6500,
  "mood": "happy",
  "notes": "Morning walk completed"
}
```

All fields are optional individually, but the request must contain at least one valid health measurement or note. The backend sets `user_id` from the authenticated session.

## 3. Common Error Responses

- `400 Bad Request` — invalid request data.
- `401 Unauthorized` — user is not authenticated.
- `404 Not Found` — requested resource does not exist.
- `500 Internal Server Error` — unexpected server error.

Error responses should use a consistent structure:
```json
{
  "error": {
    "message": "A description of the error"
  }
}
```

## 4. Security and Validation

- Require authentication for protected endpoints.
- Validate request bodies with Zod.
- Never accept a client-provided user ID as proof of ownership.
- Keep Supabase Row Level Security enabled.
- Never expose the service-role key in client-side code.
- Avoid returning sensitive internal error details.

## 5. Planned Endpoints

The wellness-plan and coach endpoints are planned for later implementation and require coordination with the teammate responsible for wellness AI.

- `GET /api/wellness-plan`
- `POST /api/wellness-plan`
- `POST /api/coach`

These contracts are provisional until the team reviews and agrees on them.
