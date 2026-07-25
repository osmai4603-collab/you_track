# Walkthrough - Fixed Projects Schema Mismatch

I have identified that the `PostgrestException (PGRST204)` is caused by a mismatch between the Flutter application's data model and the Supabase database schema. Specifically, the `projects` table was missing columns like `is_archived`.

## Changes

### Database Migration

I created a SQL script to synchronize the database schema with the application requirements.

- [fix_projects_schema.sql](file:///home/osmsoftwareengineering/flutter_projects/you_track/supabase/fix_projects_schema.sql): This script adds the missing columns (`is_archived`, `is_template`, etc.) and renames existing ones to match the app's expectations.

## Verification Plan

### Manual Verification Required

To resolve the error, please follow these steps:

1.  Open your [Supabase Dashboard](https://app.supabase.com/).
2.  Go to the **SQL Editor** section.
3.  Copy the content of [fix_projects_schema.sql](file:///home/osmsoftwareengineering/flutter_projects/you_track/supabase/fix_projects_schema.sql) and paste it into a new query.
4.  Run the query.
5.  Restart your Flutter application and try creating a project again.

> [!IMPORTANT]
> The application code removes the `id` field before inserting into Supabase, allowing the database to generate a valid `UUID`. This ensures compatibility with the UUID primary key in PostgreSQL.

> [!TIP]
> If you encounter any further "column not found" errors, it might be due to Supabase's schema cache. Running the script usually triggers a refresh, but in rare cases, you might need to wait a few minutes or manually reload the PostgREST configuration in the Supabase dashboard settings.
