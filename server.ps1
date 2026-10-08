# ==============================================================================
# Recruiting Agent Control Tower - Local HTTP Server & Mock API Backend
# Built with native .NET HttpListener (no external dependencies needed)
# ==============================================================================

param(
    [int]$Port = 8080
)

$baseDir = $PSScriptRoot
if (-not $baseDir) { $baseDir = Get-Location }

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
    Write-Host ""
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "  RECRUITING AGENT CONTROL TOWER (SW-06) - SERVER RUNNING" -ForegroundColor Green
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host "  * Web Interface:  http://localhost:$Port" -ForegroundColor Yellow
    Write-Host "  * REST API:       http://localhost:$Port/api/candidates" -ForegroundColor Yellow
    Write-Host "  * Press Ctrl+C in this terminal to stop the server" -ForegroundColor Gray
    Write-Host "================================================================================" -ForegroundColor Cyan
    Write-Host ""
}
catch {
    Write-Host "Failed to start listener on port $Port : $_" -ForegroundColor Red
    exit 1
}

# Auto-open browser
Start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "http://localhost:$Port" -ErrorAction SilentlyContinue

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $urlPath = $request.Url.LocalPath
        Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] $($request.HttpMethod) $urlPath" -ForegroundColor DarkGray

        # Add CORS headers
        $response.Headers.Add("Access-Control-Allow-Origin", "*")
        $response.Headers.Add("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        $response.Headers.Add("Access-Control-Allow-Headers", "Content-Type")

        if ($request.HttpMethod -eq "OPTIONS") {
            $response.StatusCode = 200
            $response.Close()
            continue
        }

        # Mock API Endpoints
        if ($urlPath -eq "/api/status") {
            $json = '{"status":"operational","agentsOnline":4,"totalAgents":5,"hitlExceptions":2,"slaCoverage":"100%"}'
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
            $response.ContentType = "application/json"
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.Close()
            continue
        }

        # Static File Serving
        $filePath = Join-Path $baseDir "index.html"
        if ($urlPath -ne "/" -and $urlPath -ne "") {
            $subPath = $urlPath.TrimStart("/").Replace("/", "\")
            $candidatePath = Join-Path $baseDir $subPath
            if (Test-Path $candidatePath -PathType Leaf) {
                $filePath = $candidatePath
            }
        }

        if (Test-Path $filePath -PathType Leaf) {
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            switch ($extension) {
                ".html" { $response.ContentType = "text/html; charset=utf-8" }
                ".css"  { $response.ContentType = "text/css; charset=utf-8" }
                ".js"   { $response.ContentType = "application/javascript; charset=utf-8" }
                ".json" { $response.ContentType = "application/json; charset=utf-8" }
                default { $response.ContentType = "application/octet-stream" }
            }

            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        }
        else {
            $response.StatusCode = 404
            $errBytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
        }

        $response.Close()
    }
    catch {
        # Handle client aborts / terminations gracefully
    }
}
