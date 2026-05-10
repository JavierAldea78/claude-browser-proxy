# Lanzador Claude — alternativa PowerShell al .bat
# Ejecutar: powershell -ExecutionPolicy Bypass -File launch-claude.ps1

$password  = "Q2CjSkjHZFDr0LLeaXzpg"
$url       = "https://claude:$password@claude-browser-production.up.railway.app/vnc.html?autoconnect=true&resize=remote"

$edge   = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"

$args = @("--app=$url", "--window-size=1920,1080")

if (Test-Path $edge) {
    Start-Process $edge $args
} elseif (Test-Path $chrome) {
    Start-Process $chrome $args
} else {
    Start-Process $url
}
