"""Assemble the GitHub Pages site in docs/ from the built deliverables.

Run from src/ after the tool and notebook are built:  python3 build_site.py
GitHub Pages serves docs/ from the main branch (Settings > Pages > Deploy from a branch > main /docs).

docs/index.html        landing page (from src/site/index.html; numbers filled from payload.json)
docs/tool.html         outs/grant-triage-tool.html
docs/notebook.html     outs/solveathon_project.html
docs/downloads/        top results (.xlsx, .csv)
docs/figures/          chart used on the landing page
"""
import datetime, json, os, shutil

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTS, DOCS = os.path.join(ROOT, "outs"), os.path.join(ROOT, "docs")
REPO = "https://github.com/KApolloL/SolveAThon_2026"

COPIES = {
    "grant-triage-tool.html": "tool.html",
    "solveathon_project.html": "notebook.html",
    "top_results.xlsx": "downloads/top_results.xlsx",
    "top_results.csv": "downloads/top_results.csv",
    "figures/01_funnel_nih_haystack.png": "figures/01_funnel_nih_haystack.png",
}

# Never publish anything that contains the Census key.
key = ""
renv = os.path.join(ROOT, ".Renviron")
if os.path.exists(renv):
    for line in open(renv):
        if line.startswith("CENSUS_API_KEY="):
            key = line.split("=", 1)[1].strip().strip('"')

if os.path.isdir(DOCS):
    shutil.rmtree(DOCS)
os.makedirs(DOCS)
for src, dst in COPIES.items():
    s, d = os.path.join(OUTS, src), os.path.join(DOCS, dst)
    if not os.path.exists(s):
        raise SystemExit(f"Missing {s}: build the tool, notebook, top results and slide figures first.")
    os.makedirs(os.path.dirname(d), exist_ok=True)
    shutil.copyfile(s, d)
    if key and key.encode() in open(d, "rb").read():
        raise SystemExit(f"Refusing to publish {dst}: it contains the Census API key.")

p = json.load(open(os.path.join(ROOT, "data", "processed", "payload.json")))
c = p["golden"]["opening_counts"]
fill = {
    "TOTAL": f"{p['meta']['source_rows']:,}", "TIER1": str(c.get("tier1", 0)), "TIER2": str(c.get("tier2", 0)),
    "TIER3": str(c.get("tier3", 0)), "TIER4": str(c.get("tier4", 0)),
    "OPEN_STATE": str(p["golden"]["fact_universe_count"]), "NIH": str(p["golden"]["fact_nih_count"]),
    "PULL_DATE": datetime.date.fromisoformat(p["meta"]["pull_date"]).strftime("%B %-d, %Y"),
    "MODEL": p["meta"]["llm_model"], "BUILT": datetime.date.today().strftime("%B %-d, %Y"), "REPO": REPO,
}
page = open(os.path.join(ROOT, "src", "site", "index.html"), encoding="utf-8").read()
for k, v in fill.items():
    page = page.replace("{{" + k + "}}", v)
if "{{" in page:
    raise SystemExit("Unfilled placeholder in the landing page.")
open(os.path.join(DOCS, "index.html"), "w", encoding="utf-8").write(page)
open(os.path.join(DOCS, ".nojekyll"), "w").close()   # serve files as-is, no Jekyll processing

size = sum(os.path.getsize(os.path.join(dp, f)) for dp, _, fs in os.walk(DOCS) for f in fs)
print(f"Built {DOCS} ({size / 1e6:.1f} MB): " + ", ".join(sorted(["index.html"] + list(COPIES.values()))))
