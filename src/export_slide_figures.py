"""Save the charts used in the slides from the rendered notebook to outs/figures/.

Run after `quarto render solveathon_project.qmd` (from src/): python3 export_slide_figures.py
Charts are matched by their code-fold summary, so the file names stay right if sections move.
"""
import base64, html, os, re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NOTEBOOK = os.path.join(ROOT, "outs", "solveathon_project.html")
OUT = os.path.join(ROOT, "outs", "figures")
WANTED = {  # code-fold summary text -> file name
    "Funnel from the full file to the three piles": "01_funnel_nih_haystack",
    "Application window distribution": "02_application_windows",
    "Capability profiles as a heatmap": "03_capability_heatmap",
    "How the piles change with the writer": "04_piles_by_scenario",
    "Prompt v2 vs v3.1, chart": "05_prompt_tightening",
    "Agreement with the team, by field": "06_ai_accuracy_by_field",
    "Drug poisoning death rates by county": "07_overdose_map",
    "People served vs dollars per person": "08_reach_vs_intensity",
    "What is expected to post": "09_forecast_pipeline",
    "Rural, suburban and urban share": "10_population_rural_urban",
    "Target populations by congressional district": "11_population_by_district",
}

doc = open(NOTEBOOK, encoding="utf-8").read()
os.makedirs(OUT, exist_ok=True)
# Each cell: <summary>...</summary> ... first embedded PNG before the next cell's summary.
pieces = re.split(r"<summary>", doc)[1:]
found = {}
for piece in pieces:
    title = html.unescape(re.sub(r"<[^>]+>", "", piece.split("</summary>", 1)[0])).strip()
    img = re.search(r'src="data:image/png;base64,([A-Za-z0-9+/=]+)"', piece)
    for key, name in WANTED.items():
        if key in title and img and name not in found:
            with open(os.path.join(OUT, name + ".png"), "wb") as f:
                f.write(base64.b64decode(img.group(1)))
            found[name] = title
missing = sorted(set(WANTED.values()) - set(found))
print(f"Wrote {len(found)} figures to {OUT}" + (f"; missing: {missing}" if missing else ""))
