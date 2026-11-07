# Task for Everett: register two free API keys

Goal: let the data pipeline pull from two more opportunity sources. Keys stay on your laptop only.

1. Simpler.Grants.gov key: sign up at https://simpler.grants.gov/developer and create an API key.
2. SAM.gov key: create a SAM.gov account at https://sam.gov, open Account Details, request a public API key. Without a role the limit is 10 requests a day.
3. Put both in `Finalists/.Renviron` (gitignored), one per line, no quotes:
   - `SIMPLER_GRANTS_KEY=...`
   - `SAM_API_KEY=...`
4. Never paste a key in chat, a file in the repo, a commit or a screenshot. Restart R after editing `.Renviron`.
5. Tell Kent "keys set". Kent's Claude will run `02e_simpler_grants.R` and `02f_sam_assistance_listings.R` on your laptop.

Done means: `Sys.getenv("SIMPLER_GRANTS_KEY")` and `Sys.getenv("SAM_API_KEY")` are not empty in R.
