# Python Cyber 연구회 세미나 실습

파이썬으로 보안 데이터를 다루는 연구회 세미나의 실습 자료입니다.
회차별 폴더에 주피터 노트북과 데이터가 함께 들어 있으며, 각 노트북에는 코드 설명이 마크다운으로 붙어 있습니다.

---

## 실습 회차

| 회차 | 폴더 | 주제 | 사용 데이터 |
|---|---|---|---|
| 1 | [`01-data-preprocessing`](01-data-preprocessing) | 데이터 분할 · 표준화 · 주성분분석 | 북한 미사일 발사 기록, PE 헤더 |

---

## 준비 방법 1 — 내 컴퓨터에서 실습하기 (권장)

파이썬만 설치되어 있으면 나머지는 스크립트가 알아서 처리합니다.

### 0단계. 미리 설치해 둘 것

| 프로그램 | 확인 방법 | 없다면 |
|---|---|---|
| **Python 3.10 이상** | 터미널에 `python3 --version` (Windows는 `py --version`) | [python.org/downloads](https://www.python.org/downloads/) |
| **Git** | `git --version` | [git-scm.com](https://git-scm.com/downloads) |
| **VS Code** | — | [code.visualstudio.com](https://code.visualstudio.com/) |

> **Windows 사용자 주의**
> 파이썬 설치 화면 맨 아래의 **`Add python.exe to PATH`** 를 반드시 체크하세요.
> 체크하지 않으면 설치는 되지만 명령어로 실행할 수 없어 스크립트가 파이썬을 찾지 못합니다.

### 1단계. 저장소 내려받기

```bash
git clone https://github.com/hedgehog-TechnicalSeminar/python-cyber-seminar.git
cd python-cyber-seminar
```

> Git 사용이 익숙하지 않다면 GitHub 페이지 오른쪽 위 초록색 **Code → Download ZIP** 으로 받아 압축을 풀어도 됩니다.

### 2단계. 환경 자동 구성

**Windows**

`setup.bat` 파일을 **더블클릭**합니다.
검은 창이 열리고 설치가 진행되며, 몇 분 뒤 "준비가 끝났습니다" 메시지가 나오면 완료입니다.

> PowerShell을 직접 쓰고 싶다면 `.\setup.ps1` 을 실행하세요.
> 실행 정책 오류가 나면 `setup.bat` 을 이용하면 됩니다. 이 문제를 피하도록 만든 파일입니다.

**macOS**

터미널에서 아래 두 줄을 실행합니다.

```bash
chmod +x setup.sh
./setup.sh
```

두 경우 모두 다음 작업이 자동으로 이루어집니다.

1. 파이썬 3.10 이상을 찾음
2. `.venv` 가상환경 생성
3. `requirements.txt` 의 패키지 설치
4. 주피터 커널 등록

### 3단계. 노트북 실행

**VS Code를 쓰는 경우**

1. VS Code로 `python-cyber-seminar` 폴더를 엽니다. (파일 하나가 아니라 **폴더 전체**를 열어야 합니다)
2. 확장 프로그램 추천 알림이 뜨면 설치합니다. (Python, Jupyter)
3. 회차 폴더의 `.ipynb` 파일을 엽니다.
4. 오른쪽 위 **커널 선택** 을 눌러 `.venv` 또는 `Python Cyber 세미나` 를 고릅니다.
5. 셀 왼쪽 실행 버튼을 누르거나 `Shift + Enter` 로 위에서부터 차례로 실행합니다.

**JupyterLab을 쓰는 경우**

```bash
# Windows
.\.venv\Scripts\Activate.ps1
jupyter lab

# macOS
source .venv/bin/activate
jupyter lab
```

---

## 준비 방법 2 — Google Colab에서 실습하기

설치가 잘 되지 않거나 노트북 사양이 부족할 때 사용하세요. 브라우저와 구글 계정만 있으면 됩니다.

1. [Google Colab](https://colab.research.google.com/) 접속
2. **GitHub** 탭 선택 후 `hedgehog-TechnicalSeminar/python-cyber-seminar` 검색
3. 원하는 회차의 `.ipynb` 선택
4. **맨 위의 `Google Colab 준비 셀` 을 가장 먼저 실행** — 저장소와 데이터 파일을 자동으로 내려받습니다
5. 이후 셀을 순서대로 실행

> 이 준비 셀은 로컬에서 실행하면 아무 일도 하지 않고 넘어가므로, 어느 환경에서든 그대로 두고 쓰면 됩니다.

**알아둘 점**

- 일정 시간 조작이 없으면 세션이 끊기며, 이 경우 준비 셀부터 다시 실행해야 합니다.
- Colab에는 pandas, numpy, scikit-learn이 이미 설치되어 있어 별도 설치가 필요 없습니다.

---

## 실습 중 자주 겪는 문제

<details>
<summary><b>커널을 선택하라는 창이 뜨거나 ipykernel을 설치하라고 합니다</b></summary>

VS Code가 가상환경을 아직 못 찾은 상태입니다.
오른쪽 위 커널 선택 → `Python 환경` → `.venv` 를 고르세요.
목록에 없으면 VS Code를 완전히 껐다가 폴더를 다시 열어 보세요.
</details>

<details>
<summary><b>FileNotFoundError: 'north_korea_missile_test_database.csv'</b></summary>

CSV 파일은 노트북과 같은 폴더에 있으며, 코드가 상대 경로로 읽습니다.
저장소를 통째로 받지 않고 노트북 파일만 따로 옮겼다면 이 오류가 납니다. 폴더 전체를 유지한 채 실행하세요.

VS Code라면 `.vscode/settings.json` 의 `jupyter.notebookFileRoot` 설정이 이 문제를 막아 줍니다.
저장소를 통째로 열지 않고 회차 폴더만 열었다면 설정이 적용되지 않으니 **루트 폴더를 여세요.**
</details>

<details>
<summary><b>Windows에서 "이 시스템에서 스크립트를 실행할 수 없으므로" 오류</b></summary>

PowerShell 실행 정책 때문입니다. `setup.ps1` 대신 **`setup.bat` 을 더블클릭**하세요.
정책을 직접 바꾸려면 PowerShell에서 아래를 실행합니다.

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```
</details>

<details>
<summary><b>파이썬을 찾을 수 없다고 나옵니다 (Windows)</b></summary>

설치할 때 `Add python.exe to PATH` 를 체크하지 않은 경우입니다.
파이썬을 다시 설치하면서 해당 항목을 체크하거나, 설치 파일을 다시 실행해 `Modify` → `Add to PATH` 를 선택하세요.

Microsoft Store 버전 파이썬은 문제가 생기는 경우가 있으니 python.org 설치본을 권장합니다.
</details>

<details>
<summary><b>패키지 설치가 중간에 실패합니다</b></summary>

사내망 프록시나 보안 프로그램이 원인인 경우가 많습니다.
개인 네트워크에서 다시 시도하거나, **Google Colab으로 실습**하세요.
</details>

<details>
<summary><b>노트북에 이전 실행 결과가 남아 헷갈립니다</b></summary>

메뉴에서 `Restart Kernel and Run All Cells` 를 실행하면 처음부터 다시 계산됩니다.
노트북은 셀을 실행한 순서대로 상태가 쌓이므로, **항상 위에서부터 순서대로** 실행하는 것이 안전합니다.
</details>

---

## 폴더 구조

```
python-cyber-seminar/
├── README.md                     이 문서
├── CONTRIBUTING.md               다음 발표자를 위한 자료 제작 가이드
├── requirements.txt              공통 패키지 목록
├── setup.sh                      환경 구성 (macOS)
├── setup.bat / setup.ps1         환경 구성 (Windows)
├── .vscode/                      VS Code 공용 설정
└── 01-data-preprocessing/        1회차
    ├── 01.ipynb ~ 03.ipynb
    ├── *.csv
    └── reference/                작성 과정에서 참고한 원본 노트북
```

---

## 다음 발표자에게

자료를 새로 만들어 올리는 방법은 [CONTRIBUTING.md](CONTRIBUTING.md) 에 정리해 두었습니다.
회차 폴더를 하나 추가하고 README의 회차 표에 한 줄을 더하는 것이 전부입니다.
