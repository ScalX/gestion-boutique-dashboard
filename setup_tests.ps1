Write-Host "=== Installation des tests automatiques Backend & Frontend ===" -ForegroundColor Cyan

# --- BACKEND ---
Write-Host "`n[Backend] Installation des dépendances Pytest..." -ForegroundColor Yellow
$backendReq = "backend/requirements.txt"

if (Test-Path $backendReq) {
    Add-Content $backendReq "`npytest"
    Add-Content $backendReq "pytest-asyncio"
    Add-Content $backendReq "httpx"
} else {
    Write-Host "Fichier requirements.txt introuvable !" -ForegroundColor Red
}

Write-Host "[Backend] Création du dossier tests..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path backend/tests | Out-Null

Write-Host "[Backend] Création du test test_api.py..." -ForegroundColor Yellow
@"
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()
"@ | Set-Content backend/tests/test_api.py


# --- FRONTEND ---
Write-Host "`n[Frontend] Installation des dépendances Vitest..." -ForegroundColor Yellow
Set-Location frontend
npm install --save-dev vitest @testing-library/react @testing-library/jest-dom

Write-Host "[Frontend] Mise à jour de vite.config.js..." -ForegroundColor Yellow
$viteConfig = "vite.config.js"
if (Test-Path $viteConfig) {
    (Get-Content $viteConfig) + "`nexport default { test: { environment: 'jsdom' } }" | Set-Content $viteConfig
}

Write-Host "[Frontend] Ajout du script test dans package.json..." -ForegroundColor Yellow
(Get-Content package.json) -replace '"scripts": {', '"scripts": { "test": "vitest",' | Set-Content package.json

Write-Host "[Frontend] Création du test App.test.jsx..." -ForegroundColor Yellow
@"
import { render, screen } from "@testing-library/react";
import App from "./App";

test("affiche le titre", () => {
  render(<App />);
  expect(screen.getByText("Gestion Boutique Dashboard")).toBeInTheDocument();
});
"@ | Set-Content src/App.test.jsx

Set-Location ..


# --- WORKFLOWS ---
Write-Host "`n[Mise à jour CI] Ajout des étapes de tests..." -ForegroundColor Yellow

$frontendCI = ".github/workflows/frontend-ci.yml"
$backendCI = ".github/workflows/backend-ci.yml"

# Ajout tests frontend
(Get-Content $frontendCI) + @"
      - name: Run tests
        working-directory: frontend
        run: npm test -- --run
"@ | Set-Content $frontendCI

# Ajout tests backend
(Get-Content $backendCI) + @"
      - name: Run tests
        working-directory: backend
        run: pytest -q
"@ | Set-Content $backendCI


Write-Host "`n=== Installation terminée ! ===" -ForegroundColor Green
Write-Host "Tu peux maintenant lancer : git add . ; git commit ; git push" -ForegroundColor Cyan
