#!/usr/bin/env bash
# ============================================================
#  연구회 세미나 실습 환경 자동 구성 (macOS / Linux)
#  사용법 : 터미널에서  ./setup.sh
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

echo ""
echo "=============================================="
echo "  세미나 실습 환경을 구성합니다"
echo "=============================================="
echo ""

# ---------- 1. 파이썬 찾기 ----------
echo "[1/4] 파이썬 확인"
PY=""
for c in python3.13 python3.12 python3.11 python3.10 python3 python; do
    if command -v "$c" >/dev/null 2>&1; then
        if "$c" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' 2>/dev/null; then
            PY="$c"
            break
        fi
    fi
done

if [ -z "$PY" ]; then
    echo ""
    echo "  [오류] 파이썬 3.10 이상을 찾을 수 없습니다."
    echo ""
    echo "  아래 중 한 가지 방법으로 설치한 뒤 이 스크립트를 다시 실행해 주세요."
    echo "    - 공식 설치 파일 : https://www.python.org/downloads/"
    echo "    - Homebrew       : brew install python@3.12"
    echo ""
    echo "  설치가 어려우면 README.md 의 'Google Colab으로 실습하기' 항목을 이용하세요."
    exit 1
fi
echo "      사용할 파이썬 : $("$PY" --version 2>&1)  ($(command -v "$PY"))"

# ---------- 2. 가상환경 만들기 ----------
echo "[2/4] 가상환경(.venv) 생성"
if [ -d ".venv" ]; then
    echo "      이미 존재하므로 그대로 사용합니다."
else
    "$PY" -m venv .venv
    echo "      생성 완료"
fi
VENV_PY=".venv/bin/python"

# ---------- 3. 패키지 설치 ----------
echo "[3/4] 패키지 설치 (수 분 소요될 수 있습니다)"
"$VENV_PY" -m pip install --upgrade pip --quiet
if command -v uv >/dev/null 2>&1; then
    echo "      uv 를 사용해 빠르게 설치합니다."
    VIRTUAL_ENV="$(pwd)/.venv" uv pip install -r requirements.txt --quiet
else
    "$VENV_PY" -m pip install -r requirements.txt --quiet
fi
echo "      설치 완료"

# ---------- 4. 주피터 커널 등록 ----------
echo "[4/4] 주피터 커널 등록"
"$VENV_PY" -m ipykernel install --user \
    --name python-cyber \
    --display-name "Python Cyber 세미나" >/dev/null 2>&1
echo "      완료"

# ---------- 검증 ----------
echo ""
echo "----- 설치 확인 -----"
"$VENV_PY" - <<'PYEOF'
import importlib
for 이름 in ("pandas", "numpy", "sklearn", "ipykernel"):
    m = importlib.import_module(이름)
    print(f"  {이름:12} {getattr(m, '__version__', '?')}")
PYEOF

cat <<'MSG'

==============================================
  준비가 끝났습니다

  다음 중 편한 방법으로 실습을 시작하세요.

  1) VS Code
     - 이 폴더를 열고 노트북 파일(.ipynb)을 실행
     - 오른쪽 위 커널 선택에서 ".venv" 또는
       "Python Cyber 세미나" 를 고르면 됩니다

  2) JupyterLab (터미널에서)
     source .venv/bin/activate
     jupyter lab

==============================================
MSG
