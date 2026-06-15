# 01 · FLUX 2 작법 (BFL)

> **infision 모델**: `flux-2-pro` · `flux-2-max` · `flux-2-flex` · `flux-2-klein-9b` (provider `bfl`) — 카탈로그 `backend/internal/chat/tools/image_catalog.go`
> **출처**: `study/bfl-prompting/`(BFL 공식 가이드 무손실 스냅샷 2026-06-03 + infision 매핑), deep-research(2026-06) · **정리일** 2026-06-08
> **충돌 우선순위**: 실제 코드(`bfl/provider.go`, `image_catalog.go`) > `study/bfl-prompting/README.md` 매핑 > 공식 가이드 일반론

---

## 1. FLUX 는 프롬프트를 이렇게 읽는다

- **자연어 산문 우선.** "프롬프트가 만들고 싶은 이미지를 명확히 묘사하는 글처럼 읽힐 때" 가장 잘 작동. 키워드 나열보다 요소 간 관계가 드러나는 서술문.
- **단일 정답 포맷 없음.** 콤마 구문도, 완전한 문장도, 둘을 섞어도 된다 — 묘사가 충분하기만 하면.
- **어순 = 우선순위.** 핵심을 앞에. 자꾸 너무 넓게 잡히면 피사체를 먼저 또렷이 하고 환경을 뒤로 민다(`00 §3`).
- **다국어 지원**하지만 **영어가 가장 정밀**(학습 데이터 다수가 영어). infision 프롬프트 문자열은 영어로 쓴다. 단, 로컬 시장·건축·분위기의 문화적 정확도가 중요하면 그 부분만 현지어가 더 맞을 수 있다.
- **길이**: FLUX.2 는 프롬프트 32K 토큰까지. 하지만 길수록 좋은 게 아니다 — "Strong prompts are specific, not necessarily long." 권장: 짧음 10–30단어(탐색), 중간 30–80(대부분), 긺 80–300+(복잡 다중 피사체).

---

## 2. 정규 빌드 순서 / 템플릿

```
[SUBJECT], [LOCATION],
[STYLE], [CAMERA SETTINGS], [LIGHTING], [COLORS], [EFFECT],
[ADDITIONAL ELEMENTS]
```
> 출발 구조일 뿐 엄격한 공식이 아니다. 슬롯을 다 채우지 말 것. (BFL 통합 가이드)

**FLUX.2 짧은 공식**(BFL FLUX.2 가이드, deep-research): `Subject + Action + Style + Context`. **어순이 중요** — FLUX.2 는 앞에 온 것에 더 집중한다(우선순위: 핵심 피사체 → 핵심 동작 → 결정적 스타일 → 필수 맥락 → 부차 디테일). 위 8슬롯 템플릿과 모순이 아니라, 빠르게 쓸 때의 압축형이다.

**단계별 빌드 예**(한 번에 하나씩 쌓기):
```
1. portrait, a young woman with curly red hair
2. portrait, a young woman with curly red hair, in a bustling city street
3. + fashion editorial photography, 85mm lens, soft golden hour light
4. + warm amber and charcoal tones, subtle film grain, wind-blown hair and blurred city lights
```
순서 원칙: image type+subject 로 시작 → generic 하면 style+lighting → 통일감 원하면 colors → **effect·additional elements 는 맨 마지막**.

일관성을 위해 끝에 스타일/무드 태그를 붙이는 패턴:
`[Scene description]. Style: Country chic meets luxury lifestyle editorial. Mood: Serene, romantic, grounded.`

---

## 3. 모델 변형 차이 (★ 모델 고를 때)

| infision ID | FLUX.2 변형 | 짧은 프롬프트 보강(infision 실제) | reference 상한 | 용도 |
| --- | --- | --- | --- | --- |
| `flux-2-pro` | [pro] | BFL native\* (infision 미설정) | 8 | 실사 hero·고품질 기본 |
| `flux-2-max` | [max] | BFL native\* (infision 미설정) | 8 | 최고 품질 |
| `flux-2-flex` | [flex] | **infision 명시 주입** `prompt_upsampling=true, guidance=5.0, steps=50` | 8 | 세밀 제어·타이포 |
| `flux-2-klein-9b` | [klein] 9B | **✕ — "쓴 대로 나옴"** | 8 (infision) · 4 (FLUX 상한) | 소형·고속, 라인아트·플랫 일러스트·콘티 스케치 |

> \* BFL 가이드는 pro/max/flex 가 짧은 프롬프트를 **native 로** 자동 보강한다고 말하지만, **infision 어댑터는 flex 에만** `prompt_upsampling=true` 를 **명시 주입**한다(`bfl/provider.go`). pro/max 는 infision 가 이 파라미터를 세팅하지 않으므로(BFL API 기본값에 의존), **자동 보강을 전제로 짧게 쓰지 말고 충분히 묘사**하는 게 안전하다(`study/bfl-prompting/research-integration-points.md` 의 "pro/max/klein 은 미설정" 참조).

- **flex** 는 infision 가 upsampling/guidance/steps 를 박아 짧은 프롬프트도 보강된다 — 타이포·세밀 제어에 유리.
- **klein 은 보강 없음** — "What you write is what you get." 짧게 쓰면 짧게 나온다. **산문으로 충분히 묘사**하고 끝에 `Style: …. Mood: ….` 를 붙여라. BFL klein 레퍼런스는 "조명 묘사가 출력 품질에 단일 최대 영향"이라고 한다. 카탈로그상 klein-9b 는 라인아트·플랫 일러스트·콘티 스케치에 강하고 포토리얼 충실도는 낮다.
- infision 어댑터는 reference **8슬롯 하드캡**이고 `safety_tolerance=2` 고정(UI 미노출). 카탈로그는 klein-9b 도 `MaxInputImages=8` 로 노출하지만 FLUX 상 klein 의 실제 한계는 4장이니, 레퍼런스를 많이(5장+) 붙일 땐 pro/max/flex 를 고르는 게 안전하다.

**모델 선택 한 줄 이유 예**: 러프 콘티 → `flux-2-klein-9b`(소형·고속), 실사 hero → `flux-2-pro`/`flux-2-max`(고품질), 파라미터 세밀 제어 필요 → `flux-2-flex`.

---

## 4. 네거티브 없음 → 긍정 치환

FLUX 는 **negative prompt 를 지원하지 않는다.** 구조적 이유다 — flow-matching + distilled guidance(CFG=1)라 부정으로 밀어낼 classifier-free guidance 분기 자체가 없다(deep-research). 빼고 싶은 것을 **그 자리에 보일 것**으로 바꿔 쓴다(`00 §4` 표).

| ~없이 | → |
| --- | --- |
| a street with no cars | a quiet pedestrian walkway with cobblestones |
| a room with no furniture | a spacious empty room with polished wooden floors |
| a portrait with no glasses | a portrait showing clear, unobstructed eyes |
| not dark or scary | peaceful, welcoming, warm atmosphere with soft golden lighting |

가벼운 배제만 필요하면 infision 관습대로 끝에 `no text, no watermark, no logo` inline. 핵심 멘탈모델: **피하고 싶은 게 아니라 보고 싶은 걸 시각적으로 생각한다.**

---

## 5. 텍스트 렌더링 · HEX 색 (FLUX 강점)

**이미지 내 글자** — 3단계:
1. **따옴표로 정확히**: `"OPEN"`, `"Est. 1952"`.
2. **위치 묘사**: `The text "OPEN" appears in red neon letters above the door`.
3. **폰트 성격**: `elegant serif typography`, `bold industrial sans-serif`.
- 텍스트 묘사는 **앞쪽에** 두면 정확도 ↑. **짧게** 유지(긴 문자열은 깨지기 쉬움).
- 예: `Groovy retro poster with the quote "If you love me let me sleep". Bold 70s typography in deep red and warm pink tones.`

**HEX 브랜드 색**(FLUX.2) — 각 색을 **특정 객체에 결속**:
```
Good:   a vintage illustration of an apple in color #0047AB on a white background
Avoid:  use #FF0000 somewhere    ← 모호하면 일관성 깨짐
```
그라데이션은 시작/끝 색을 명시: `the vase color is a gradient, starting with #02eb3c and finishing with #edfa3c`.

---

## 6. 레퍼런스 이미지 편집 (reference_node_ids → 입력 슬롯)

레퍼런스 이미지를 실제로 부착하는 신뢰 가능한 경로는 **image-generate 도구 args 의 `reference_node_ids` 에 노드 id 를 직접 넣는 것**이다. 사용자가 직전 턴에 `@<label>` 로 멘션한 이미지도 슬롯에 들어올 수 있으나, 그 멘션은 **직전 한 턴만 유효**해 다음 user 발화나 HITL 승인 지연이 끼면 즉시 증발한다 — 신뢰하지 마라. **레퍼런스를 쓰는 모든 생성에서** 에이전트가 `reference_node_ids` 를 직접 채운다. 프롬프트에 **URL 을 넣지 않는다** — 시각 목표만 묘사. 순수 text-to-image(레퍼런스 불필요)면 `reference_node_ids` 도 `image N` 지칭도 쓰지 않는다.

**싱글 레퍼런스(1장)** — 핵심: **바꿀 것은 구체적으로, 지킬 것은 명시적으로.**
```
Good:   Change the shirt color to red
        Replace the background with a sunset beach
        Add snow to the scene, keep everything else unchanged
        Change the color of the lace dress to sky blue (#87CEEB), while keeping
        all lace embroidery white and visible. Preserve the original fabric texture and folds.
Avoid:  Make it better / Improve the lighting / Fix the image
```
- 구체 동사 선호: `change the clothes` > `transform`. 텍스트 편집도 따옴표: `Change the text to "Flux.2"`.

**멀티 레퍼런스(2~8장)** — **여러 노드 id 를 `reference_node_ids` 에 순서대로 넣어 부착하고, 프롬프트에서 "image 1 / image 2"로 지칭해 역할 배정.** 프롬프트의 `image N` 은 이미 부착된 N번째 입력에 대한 지시일 뿐 — `reference_node_ids` 가 비면 허공 참조가 된다.
```
A photograph of the woman in image 2 sitting on the swing in image 1
and the cat from image 3 sitting on her lap, all in the style of image 4

Apply the colors and patterns of the animal in Image 2 to the animal in Image 1.
Keep the pose, lighting, and composition of Image 1 unchanged.
```
합성 시 scale·lighting·perspective 일치를 명시: `…matching scale, lighting, and perspective`.

> `reference_node_ids` 에 넣은 노드 순서가 곧 image 1, 2, … 다. rationale 에는 "ref1 스타일 + ref2 피사체" 같은 **의도**만 적고, 프롬프트엔 역할 배정 문장으로 옮긴다. 같은 인물/사물을 여러 컷에 유지할 땐 피사체마다 서로 다른 노드를 넣고 `@image1`/`@image2` 로 구분 지칭한다 — 모두 같은 슬롯으로 부르면 정체성이 섞인다.

---

## 7. JSON 구조 프롬프트 (프로덕션 반복 — pro/max)

반복·자동화·다중 피사체 복잡 씬에서 유효(FLUX.2 는 JSON·자연어 둘 다 동등 이해). 같은 스키마에서 한 속성만 바꿔 재생성하기 좋다.
```json
{ "scene": "...", "subjects": [{"description":"...","position":"...","action":"..."}],
  "style": "...", "color_palette": ["#hex1","#hex2"], "lighting": "...", "mood": "...",
  "composition": "...", "camera": {"angle":"...","lens":"...","depth_of_field":"..."} }
```
빠른 탐색·단순 단일 피사체는 자연어가 낫다.

---

## 8. Good vs Avoid 요약

```
단순 → 디렉티드:
  A dog sitting in a sunny park
  → A golden retriever mid-leap chasing a tennis ball across a sunlit hardwood floor,
    muddy paw prints trailing, warm afternoon light through sheer curtains,
    shallow depth of field, candid pet photography, 35mm lens

포토리얼: 일반 → 구체 장비:
  professional photo  →  Shot on Hasselblad X2D, 80mm lens, f/2.8, natural lighting
  (단 정밀 장비명은 pro/max 같이 받쳐주는 변형에서)
```

---

## 출처 (1차)

- BFL 공식 가이드(무손실 스냅샷): `study/bfl-prompting/posting/` — basics·building·style·technical·reference·editing·usecases
- infision 매핑 레이어: `study/bfl-prompting/README.md` (모델 ID·flex 주입값·8슬롯 캡 단일 진실)
- deep-research 검증(1차): <https://docs.bfl.ai/guides/prompting_unified_basics> · <https://docs.bfl.ai/guides/prompting_guide_flux2> · <https://docs.bfl.ai/guides/prompting_guide_t2i_negative> · <https://huggingface.co/black-forest-labs/FLUX.1-dev>

