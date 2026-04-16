# ================================
# INSTALLATION PROJET DASHBOARD
# Version sécurisée (sans Here-Strings)
# ================================

function Write-Short {
    param([string]$msg)
    Write-Host $msg -ForegroundColor Cyan
}

function Ensure-Directory {
    param([string]$path)

    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Short "[+] Dossier créé : $path"
    }
}

function Write-FileSafe {
    param(
        [string]$filePath,
        [string[]]$lines
    )

    if (Test-Path $filePath) {
        $resp = Read-Host "[?] $filePath existe - écraser ? (O/N)"
        if ($resp -ne "O" -and $resp -ne "o") {
            Write-Short "[ ] Ignoré : $filePath"
            return
        }
    }

    Set-Content -Path $filePath -Value $lines -Encoding UTF8
    Write-Short "[+] Fichier écrit : $filePath"
}

# ================================
# ARBORESCENCE
# ================================

Write-Short "Création de l'arborescence..."

Ensure-Directory "backend"
Ensure-Directory "backend/app"
Ensure-Directory "backend/app/routers"
Ensure-Directory "backend/app/models"
Ensure-Directory "backend/app/services"
Ensure-Directory "backend/app/core"

Ensure-Directory "frontend"
Ensure-Directory "frontend/src"
Ensure-Directory "frontend/src/components"
Ensure-Directory "frontend/public"

Ensure-Directory "scripts"

# ================================
# BACKEND FILES
# ================================

Write-Short "Création des fichiers backend..."

Write-FileSafe "backend/app/main.py" @(
"from fastapi import FastAPI"
"from app.routers import example"
""
"app = FastAPI(title='Gestion Boutique Dashboard API')"
""
"app.include_router(example.router)"
""
"@app.get('/')"
"def root():"
"    return {'message': 'API opérationnelle'}"
)

Write-FileSafe "backend/app/routers/example.py" @(
"from fastapi import APIRouter"
""
"router = APIRouter(prefix='/example', tags=['Example'])"
""
"@router.get('/')"
"def example_route():"
"    return {'status': 'ok', 'message': 'Route example fonctionnelle'}"
)

Write-FileSafe "backend/app/core/config.py" @(
"class Settings:"
"    APP_NAME = 'Gestion Boutique Dashboard'"
"    VERSION = '1.0.0'"
""
"settings = Settings()"
)

Write-FileSafe "backend/app/core/security.py" @(
"# Placeholder pour futures fonctions de sécurité"
"def verify_token(token: str):"
"    return True"
)

Write-FileSafe "backend/requirements.txt" @(
"fastapi"
"uvicorn"
)

Write-FileSafe "backend/run_backend.ps1" @(
"uvicorn app.main:app --reload --port 8000"
)

# ================================
# FRONTEND FILES
# ================================

Write-Short "Création des fichiers frontend..."

Write-FileSafe "frontend/package.json" @(
"{"
"  ""name"": ""gestion-boutique-dashboard"","
"  ""version"": ""1.0.0"","
"  ""scripts"": {"
"    ""dev"": ""vite"","
"    ""build"": ""vite build"","
"    ""preview"": ""vite preview"""
"  },"
"  ""dependencies"": {"
"    ""react"": ""^18.2.0"","
"    ""react-dom"": ""^18.2.0"""
"  },"
"  ""devDependencies"": {"
"    ""vite"": ""^5.0.0"","
"    ""@vitejs/plugin-react"": ""^4.0.0"""
"  }"
"}"
)

Write-FileSafe "frontend/vite.config.js" @(
"import { defineConfig } from 'vite'"
"import react from '@vitejs/plugin-react'"
""
"export default defineConfig({"
"  plugins: [react()]"
"})"
)

Write-FileSafe "frontend/src/main.jsx" @(
"import React from 'react'"
"import ReactDOM from 'react-dom/client'"
"import App from './App'"
""
"ReactDOM.createRoot(document.getElementById('root')).render("
"    <App />"
")"
)

Write-FileSafe "frontend/src/App.jsx" @(
"export default function App() {"
"    return ("
"        <div style={{ padding: 20 }}>"
"            <h1>Gestion Boutique Dashboard</h1>"
"            <p>Frontend opérationnel</p>"
"        </div>"
"    )"
"}"
)

Write-FileSafe "frontend/run_frontend.ps1" @(
"npm install"
"npm run dev"
)

# ================================
# GLOBAL SCRIPTS
# ================================

Write-Short "Création des scripts globaux..."

Write-FileSafe "scripts/start_all.ps1" @(
"Start-Process powershell -ArgumentList 'cd ../backend; uvicorn app.main:app --reload'"
"Start-Process powershell -ArgumentList 'cd ../frontend; npm run dev'"
)

Write-FileSafe "scripts/stop_all.ps1" @(
"Get-Process -Name node -ErrorAction SilentlyContinue | Stop-Process -Force"
"Get-Process -Name python -ErrorAction SilentlyContinue | Stop-Process -Force"
)

# ================================
# ROOT FILES
# ================================

Write-Short "Création des fichiers racine..."

Write-FileSafe ".gitignore" @(
"__pycache__/"
"node_modules/"
".env"
".vscode/"
)

Write-FileSafe "README.md" @(
"# Gestion Boutique Dashboard"
""
"Projet complet (FastAPI + React) généré automatiquement."
""
"## Backend"
"cd backend"
"uvicorn app.main:app --reload"
""
"## Frontend"
"cd frontend"
"npm install"
"npm run dev"
)

Write-Short "Installation terminée."