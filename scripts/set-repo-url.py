"""저장소 주소를 README와 모든 노트북의 Colab 준비 셀에 일괄 반영한다.

사용법:
    python scripts/set-repo-url.py <ORG이름> <저장소이름>

예:
    python scripts/set-repo-url.py cyber-research-lab python-cyber-seminar
"""

import pathlib
import sys

기본_ORG = "YOUR-ORG"
기본_저장소 = "python-cyber-seminar"


def 대상_파일(루트: pathlib.Path) -> list[pathlib.Path]:
    파일 = [p for p in 루트.rglob("*.ipynb") if ".venv" not in p.parts]
    파일 += [루트 / "README.md", 루트 / "CONTRIBUTING.md"]
    return [p for p in 파일 if p.exists()]


def 치환(경로: pathlib.Path, 이전: str, 이후: str) -> bool:
    본문 = 경로.read_text(encoding="utf-8")
    if 이전 not in 본문:
        return False
    경로.write_text(본문.replace(이전, 이후), encoding="utf-8")
    return True


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__)
        return 1

    org, 저장소 = sys.argv[1], sys.argv[2]
    루트 = pathlib.Path(__file__).resolve().parent.parent

    바뀐_파일 = 0
    for 경로 in 대상_파일(루트):
        결과 = 치환(경로, f"{기본_ORG}/{기본_저장소}", f"{org}/{저장소}")
        결과 |= 치환(경로, 기본_저장소, 저장소)
        if 결과:
            바뀐_파일 += 1
            print(f"  수정 {경로.relative_to(루트)}")

    print(f"\n{바뀐_파일}개 파일 수정 완료 → https://github.com/{org}/{저장소}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
