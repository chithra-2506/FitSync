import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function GET() {
  try {
    const supabase = await createClient();

    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        { error: "Unauthorized" },
        { status: 401 }
      );
    }

    const { data: profile, error } = await supabase
      .from("profiles")
      .select("id, display_name, date_of_birth, height_cm, created_at, updated_at")
      .eq("id", user.id)
      .maybeSingle();

    if (error) {
      console.error("Profile fetch failed:", error.message);
      return NextResponse.json(
        { error: "Unable to fetch profile" },
        { status: 500 }
      );
    }

    return NextResponse.json({ profile });
  } catch (error) {
    console.error("Profile API error:", error);
    return NextResponse.json(
      { error: "Server configuration or internal error" },
      { status: 500 }
    );
  }
}