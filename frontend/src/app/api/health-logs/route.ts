import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
// GET: Fetch health logs for the currently logged-in user
export async function GET() {
  try {
    // Connect to Supabase
    const supabase = await createClient();

    // Check the currently logged-in user
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    // Return an error if the user is not authenticated
    if (authError || !user) {
      return NextResponse.json(
        { error: "Unauthorized" },
        { status: 401 }
      );
    }

    // Fetch only this user's health logs
    const { data: healthLogs, error } = await supabase
      .from("health_logs")
      .select(
        "id, weight_kg, water_intake_ml, sleep_hours, steps, mood, notes, logged_at, created_at"
      )
      .eq("user_id", user.id)
      .order("logged_at", { ascending: false });

    // Handle database errors
    if (error) {
      console.error("Health logs fetch failed:", error.message);

      return NextResponse.json(
        { error: "Unable to fetch health logs" },
        { status: 500 }
      );
    }

    // Return the health logs as JSON
    return NextResponse.json({ healthLogs });
  } catch (error) {
    // Handle unexpected errors
    console.error("Health logs API error:", error);

    return NextResponse.json(
      { error: "Server configuration or internal error" },
      { status: 500 }
    );
  }
}
