# 1단계 — Character Sheet

캐릭터 정체성을 고정하는 레퍼런스 시트를 만든다. 이후 모든 샷의 시각 레퍼런스가 된다. infision `image-generate`(FLUX 2 / Nano Banana / GPT Image 2)로 생성하며, 모델별 문법은 `image-prompt-craft` 번들을 본다.

목표:

- 8샷 그리드.
- 상단 4컷: 전신 정면, 측면, 3/4, 후면.
- 하단 4컷: 각 각도에 대응하는 얼굴 클로즈업.

## 규칙

1. **레퍼런스 이미지가 있으면 이미지를 다시 장황하게 설명하지 않는다.** 이미지가 이미 시각 설명이다 — 텍스트는 렌더링 스타일 중심으로만.
2. **조명은 중립적으로.** 캐릭터 시트는 여러 장면에서 재사용할 기준 이미지다. 특정 장면의 달빛·네온·화염 림라이트를 넣으면 이후 샷까지 오염된다.
3. **배경은 단순하게.** 캐릭터 디자인에 집중하도록 방해되지 않아야 한다.
4. **화면비는 설정이다.** 그리드가 가로로 넓게 배치되도록 설정에서 가로형(예: 16:9)을 고른다 — 프롬프트 문자열에 넣지 않는다.
5. **각도는 도(°)로 벌리고, 클로즈업 중복을 막는다.** 모델은 정면 얼굴로 회귀하는 경향이 강하다("정면 attractor"). 게다가 얼굴 클로즈업으로 크롭하면 "살짝 돌린(slightly turned)" 각도는 정면과 구분이 사라진다. 그래서 (a) 각 각도를 도(°)로 명시하고 `slightly left` 같은 모호한 표현을 쓰지 않으며, (b) 각 클로즈업이 서로 다른 머리 방향이고 정면으로 회귀하지 말라고 못 박는다. 이 두 가지를 빠뜨리면 정면 디테일 샷이 두 개로 중복돼 나온다.

## Mode A — 레퍼런스 이미지 첨부

```text
Create a professional character reference sheet for attached character with {use attached image(s) as strong reference, 1:1 similarity, [STYLE DESCRIPTORS - e.g., photorealistic, live-action, lifelike]}. Divide the sheet into four different vertical columns, each representing a different angle, for a total of eight shots.

The entire top row must show full-body views from head to toe at four clearly distinct angles: front (0 degrees), three-quarter turned 45 degrees, full side profile turned 90 degrees, and back (180 degrees). Do not use near-duplicate angles such as a "slightly turned" front. All subjects in the top row must be fully visible including feet, with no cropping at the ankles, knees, or head.

The bottom row must contain four face close-ups, one directly below each full-body figure and at the SAME head angle as the figure above it: front (0 degrees), three-quarter (45 degrees), side profile (90 degrees), and back of the head (180 degrees). Each close-up must show a clearly different head orientation — do not repeat the same angle, and the three-quarter, profile, and back close-ups must NOT default to a front-facing view.

The style must be [STYLE BLOCK - e.g., photorealistic, life-like live action shot on a DSLR camera with 35mm film and muted color tones; do not make it look like a 3D render].

Background should be simple and not distracting from character design.
```

## Mode B — 설명만

레퍼런스 이미지가 없을 때. 캐릭터 설명은 30-60단어로 짧게.

포함: 나이대 · 체형 · 피부 · 머리 · 눈 · 핵심 의상 · 핵심 소품.
제외: 장면 분위기 · 흙/피/젖은 머리 같은 일시적 상태 · 특정 조명 효과 · 배경 사건.

```text
Create a professional character reference sheet for [CHARACTER DESCRIPTION - tight comma-separated identity traits: age, build, skin, hair, eyes; wardrobe in brief; key prop. Target 30-60 words. No scene effects, no atmosphere, no narrative damage]. Divide the sheet into four different vertical columns, each representing a different angle, for a total of eight shots.

The entire top row must show full-body views from head to toe at four clearly distinct angles: front (0 degrees), three-quarter turned 45 degrees, full side profile turned 90 degrees, and back (180 degrees). Do not use near-duplicate angles such as a "slightly turned" front. All subjects in the top row must be fully visible including feet, with no cropping at the ankles, knees, or head.

The bottom row must contain four face close-ups, one directly below each full-body figure and at the SAME head angle as the figure above it: front (0 degrees), three-quarter (45 degrees), side profile (90 degrees), and back of the head (180 degrees). Each close-up must show a clearly different head orientation — do not repeat the same angle, and the three-quarter, profile, and back close-ups must NOT default to a front-facing view.

The style must be [STYLE BLOCK - e.g., photorealistic, life-like live action shot on a DSLR camera with 35mm film and muted color tones; do not make it look like a 3D render].

Background should be simple and not distracting from character design.
```

## 각도 중복이 계속 나면

규칙 5를 지켰는데도 정면 클로즈업이 중복되면:

- **시드를 바꿔 2-3장 재생성한다.** 한 번만 그런 거면 운 나쁜 샘플이다. 시드를 바꿔도 반복되면 그때가 모델 한계 신호.
- **각도를 개별 생성으로 분리한다.** 정면 전신을 먼저 확정하고, 그 노드를 레퍼런스(`reference_node_ids`)로 측면·후면 클로즈업을 따로 생성한다. 몸 방향 맥락이 앵커가 되어 한 장 그리드보다 머리 회전이 안정된다.

## Style Block 예시

스튜디오/작가명 같은 고유명사 대신 시각 속성으로 쓴다.

실사 / live-action:

```text
photorealistic, life-like live action shot on a DSLR camera with 35mm film and muted color tones, do not make it look like a 3D render
```

3D 애니메이션 (픽사풍 → 분해):

```text
stylized 3D render, soft global illumination, rounded forms, expressive proportions, subtle subsurface skin, no photoreal rendering
```

2D 애니메이션:

```text
clean cel-shaded 2D anime, crisp line work, flat color fills with soft gradient shadows, painterly backgrounds, no 3D render
```

Noir:

```text
high-contrast black and white film, harsh chiaroscuro lighting, 35mm grain
```

인플루언서 / iPhone vlog:

```text
natural daylight, iPhone selfie-camera aesthetic, soft skin tones, no cinematic grade
```
