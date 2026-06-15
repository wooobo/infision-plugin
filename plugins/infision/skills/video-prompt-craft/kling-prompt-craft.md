# Kling 프롬프트 작법

Kling 비디오/이미지 프롬프트를 "잘 뽑히게" 쓰는 작법. 아래 어휘·태그·프롬프트 조각은 **툴로 나가는 영문 프롬프트에 그대로** 넣는다. 단 고유명사(감독/스튜디오/작가/브랜드/IP/실존인물)는 절대 넣지 말고 시각 속성으로 분해한다(스타일 분해는 `kling-style-recipes`).

## 프롬프트 구조

기본 순서:
```
[Subject + 물성] → [동작/물리] → [장면/배경] → [샷/프레이밍/시점] → [조명] → [분위기]
```

| 요소 | 예시 토큰 |
| --- | --- |
| Subject | `weathered leather jacket`, `swirling blue energy particles` |
| 동작/물리 | `wind-blown flames`, `gravity-affected smoke`, `upward spiraling` |
| 장면 | `rooftop at night with distant city lights` |
| 샷 | `low-angle stabilizer movement`, `push-in tracking shot` |
| 조명 | `volumetric light`, `golden hour glow`, `film noir shadows` |
| 분위기 | `atmospheric mist`, `ethereal glow`, `poetic realism` |

긴(10초+) 스크립트: **Setting/조명을 먼저** 깔아 공간을 고정하고, 같은 캐릭터는 **동일 디스크립터 문자열을 그대로 반복**(동의어로 바꾸지 말 것).

## 키워드 우선순위 / 가중치

- **위치 = 가중치.** 가장 중요한 요소를 맨 앞에. 스타일 필터는 맨 뒤.
- 콤마로 끊은 간결한 디스크립터 > 장황한 문장.
- 전문 어휘가 더 무겁다: `cinematic handheld` ≫ `good camera`, `macro shot` ≫ `close`.
- 최적 길이 **50~100 단어**. 과다 프롬프트·상충 키워드(`soft diffuse` + `razor-sharp shadows`)는 품질을 떨어뜨린다.
- Element 바인딩은 어떤 형용사보다 무겁게 정체성을 잡는 "슈퍼 키워드".

## Syntax 2.0 — Omni Reference Tags

내부 모듈(립싱크·정체성 보존) 트리거. 장식 아님. (API 스펙의 `<<<image_1>>>` 예시와 일치)
```
<<<element_1>>>   캐릭터/객체 정체성 보존
<<<image_1>>>     스타일 레퍼런스 또는 시작 프레임
<<<video_1>>>     모션/퍼포먼스 레퍼런스
<<<voice_1>>>     특정 화자 보이스 프로필
<<<voice_2>>>     대화 두 번째 화자
```
대사: `The man <<<voice_1>>> said, "Hello."` — 따옴표로 대사 표시, 화자 순서대로 태그. 감정 마커(`whispers`, `exclaims`, `in a low, flat voice`)는 오디오+표정에 반영.

## 물리 키워드

동작 라벨 대신 물리 현상을 명시하면 물리 엔진이 깨운다:

| 대신 | 이렇게 |
| --- | --- |
| `a person walking` | `foot hits the ground, muscles tighten and relax, weight transfers` |
| `liquid flows` | 점도·표면 확산·입자 거동 서술 |
| `character sits` | `settles into the chair, lets the chair take his weight` |

`realistic gravity`, `smooth motion`. 표면 묘사(`wet pavement`)로 반사/그림자 유도. 의상 물리 별도: `wind-blown`, `fluid drape`.

## 네거티브 프롬프트

상시 기본 리스트:
```
extra fingers, deformed limbs, fused legs, warped hands, distorted eyes, facial morphing,
changing features, unnatural posture, asymmetry, warped torso, low quality, watermark, text, blurry background
```
증상별 추가:

| 아티팩트 | 네거티브 |
| --- | --- |
| 해부/구조 | `extra fingers, deformed limbs, fused legs, warped hands` |
| 얼굴 불일치 | `distorted eyes, facial morphing, changing features` |
| 모션 글리치 | `camera shake, background flickering, robotic movement, sliding feet, warping` |
| 보행 | `sliding feet, floating, warping` |
| 텍스트 | `blurry text, gibberish` |

주의: Omni 의 negative 는 의미적 — `rain` 을 빼도 `clouds` 는 안 지워진다(명시 안 하면).

## 템플릿 (고유명사 → 속성 치환 완료)

동작 중심(기본 — 피사체가 실제로 움직이게):
```
A full body shot of [SUBJECT] [강한 동사 + 물리: sprinting and vaulting over / swinging a heavy / leaping toward]
[TARGET], weight and momentum driving each move, [cloth / hair / dust] reacting to the motion. Tracking shot
matching the speed, [lighting]. Photorealistic, motion intensity 7/10.
```
시네마틱 트래킹(차분·절제 — 정지가 의도일 때):
```
A smooth and deliberate 5-second dolly-in tracking shot approaching [SUBJECT]. Starts medium-wide and
slowly moves forward; as it does, subtle pan right + gentle tilt upward, revealing [SUBJECT DETAILS] from a
low heroic angle. Fluid, steady. Soft natural daylight, subtle god rays, gentle atmospheric haze. Photorealistic, 8K detail.
```
물리/유체 제품 시퀀스:
```
Pure black background where a river of [COLOR] flows out of darkness leaving a saturated trail; the trail
comes alive like a liquid river spreading across the surface; then converges into [PRODUCT SUBJECT] on a
water surface, surrounded by [COMPLEMENTARY ELEMENTS], where [SECONDARY ANIMATION].
```
