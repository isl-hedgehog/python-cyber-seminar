# ============================================================
#  연구회 세미나 실습 환경 자동 구성 (Windows)
#  사용법 : setup.bat 을 더블클릭하거나, PowerShell 에서  .\setup.ps1
# ============================================================
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

Write-Host ""
Write-Host "=============================================="
Write-Host "  세미나 실습 환경을 구성합니다"
Write-Host "=============================================="
Write-Host ""

# ---------- 1. 파이썬 찾기 ----------
Write-Host "[1/4] 파이썬 확인"
$PY = $null

# py 런처를 우선 사용 (버전 지정이 확실함)
foreach ($ver in @("3.13", "3.12", "3.11", "3.10")) {
    try {
        & py "-$ver" -c "import sys" 2>$null
        if ($LASTEXITCODE -eq 0) { $PY = @("py", "-$ver"); break }
    } catch { }
}

# py 런처가 없으면 python 명령을 확인
if (-not $PY) {
    $cmd = Get-Command python -ErrorAction SilentlyContinue
    if ($cmd) {
        # Microsoft Store 앱 실행 별칭(빈 껍데기)인지 확인
        if ($cmd.Source -notlike "*WindowsApps*") {
            & python -c "import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)" 2>$null
            if ($LASTEXITCODE -eq 0) { $PY = @("python") }
        }
    }
}

if (-not $PY) {
    Write-Host ""
    Write-Host "  [오류] 파이썬 3.10 이상을 찾을 수 없습니다." -ForegroundColor Red
    Write-Host ""
    Write-Host "  https://www.python.org/downloads/ 에서 설치한 뒤 다시 실행해 주세요."
    Write-Host "  설치 화면 맨 아래의 [Add python.exe to PATH] 를 반드시 체크해야 합니다." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  설치가 어려우면 README.md 의 'Google Colab으로 실습하기' 항목을 이용하세요."
    Write-Host ""
    Read-Host "엔터를 누르면 종료합니다"
    exit 1
}
$버전 = & $PY[0] $PY[1..($PY.Length-1)] --version
Write-Host "      사용할 파이썬 : $버전"

# ---------- 2. 가상환경 만들기 ----------
Write-Host "[2/4] 가상환경(.venv) 생성"
if (Test-Path ".venv") {
    Write-Host "      이미 존재하므로 그대로 사용합니다."
} else {
    & $PY[0] $PY[1..($PY.Length-1)] -m venv .venv
    Write-Host "      생성 완료"
}
$VENV_PY = ".\.venv\Scripts\python.exe"

# ---------- 3. 패키지 설치 ----------
Write-Host "[3/4] 패키지 설치 (수 분 소요될 수 있습니다)"
& $VENV_PY -m pip install --upgrade pip --quiet
& $VENV_PY -m pip install -r requirements.txt --quiet
if ($LASTEXITCODE -ne 0) {
    Write-Host "  [오류] 패키지 설치에 실패했습니다." -ForegroundColor Red
    Write-Host "  사내망 프록시나 보안 프로그램이 원인일 수 있습니다. README.md 의 문제 해결 항목을 확인해 주세요."
    Read-Host "엔터를 누르면 종료합니다"
    exit 1
}
Write-Host "      설치 완료"

# ---------- 4. 주피터 커널 등록 ----------
Write-Host "[4/4] 주피터 커널 등록"
& $VENV_PY -m ipykernel install --user --name python-cyber --display-name "Python Cyber 세미나" | Out-Null
Write-Host "      완료"

# ---------- 검증 ----------
Write-Host ""
Write-Host "----- 설치 확인 -----"
& $VENV_PY -c "import importlib; [print(f'  {n:12} ' + getattr(importlib.import_module(n), '__version__', '?')) for n in ('pandas','numpy','sklearn','ipykernel')]"

Write-Host ""
Write-Host "=============================================="
Write-Host "  준비가 끝났습니다"
Write-Host ""
Write-Host "  다음 중 편한 방법으로 실습을 시작하세요."
Write-Host ""
Write-Host "  1) VS Code"
Write-Host "     - 이 폴더를 열고 노트북 파일(.ipynb)을 실행"
Write-Host "     - 오른쪽 위 커널 선택에서 '.venv' 또는"
Write-Host "       'Python Cyber 세미나' 를 고르면 됩니다"
Write-Host ""
Write-Host "  2) JupyterLab (PowerShell 에서)"
Write-Host "     .\.venv\Scripts\Activate.ps1"
Write-Host "     jupyter lab"
Write-Host ""
Write-Host "=============================================="
Write-Host ""
Read-Host "엔터를 누르면 창이 닫힙니다"
