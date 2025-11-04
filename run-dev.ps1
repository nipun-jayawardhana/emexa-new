# run-dev.ps1 - Start backend and frontend in separate PowerShell windows
# Usage: Right-click and Run with PowerShell, or run from PowerShell: .\run-dev.ps1

$repo = Split-Path -Parent $MyInvocation.MyCommand.Definition
$backend = Join-Path $repo 'backend'
$frontend = Join-Path $repo 'frontend'
$venvPython = Join-Path $backend 'venv\Scripts\python.exe'

Write-Host "Repository root: $repo"

# Create venv and install requirements if missing
if (-not (Test-Path $venvPython)) {
    Write-Host "Creating Python virtual environment for backend..."
    python -m venv (Join-Path $backend 'venv')
    & (Join-Path $backend 'venv\Scripts\python.exe') -m pip install --upgrade pip
    & (Join-Path $backend 'venv\Scripts\python.exe') -m pip install -r (Join-Path $backend 'requirements.txt')
}

# Start backend in a new PowerShell window
$backendCmd = "Set-Location '$backend'; & '$venvPython' '$backend\app.py'"
Start-Process powershell -ArgumentList "-NoExit","-Command","$backendCmd"

# Start frontend in a new PowerShell window
$frontendCmd = "Set-Location '$frontend'; npm run dev"
Start-Process powershell -ArgumentList "-NoExit","-Command","$frontendCmd"

Write-Host "Launched backend and frontend in separate PowerShell windows."
Write-Host "Backend: http://127.0.0.1:5000"
Write-Host "Frontend: http://localhost:5173 (or the port Vite prints)"
