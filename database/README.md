# FitSync Database

## Overview

FitSync uses Supabase PostgreSQL to store user profiles and health logs. Supabase Authentication identifies users, and Row Level Security (RLS) helps ensure users can access only their own records.

## Database Structure

### 1. Profiles

The `public.profiles` table stores:
- User ID linked to Supabase Authentication
- Display name
- Date of birth
- Height in centimetres
- Creation and update timestamps

### 2. Health Logs

The `public.health_logs` table stores:
- Health log ID and user ID
- Weight in kilograms
- Water intake in millilitres
- Sleep duration in hours
- Step count
- Mood and optional notes
- Log timestamp and creation timestamp

## Migration

The initial migration is:

`migrations/001_create_profiles_and_health_logs.sql`

It creates the tables, adds validation constraints and indexes, enables RLS, and defines policies for authenticated users.

## Setup

1. Create or access a Supabase project.
2. Configure the required environment variables in the frontend's local environment file:
   - `SUPABASE_URL`
   - `SUPABASE_PUBLISHABLE_KEY`
3. Apply the migration using the Supabase SQL Editor or the team's approved migration workflow.
4. Verify the tables, RLS policies, and authentication flow before testing the application.

**Note:** The migration has been written but has not yet been confirmed as applied to a Supabase database. Profile creation during signup and automatic updating of `updated_at` still need to be addressed.

## Security

- Never commit real environment secrets.
- Never expose the Supabase service-role key in browser-side code.
- Keep RLS enabled and test that users cannot read or modify another user's records.
