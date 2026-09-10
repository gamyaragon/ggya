# Prescription of Crimes Calculator

Public static website prepared for Vercel.

## Vercel settings

- Framework Preset: Other
- Root Directory: repository root
- Build Command: leave empty
- Output Directory: leave empty
- Project Name: `ggya`

If the project name is available, the production address will be
`https://ggya.vercel.app`.

Keep Deployment Protection disabled for the production environment so the
calculator can be opened by anyone.

## Activate the public counters

1. Open your Supabase project and go to **SQL Editor**.
2. Run the complete `supabase-counter-setup.sql` file once.
3. Open **Project Settings → API** in Supabase.
4. Copy the Project URL and anon/public key into `counter-config.js`.
5. Upload all files to GitHub and commit them. Vercel will redeploy automatically.

The visitor total counts one visit per browser/device. Calculations Made increases only after a valid result is successfully computed. The counter does not store names, case details, entered dates, or IP addresses.
