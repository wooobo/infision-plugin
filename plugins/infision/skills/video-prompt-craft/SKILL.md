---
name: video-prompt-craft
description: infision 캔버스 video-generate 로 영상을 만들 때 provider별 작법(Kling · Seedance/Atlas)을 프롬프트에 반영하기 위한 번들. 프롬프트 구조·카메라/모션·대사/립싱크·오디오·캐릭터 정합·스타일을 고른 provider 작법에 맞춰 생성 프롬프트에 반영한다.
---

# 영상 프롬프트 작법 번들 (infision video-generate)

영상 생성 프롬프트는 **고른 provider 의 작법 파일**을 읽어 반영한다.

- **고유명사 금지** — 감독/스튜디오/작가/브랜드·IP/실존인물은 시각 속성으로 분해한다.
- 정적 묘사("cinematic 4K beautiful")는 모션 단서를 거의 안 준다 — **무엇이 어떻게 움직이고 카메라가 뭘 하는지**를 쓴다.
- 길이·화질·화면비·모델은 **프롬프트 문자열이 아니라 설정**(승인 카드)이다 — 프롬프트에 넣지 않는다.

## Kling

| 파일 | 내용 |
| --- | --- |
| `kling-prompt-craft.md` | 프롬프트 구조·가중치·Syntax 2.0·물리·네거티브 |
| `kling-camera-motion.md` | 카메라 무브·동작(달리기/점프)·모션 강도·fps |
| `kling-consistency.md` | 컷/시리즈 간 인물·제품 정합, 드리프트, 멀티캐릭터 |
| `kling-lighting.md` | 빛·시간대·색온도·포토리얼리즘 |
| `kling-style-recipes.md` | 분위기·장르·"○○풍" → 시각 속성 레시피 |
| `kling-capabilities.md` | 모드/길이/화질/오디오/멀티샷 선택, 능력 한계 |
| `kling-troubleshooting.md` | 증상→처방, 생성 전 품질 최적화 |
| `kling-audio-voice.md` | 대사·보이스 태그·립싱크·환경음 |
| `kling-motion-transfer.md` | 레퍼런스 영상의 동작을 정지 캐릭터에 이식 |

## Seedance

| 파일 | 내용 |
| --- | --- |
| `seedance-prompt-craft.md` | Seedance 2.0/fast — t2v/i2v/r2v·파라미터·대사/립싱크·오디오·카메라·Kling 과의 차이 |
