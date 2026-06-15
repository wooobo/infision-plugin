# 2단계 — Cinematic Storyboard Grid

하나의 연속 장면을 3x3·9패널로 설계한다. 캐릭터 시트가 정체성을 고정했다면, 여기서는 카메라 흐름과 장면 진행을 잡는다. infision `image-generate`로 한 장의 시트 이미지로 생성한다.

목표:

- 한 이미지 안 3x3 그리드, 9패널. 하나의 연속 장면을 왼쪽→오른쪽, 위→아래 순서로.
- 각 패널 아래 제작 노트 스트립.

핵심:

- 9개 독립 이미지가 아니라 **하나의 연속된 순간**이다. 캐릭터·공간 지리는 고정.
- 카메라는 하나의 연속 테이크를 9프레임으로 나눈 듯 움직인다.
- 화면비는 설정이다 — 가로형으로 두면 그리드가 넓게 배치된다. 프롬프트 문자열엔 넣지 않는다.

## 캐릭터 설명은 짧게

캐릭터 시트가 이미 정체성의 본체다. 여기서는 시각 고정용 한 문장만.

```text
RAVEN: Mid-40s, lean Asian man, silver-grey spiky hair, sleeveless ochre kung-fu robe, gold arm cuffs, barefoot.
```

## 패널 비트

3-12단어 짧은 지시.

좋은 예: `Panel 2 (top-center): Viper lunges, palm strike to sternum. Whip-pan with the motion.`
나쁜 예: `Panel 2 (top-center): Viper takes a sudden aggressive step forward and extends her right arm forcefully in a palm-strike motion aimed at Raven's sternum while the camera whip-pans dynamically to follow the action.`

## Annotation Strip

각 패널 아래 제작 노트는 세 줄. 슬러그 라인처럼 짧게, 완전한 문장 금지.

```text
CAM: [camera framing and movement]
MOVE: [what the subject does - short, punchy]
MOOD: [emotional / atmospheric beat]
```

세 번째 줄은 장르에 따라 바꾼다:

- `MOOD`: 드라마 · 댄스 · 시네마틱 내러티브
- `VOICE`: 브이로그 · 인플루언서 · 대화 장면
- `STYLE`: 액션 · 무술 · 격투 장면

예시:

```text
CAM: SLOW LOW ORBIT. WIDE.
MOVE: STANDOFF. CHERRY PETALS DRIFT BETWEEN.
MOOD: TENSION. STILLNESS BEFORE STRIKE.
```

```text
CAM: SELFIE CAM. CLOSE.
MOVE: HOLDS BOTTLE UP TO CAMERA.
VOICE: "OKAY GUYS, I FOUND IT."
```

```text
CAM: WHIP-PAN WITH LUNGE. MEDIUM.
MOVE: VIPER LUNGES, PALM STRIKE TO STERNUM.
STYLE: VIPER - SILAT (CEKAK SILAT) / VIPER'S BITE.
```

## 템플릿

`[GENRE/REFERENCE TONE]`·`[STYLE DESCRIPTORS]`에 고유명사("○○ 감독풍")를 쓰지 말고 시각 속성으로 분해한다.

```text
Create a cinematic storyboard sheet in a 3x3 grid format (9 panels arranged in 3 rows x 3 columns) depicting ONE CONTINUOUS [SCENE TYPE] between [NUMBER] characters.

Style: Cinematic, [GENRE/REFERENCE TONE], [STYLE DESCRIPTORS - e.g., live-action, photorealistic, lifelike, 35mm film grain]. Single wide page layout. No text, no captions, no panel numbers inside panels, only thin clean separators between panels.

UNDER EACH panel a thin off-white annotation strip with three short lines of production notes in a clean, high-contrast sans-serif font (must be legible at rendered size): CAM (camera framing/movement), MOVE (subject action), and MOOD (atmosphere). Substitute VOICE for MOOD on vlog/dialogue scenes, or STYLE for MOOD on action/martial-arts scenes. Notes must read as short, declarative slug lines - not full sentences.

CHARACTER LOCK - all characters must appear IDENTICAL across all 9 panels (same face, same build, same clothing, same props). Use the descriptions below as the source of truth. If reference images are attached, treat them as additional identity anchors and match them precisely.

[CHARACTER A]: [one tight sentence - distinguishing features, hair, key clothing color, key prop].
[CHARACTER B]: [same - one tight sentence].
[Add CHARACTER C / D only if needed.]

This is a CONTINUOUS [SCENE TYPE] - one [encounter / moment / exchange], one location, one unbroken flow of time. Same [LOCATION & ATMOSPHERE]. [EXCLUSIONS - anything that must NOT appear].

Camera moves naturally around the action as if shot in a single continuous take broken into 9 sequential beats.

Narrative - [SEQUENCE NAME] (read left-to-right, top-to-bottom):
Panel 1 (top-left): [Beat 1 - short, declarative].
Panel 2 (top-center): [Beat 2].
Panel 3 (top-right): [Beat 3].
Panel 4 (middle-left): [Beat 4].
Panel 5 (middle-center): [Beat 5].
Panel 6 (middle-right): [Beat 6].
Panel 7 (bottom-left): [Beat 7].
Panel 8 (bottom-center): [Beat 8].
Panel 9 (bottom-right): [Beat 9].
```
