#!/usr/bin/env bash
# Deploy der Markisen-Lead-Kampagne-Vorschau auf GitHub Pages (Account dionizuz).
# Ausführen:  ! bash "/Users/valentinhering/Documents/Claude Code/Client Ops/FT Work & Design/Lead Magnets/Markise/Client Showcase/deploy.sh"
set -e
cd "$(dirname "$0")"

REPO="markisenguide-kampagne-preview"
OWNER="dionizuz"

if [ ! -d .git ]; then
  git init -b main -q
fi
git add -A
git commit -q -m "Markisen Lead-Kampagne Showcase" || echo "nichts Neues zu committen"

# Repo anlegen + pushen (falls noch nicht vorhanden)
if ! gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  gh repo create "$REPO" --public --source=. --push
else
  git push -u origin main
fi

# GitHub Pages aktivieren (Klammer-Felder gequotet -> kein Shell-Glob-Problem)
gh api --method POST "repos/$OWNER/$REPO/pages" \
  -f "source[branch]=main" -f "source[path]=/" 2>/dev/null \
  || echo "Pages war evtl. schon aktiv."

echo ""
echo "Fertig. URL (1-2 Min. Build-Zeit):"
echo "https://$OWNER.github.io/$REPO/   (Passwort: markise)"
