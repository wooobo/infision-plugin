# 00 · 이미지 프롬프트 공통 원칙 (모델 불문)

## 0. infision 에서의 위치 (먼저)

- infision 챗 에이전트가 건네는 건 **프롬프트 문자열**(영어)과 한국어 rationale 한 줄이다. 이 문서는 그 문자열의 질을 좌우한다.
- **고유명사 금지**(`infision_agent.md`): 프롬프트 문자열엔 스튜디오·작가·작품·실존 인물·브랜드·캐릭터 IP 를 쓰지 않는다. 시각 속성으로 분해한다.
  - `"지브리풍"` → `soft hand-painted watercolor backgrounds, lush pastoral scenery, warm diffused light, gentle cel-style character shading`
  - `"Chanel No.5 보틀"` → `a luxury fragrance bottle, faceted glass, gold cap`
  - 고유명사를 쓰고 싶은 충동 = **아직 분해가 덜 됐다는 신호**.

---

## 1. 프롬프트의 뼈대 — 시각 축 (visual axes)

좋은 프롬프트는 키워드 더미가 아니라 **구조화된 묘사**다. 아래 축을 순서대로 채우되, 안 맞는 축은 비운다(체크리스트가 아니다).

| 축 | 통제하는 것 | 예 |
| --- | --- | --- |
| 이미지 타입/매체 | 전체 카테고리·프레이밍 | `portrait`, `landscape`, `macro photo`, `oil painting`, `3D render` |
| 피사체(subject) | 메인 대상 | `a young woman with curly red hair` |
| 디테일 | 색·복장·표정·재질 | `weathered leather jacket, freckled skin` |
| 동작/상태(action) | 무엇을 하고 있나 | `mid-leap chasing a ball` |
| 씬/배경(location) | 환경 | `in a futuristic space station` |
| 구도/시점(composition) | 프레이밍·각도 | `rule of thirds, low-angle hero shot` |
| 카메라 | 렌즈·심도·샷 | `85mm lens, shallow depth of field` |
| 조명(lighting) | 광원·방향·색온도 | `soft golden hour backlight` |
| 색(color) | 지배 팔레트 | `muted earth tones, deep teal and cream` |
| 효과/추가요소 | 마무리 처리 | `film grain, wind-blown fabric` |
| 제약(constraints) | 빼야 할 것 | `no text, no watermark, no logo` |

**범용 한 줄 템플릿** (빠른 출발용):
```
Subject, medium, style, lighting, framing, mood, palette.
```
예: `Portrait of a barista, film photo, soft rim light, 50mm close-up, warm mood, teal-orange palette.`

**빌드 순서 원칙**: 명확한 **피사체로 시작 → 동작/상태 → mood·맥락은 이미지가 좋아질 때만**. effect·추가요소는 **맨 마지막**(토대가 아니라 다듬기).

---

## 2. 구체성 vs 모호함

- **모호 → 통제 불가.** `a cat` 대신 `a fluffy white Persian cat with sapphire eyes, lounging on a sunlit windowsill`.
- **Show, don't tell.** `"슬픈 사람"` 대신 `"a person with slumped shoulders, tear-filled eyes, staring at a faded photograph"`. 추상 개념(사랑·정의·슬픔)을 피사체로 직접 두지 말고 **보이는 것**으로 옮긴다.
- **단, 구체 ≠ 길이.** "Specific detail helps. Filler hurts." 핵심을 구체화하고 군더더기를 빼라. 무의미한 품질 형용사(`amazing`, `beautiful`) 남발은 신호가 없다.

**Good vs Avoid**
```
Avoid:  Fox, forest, autumn, misty, sunlight, 8k, best quality
Good:   A curious red fox exploring a misty autumn forest at dawn.
        Golden sunlight filters through colorful leaves, casting
        dappled shadows on the forest floor.
```

---

## 3. 어순·강조 — 앞쪽이 우선순위

- 대부분 모델에서 **단어 순서 = 우선순위 신호**. 가장 중요한 내용을 **앞에**, 관련 개념을 묶어서.
- 프레이밍이 안 맞으면(자꾸 너무 넓게 잡히면) **피사체를 먼저 또렷이 하고 환경 디테일을 문장 뒤로** 민다.
  ```
  통제 약함:  Person standing inside a forest fire, strong determined attitude, close-up shot, realistic
  통제 강함:  Person with a strong determined expression, forest fire in the background, close-up shot, realistic
  ```
- 강조의 공통 레버는 **순서**다 — 가장 중요한 걸 앞에.

---

## 4. 네거티브 처리 — 모델마다 다르다

| 처리 방식 | 해당 모델 |
| --- | --- |
| **별도 negative prompt 필드 있음** | Stable Diffusion / SDXL / SD3 (사실상 필수), 일부 중국계 |
| **파라미터로 배제** | Midjourney `--no <물체>`, 음수 가중치 `::-0.5` |
| **negative 없음 → 긍정 치환** | **FLUX, Nano Banana(Gemini), GPT Image** ← infision 모델 전부 |

AI 는 부정문(`a person without glasses`)을 처리하다 오히려 그 대상(glasses)에 집중하기 쉽다. **infision 모델은 모두 긍정 치환**으로 간다:

| `~없이` 대신 | 이렇게 |
| --- | --- |
| no people | empty, deserted, solitary |
| no cars | a quiet pedestrian walkway with cobblestones |
| no text | clean surfaces, unmarked, blank |
| not dark | brightly lit, sun-drenched |
| no modern elements | traditional, period-accurate |

> 단, infision `image-generate` 엔 별도 negative 필드가 없으므로, 가벼운 배제는 프롬프트 끝에 **inline `no X, no Y`** 로 적는다(`do not X` 보다 `no X` 가 더 잘 먹힘). 무거운 배제는 위 긍정 치환으로.

---

## 5. 반복(iteration) 전략

좋은 프롬프트는 한 방이 아니라 **반복**에서 나온다.

1. **단순하게 시작** → 맞은 것/틀린 것 확인.
2. **한 라운드에 한 요소만** 바꾼다(동시에 여러 개 바꾸면 무엇이 효과였는지 모른다).
3. 같은 축에서 **동의어**를 시도 → 시드·종횡비 정제 → 후처리.
4. infision: 프롬프트 수정 비용은 0 이다. 강한 해석 하나를 먼저 보여주고, 한 걸음씩 가볍게 튼다.

---

## 6. 흔한 실패 모드와 회피

| 실패 | 증상 | 회피 |
| --- | --- | --- |
| 모호함 | generic·밋밋 | 시각 축을 구체화(§2) |
| 과밀(overcrowding) | 요소 충돌·정보 과부하 | 핵심만 남기고 덜어내기 |
| 모순(contradiction) | 지시가 서로 싸움 | 양립 불가 속성 제거(특히 지시 충실 모델) |
| 부정어 남용 | 빼라는 게 오히려 나옴 | 긍정 치환(§4) |
| anatomy/손 | 손가락 6개·뒤틀림 | 긍정 구체화 + (지원 모델만) negative; 손 클로즈업은 가능한 단순 포즈 |
| 텍스트 아티팩트 | 깨진 글자 | 글자는 **따옴표로 정확히**, 짧게(`a sign reading "OPEN"`) |
| 과정밀 용어 | 특수 카메라/필름 용어가 무시됨 | 그 용어가 학습된 모델에서만 의미 — 안 통하면 일반 조명·렌즈 언어로 |

---

## 7. 사진/포토리얼 공통 어휘 (사전)

사진/포토리얼 프롬프트용 빠른 사전. 모델 무관 통용.

- **렌즈/심도**: `24mm wide`(환경) · `35mm`(다큐) · `50mm`(눈높이 중립) · `85mm`(인물) · `macro`(질감). 얕은 심도 `shallow depth of field, f/1.4` ↔ 전체 선명 `deep focus, f/11`.
- **조명**(단일 최대 임팩트): `golden hour backlight` · `blue hour` · `soft window light` · `softbox studio` · `Rembrandt lighting` · `rim light` · `low-key cinematic` · `high-key commercial` · `neon`. "good lighting" 금지 — 광원·질·방향·색온도로 묘사.
- **구도**: `rule of thirds` · `leading lines` · `symmetrical` · `negative space` · `low/high angle` · `dutch angle` · `flat lay`.
- **포토리얼 룩**: `editorial photography` · `cinematic` · `analog film, natural grain` · `clean high dynamic range`. 일반 장비 표현으로 충분; 정밀 장비명은 모델이 받쳐줄 때만.
- **네거티브 인벤토리**(inline `no <term>` 또는 SD negative 로): blurry · distorted anatomy · extra fingers · watermark · logo · misspelled text · low resolution · over/underexposed · duplicate subject · messy composition.
