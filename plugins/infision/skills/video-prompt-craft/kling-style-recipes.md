# Kling 스타일 레시피 (시각 속성 분해)

스타일을 **순수 시각 속성**으로 푼 레시피. 하드룰: 감독/스튜디오/작가/브랜드/IP/실존인물명을 프롬프트에 **절대 넣지 않는다.** 사용자가 그런 이름을 말하면 아래 속성 클러스터로 치환한다. `(maps from: X)` 는 사람 이해용 표기일 뿐 — 프롬프트 조각엔 그 이름이 없다. 어휘는 영문 그대로.

## Cyberpunk / Sci-Fi Urban

속성: 잉크블랙 + cyan/magenta/pink 네온; 볼류메트릭 네온 + 산업 스모그; 로우앵글 수직 스케일·레이어 심도; anamorphic·하이스피드 트래킹·shallow DOF; 젖은 반사 아스팔트·풍화 크롬·brutalist 콘크리트; 물리적 폭우·환기구 스팀·모션블러 사이니지.
```
neon-drenched megacity at night, vibrant pink and cyan volumetric light beams piercing dense industrial smog,
heavy rain streaks on wet asphalt with dynamic color reflections, monolithic brutalist concrete towers layered
with flickering holographic billboards, deep ink-black shadows with high contrast, anamorphic lens, slow
cinematic tracking shot, shallow depth of field, steam rising from street vents, photorealistic yet stylized
```

## Anime / 2D Hand-Drawn

서브스타일(명칭→속성): bold-outline action(두꺼운 외곽선·고대비 플랫 컬러·에너지 라인) / painterly naturalistic(수채 질감·따뜻한 자연광·풍성한 배경, maps from: Ghibli) / vibrant urban emotional(하이채도·렌즈플레어·대기 비, maps from: Shinkai) / ink wash(흑백 워시·고대비 네거티브 스페이스).
공통: 2D 라인워크 무결성, 사진질감 금지. 안티속성: `no 3D render, no photorealism, no deformed line work`.
```
2D anime style, bold outlines and vibrant flat colors, high-energy action scene, dynamic fabric motion and
energy burst effects, cinematic camera tracking, rain and atmospheric lighting, ultra-detailed hand-drawn
aesthetic, no 3D render, no photorealism
```
*(painterly 변형: `soft painterly 2D animation style, watercolor-like textures, warm diffused natural lighting, lush environmental background detail`)*

## Horror / Psychological Suspense

팔레트: slasher=deep red+near-black / psychological=sepia+sallow yellow+rusty brown / supernatural=icy blue+sickly green / 공통 desaturated cool·low brightness·고대비.
속성: 측광 샤프 그림자·깜빡이는 촛불/달빛; 눈/얼굴 극단 클로즈업·로우앵글 위협; 느린 dolly-in + 미세 핸드헬드; 35mm 그레인·갈라진 벽·바닥 안개; 저역 드론·삐걱임·침묵을 긴장 장치로.
```
horror cinematic style, desaturated cool tones with deep blacks and sickly blue-green light, dim flickering
candlelight casting long shadows on cracked walls, cold moonlight through broken windows, 35mm film grain,
high contrast with crushed shadows, slow dolly-in with subtle handheld shake, extreme close-up on a terrified
face, decayed Victorian interior, moody atmosphere
```

## Symmetrical Whimsical / Geometric Formalist
*(maps from: 정밀 대칭·파스텔·돌하우스 미학)*

속성: 파스텔/뮤트(faded pink, muted mustard, soft cyan, sage); 소프트 디퓨즈 스튜디오·평탄 조명·거친 그림자 최소; 완벽 좌우대칭/중심축·정면 정중앙·피사체 위 광활한 네거티브 스페이스; 수평 트래킹/고정 아이레벨/느린 push-in(흔들림 없음); 빈티지 벽지·앤티크·미드센추리 인테리어; 연극적 움직임.
```
perfectly symmetrical flat composition, centered subject at eye level facing forward, pastel color palette of
muted mustard yellow and faded pastel pink, soft diffused studio lighting with no harsh shadows, static camera
locked off, vintage mid-century interior with ornate wallpaper and precisely arranged antique props, vast
negative space above subject, storybook dollhouse aesthetic, geometric order
```

## Color / Mood

| 무드 | Palette | Lighting | Grading |
| --- | --- | --- | --- |
| 활기/온기 | orange·red·yellow, golden | high-key, bloom | `vibrant saturation, energetic, sunny` |
| 전문/신뢰 | corporate blue·grey·sage | soft natural | `low saturation, calm, documentary-style` |
| 우아/럭셔리 | 흑백 또는 monochrome blue | high contrast | `minimalist, high contrast, clean and modern` |
| 시네마틱 액션 | blue–orange 보색 | dramatic, shallow DOF | `cinematic lighting, high dynamic range` |
| 평온/자연 | blue–green 유사색 | soft ambient | `smooth gradient, peaceful, natural` |
| 노을/로맨틱 | orange–red 유사색 | warm backlight | `sunset atmosphere, warm transition` |

순서: palette → lighting → camera/motion. 2~4개 정밀 단서만. 톤 명시(`warm golden hour` > `warm colors`) + 채도 수식 + 감정 태그.

## 일반 스타일 에뮬레이션 — 명칭→속성

| 사용자가 말한 스타일 (maps from) | 프롬프트에 넣을 속성 |
| --- | --- |
| 대칭 파스텔 (Wes Anderson) | `symmetrical, pastel colors, centered composition, flat lighting` |
| 고딕 다크판타지 (Tim Burton) | `gothic, dark fantasy, high contrast, whimsical, distorted forms` |
| 다크 복합 스릴러 (Nolan) | `dark cinematography, complex composition, cool tones, dramatic shadows` |
| 회화적 손그림 (Ghibli) | `hand-drawn, natural, warm lighting, painterly texture` |
| 볼드 레트로 액션 (Tarantino) | `vibrant colors, unique angles, retro style, bold saturation` |
| 인상주의 | `impressionist, soft brush strokes, light effects, blended color` |
| 표현주의 | `expressionist, bold colors, emotional tone, distorted shapes` |
| 초현실주의 | `surreal, dreamlike, impossible combinations, strange hues` |
| 팝아트 | `pop art, bright colors, flat design, commercial graphic` |
| 추상 | `abstract, geometric, color blocks, minimalist` |

구성법: ① 속성 클러스터 명명(이름 아님) ② 정의적 디스크립터 2~3개 ③ 감정 톤어 ④ 기술 스펙(카메라·DOF·렌즈) ⑤ 변수 하나씩만 바꿔 반복.
