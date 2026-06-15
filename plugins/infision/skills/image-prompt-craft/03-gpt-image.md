# 03 · GPT Image 2 작법 (OpenAI)

> **infision 모델**(provider `openai`): `gpt-image-2` — "GPT Image 2.0, high text accuracy, up to 4K, reference editing + mask inpainting. org verification 필요할 수 있음." (`image_catalog.go`)
> **출처**: deep-research(2026-06, OpenAI Cookbook 1차) + `image_catalog.go` 스펙 · **정리일** 2026-06-08
> **충돌 우선순위**: 실제 카탈로그/코드 > OpenAI 공식 가이드 > 일반론
>
> ℹ️ **자료 밀도 주의**: infision `/study` 에 GPT Image 전용 1차 자료는 없다(이 문서는 OpenAI Cookbook + 카탈로그 스펙 기반). FLUX/Nano Banana 대비 검증 폭이 좁으니, 세부는 OpenAI 이미지 API 공식 문서로 그때그때 재확인.

---

## 1. 모델 스펙 (카탈로그)

| 항목 | 값 |
| --- | --- |
| reference 상한 | **16** (infision 모델 중 최다) |
| 마스크 인페인팅 | **지원**(`SupportsMask`) — 영역 지정 편집 |
| quality 옵션 | `low` / `medium` / `high` (이 모델만 노출, 비용↔충실도 트레이드오프) |
| 종횡비/사이즈 | 표준 세트(`AspectRatioValues`), up to 4K |
| 출력 | png/jpeg/webp |

- **org verification 필요할 수 있음** — 조직 인증이 안 되면 호출이 거부될 수 있다(생성 실패 시 점검 포인트).
- `quality` 는 승인 카드의 설정 토글로 다뤄진다(에이전트가 프롬프트로 정할 값이 아님). 러프/대량 → `low`~`medium`, 최종 → `high`.

---

## 2. 프롬프트 읽는 방식 — LLM 네이티브 지시 충실형

GPT Image 는 언어 이해가 강한 **지시 충실형**이다. 자유도가 높아 **최소 프롬프트·문단형·JSON 유사 구조 모두** 통한다.

- **일관된 순서로 쓰라**(OpenAI 공식, deep-research): *"Write prompts in a consistent order (background/scene → subject → key details → constraints)."*
- **용도를 명시하라** — `ad`, `UI mock`, `infographic` 같은 **의도를 적으면 모드·완성도 수준이 잡힌다**. 이건 GPT Image 특유의 강한 레버다.
- **과적재 말고 반복하라**: 긴 프롬프트도 되지만 디버깅이 어렵다. 깨끗한 베이스에서 작은 단일 변경으로 다듬는다.

```
구조 예:
  A clean studio backdrop (background) → a matte black ceramic mug (subject)
  → soft directional light from the left, sharp specular rim, shallow depth of field (key details)
  → no text, no watermark, no logo (constraints). Intended use: premium product ad.
```

---

## 3. 텍스트·타이포·UI (★ 강점)

- GPT Image 는 **이미지 내 글자 정확도가 높다** — 간판·로고·포스터·UI 카피·인포그래픽에 강하다.
- 글자는 **따옴표로 정확히**, 짧게: `a sign reading "OPEN"`. 위치·폰트 성격(`bold sans-serif`, `elegant serif`)을 같이.
- UI/인포그래픽은 **의도 명시 + 레이아웃 서술**: `a mobile app onboarding screen (UI mock), three steps laid out vertically, large heading "Get Started", muted neutral palette`.

---

## 4. 편집 · 마스크 인페인팅

- **레퍼런스 편집**(최대 16장): @멘션은 직전 한 턴만 유효하므로, 레퍼런스로 생성/편집할 땐 `image-generate` 도구 args 의 `reference_node_ids` 에 노드 id 를 직접 넣어 부착한다(빈 `reference_node_ids` 면 프롬프트의 first/second image · `@imageN` 지칭은 허공 참조가 된다). 그 지칭들은 부착된 입력에 대한 역할 지시일 뿐이다. "바꿀 것 X, 지킬 것 Y" 를 명시(`00`/`01` 공통 원칙과 동일). 구체 동사 선호(`change the jacket to navy` > `transform`).
- **마스크 인페인팅**: 영역을 지정해 그 부분만 교체/추가. 캔버스가 마스크 입력을 지원하는 경로에서 노출된다 — 프롬프트엔 *그 영역에 무엇이 보여야 하는지*를 적는다.
- 다중 레퍼런스는 피사체마다 서로 다른 노드를 `reference_node_ids` 에 넣고(부착 순서 = image1,2,…), 프롬프트에서 역할을 말로 배정한다(`use the product from the first image, the background from the second`). 여러 레퍼런스를 모두 `@image1` 로 부르면 정체성이 섞인다.

---

## 5. 네거티브 · 안전

- 별도 negative 필드는 infision `image-generate` 에 없다 → 가벼운 배제는 inline `no text, no watermark, no logo`, 무거운 배제는 긍정 치환(`00 §4`).
- **콘텐츠 모더레이션이 비교적 엄격**하다. 실존 인물·브랜드·IP 는 거부되기 쉬우니 **고유명사 금지 원칙대로 시각 속성으로 분해**(`00 §0`). 거부당하면 끊지 말고 안전 대체 속성으로 옮겨 다시.

---

## 6. ⚠️ 흔한 오해 — "photorealistic" 만 붙이지 마라

deep-research 가 **반박(0-3)** 한 항목: 포토리얼을 원한다고 프롬프트에 단어 `photorealistic` 를 그냥 끼워 넣는 건 효과가 약하다. 대신 **구체적으로 묘사**하라 — 재질·조명·렌즈·심도:
```
Avoid:  a photorealistic cup of coffee
Good:   a cup of espresso on a marble counter, soft window light from the left,
        crema texture visible, shallow depth of field, 50mm lens
```

---

## 7. Good vs Avoid 요약

```
용도 명시 + 순서:
  make a nice banner
  → A summer sale web banner (ad), bright airy background, a stack of fresh peaches as subject,
    bold heading "Summer Sale" upper-left, warm peach-and-cream palette, clean minimal layout

편집: 모호 → 구체+보존:
  improve this photo
  → Replace the background with a softly blurred garden while keeping the subject's pose and lighting unchanged
```

---

## 출처 (1차)

- OpenAI Cookbook — Image-gen models prompting guide: <https://developers.openai.com/cookbook/examples/multimodal/image-gen-models-prompting-guide> (일관 순서·용도 명시·과적재 금지·"photorealistic" 반박)
- infision 카탈로그 스펙: `backend/internal/chat/tools/image_catalog.go` (`gpt-image-2`)
