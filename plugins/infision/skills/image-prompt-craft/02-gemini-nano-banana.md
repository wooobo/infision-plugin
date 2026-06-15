# 02 · Gemini / Nano Banana 작법

> **infision 모델**(provider `gemini`, 모두 Google Gemini image): `nano-banana-pro` · `nano-banana-2` · `nano-banana` — 카탈로그 `image_catalog.go`
> **출처**: `study/openart-blog/nano-banana-2-handbook.md`(핸드북, Nano Banana 직접 다루는 유일 1차 자료), `study/meta-ai-creativity/*`(일반 편집 작법, Meta AI 기준 — Nano Banana 사실 아님), deep-research(2026-06) · **정리일** 2026-06-08
> **충돌 우선순위**: `image_catalog.go` 모델 설명 > 핸드북 기법 > Meta AI 일반론
>
> ⚠️ **버전명 주의**: 핸드북은 "NB2 vs Nano Banana Pro" 로 비교하지만, 이는 카탈로그 3-슬롯(아래)과 1:1 매핑되지 않는다. **모델 선택 판단은 카탈로그 설명을 따르고**, 핸드북은 *기법*(편집·태깅·웹 그라운딩)으로만 차용한다.

---

## 1. 모델 변형 (★ 카탈로그 기준 — 모델 고를 때)

| infision ID | Gemini 계열 | reference 상한 | 카탈로그상 강점 |
| --- | --- | --- | --- |
| `nano-banana-pro` | Gemini 3 Pro Image | 14 | **최고 텍스트 렌더링 · 멀티 subject 정체성** · 2K/4K (Preview) |
| `nano-banana-2` | Gemini 3.1 Flash Image | 14 | Pro 급 품질을 Flash 속도/가격에 · 멀티 subject 편집 · 4K (Preview) |
| `nano-banana` | Gemini 2.5 Flash Image | 10 | 빠른 대량 생성 · 대화형 편집 |

- 모델 선택 한 줄 이유: 텍스트·정체성 정밀 → `nano-banana-pro`, 품질/비용 균형 → `nano-banana-2`, 빠른 대량·러프 → `nano-banana`.
- **optional attr 없음**: seed/guidance/steps/quality 노출 안 함. **레버는 프롬프트 + 레퍼런스 이미지 + aspect/size** 뿐. 일관성은 파라미터가 아니라 **레퍼런스 + 지칭**으로 만든다.
- **종횡비 제약**: Gemini 는 `4:5`/`5:4` 미지원(`1:1·2:3·3:2·3:4·4:3·9:16·16:9·21:9` 만). 출력은 png.
- **레퍼런스 상한 — Google 공식 세부**(deep-research): Gemini 3 계열은 최대 14장 혼합. Google 문서상 Flash(=`nano-banana-2`)는 object 10 + character 4 = 14, Pro(=`nano-banana-pro`)는 object 6 + character 5 = 11 로 **object/character 구분 상한**을 둔다. infision 카탈로그는 이를 단일 `MaxInputImages`(pro 14·2 14·1 10)로 노출하니, **수치는 카탈로그가 우선**이고 object/character 비율은 위를 참고로만.
- ⚠️ **버전 만료 주의**(deep-research): `gemini-3.1-flash-image-preview` / `gemini-3-pro-image-preview` 는 preview 로, 2026-06-25 종료 예정으로 보고됨. 모델 ID·상한은 version-pinned 로 보고 주기적으로 재확인.

---

## 2. 프롬프트 읽는 방식 — 서술·지시 충실형

- **"키워드 나열 말고 장면을 묘사하라"** (Google 공식, deep-research): *"Describe the scene, don't just list keywords. The model's core strength is its deep language understanding. A narrative, descriptive paragraph will almost always produce a better, more coherent image than a simple list of disconnected words."* → **완전한 문장/서술 단락**으로 쓴다. 콤마 태그 더미는 역효과.
- 시적·화려한 표현보다 **명확한 자연어 지시**. 복잡한 지시도 추론으로 따라간다.
- **목표 수준의 덜 구체적인 지시도 처리**한다(아래 §5 웹 그라운딩). 단 양·수량 지시는 모호해지기 쉬우니 중요하면 명시.

---

## 3. 편집 · 다중 이미지 합성 (★ 핵심 강점)

레퍼런스 부착은 **image-generate 도구 args 의 `reference_node_ids` 에 노드 id 를 직접 넣어야** 일어난다. 프롬프트엔 URL 을 넣지 않는다. 직전 user 메시지의 `@<label>` 멘션도 레퍼런스가 되지만(ADR-0026), 이는 그 턴에만 살아남고 뒤에 다른 user 발화("continue" 등)나 HITL 승인 지연이 끼면 증발한다 — **레퍼런스로 생성할 땐 멘션 생존 여부에 의존하지 말고 에이전트가 항상 `reference_node_ids` 를 채운다**. 순수 text-to-image(레퍼런스 불필요)면 `reference_node_ids` 도 `@imageN` 도 쓰지 않는다.

- **다중 레퍼런스는 `@image1`, `@image2` … 로 각 입력을 명시 지칭**한다. 핸드북에 따르면 이 태깅 없이는 멀티 레퍼런스 프롬프트가 실패하기 쉽다. 단 프롬프트의 `@imageN` 은 *이미 부착된* N번째 입력 이미지에 대한 모델 지시일 뿐, 그 자체로는 아무 이미지도 부착하지 않는다 — 부착 순서(= `reference_node_ids` 에 넣은 노드 순서) = image1, 2, …. `reference_node_ids` 가 비면 `@imageN` 은 허공 참조가 되어 매 생성마다 다른 얼굴/형태가 나온다.
- 핸드북 테스트: 캐릭터 시트 **~5장 동시**까지 안정적이라 보고. 단 Google 공식 상한은 모델별로 다르다(deep-research): **Flash(`nano-banana-2`) 최대 character 4 + object 10 = 14**, **Pro(`nano-banana-pro`) character 5 + object 6 = 11**. 핸드북의 "~5장"은 Pro 기준에 가깝고 Flash 에선 4 가 상한 — 캐릭터 시트를 많이 쓸 땐 모델별 character 상한을 의식한다. 총 레퍼런스 수는 카탈로그(`pro/2` = 14, `1` = 10)가 infision 의 상한.
- **"바꿀 것 X, 지킬 것 Y" 편집**이 강력하다:
  ```
  Change the background to a sunset beach scene while keeping the subject unchanged.
  Remove the person in the red shirt from the left side and fill in the background naturally.
  Add a golden retriever sitting next to me on the bench, matching the lighting and shadows.
  ```
- **반복 공간 편집 체인**(한 번에 하나씩): 간판 제거 → 행인 제거 → 낮→밤 → 눈 추가. 구조 추론·재조명까지 해낸다(Times Square 간판 제거 시 건물 구조 유추 + 젖은 노면 반사 재계산).
- **멀티턴 대화가 공식 편집 방식**(Google, deep-research): *"Chat or multi-turn conversation is the recommended way to iterate on images."* 한 번에 완벽한 프롬프트를 노리기보다, 생성 후 후속 메시지로 한 가지씩 고친다. 보존은 명시: `Update this infographic to be in Spanish. Do not change any other elements.` → infision 챗의 멀티턴 흐름과 그대로 맞물린다.
- **시맨틱 네거티브**(Google, deep-research): negative 필드가 없으므로 빼는 것을 긍정으로 — `no cars` 대신 `an empty, deserted street with no signs of traffic`.
- **캐릭터/제품 일관성**이 헤드라인 강점. 단 **사실적 사람 얼굴**은 일관성 약점(스타일화 캐릭터보다 얼굴 불일치에 민감). 가끔 캐릭터 시트 조각이 떠다니는 아티팩트, 지시 안 한 추가(캐릭터에 임의로 이름 붙이기 등)도 보고됨.

---

## 4. 텍스트 렌더링

- **다국어 텍스트 렌더링**이 개선된 계열(특히 `nano-banana-pro` 가 카탈로그상 "best text rendering"). 인포그래픽·번역된 레이아웃에 강하다.
- 리터럴 글자 인용 전용 문법은 자료에 명시돼 있지 않다 — **지시문에 정확한 문자열을 적고, size 를 키워**(텍스트·작은 라벨에 픽셀 여유) 정확도를 올린다. 핸드북의 "4K 로 생성" 조언은 infision 의 **size** 컨트롤에 대응(별도 quality 플래그 아님).

---

## 5. 웹 그라운딩 (이 계열 특유)

모델이 작업에 정보가 부족하다고 판단하면 **검색으로 실제 정보를 끌어온다**(환각 없이). 덜 구체적인 목표형 프롬프트가 통하는 새로운 범주:
```
(재료 사진 + ) make a recipe infographic   ← 레시피를 명시 안 해도 식별·조사·레이아웃
```
양·수량은 모호해질 수 있으니 결과가 어긋나면 그 부분만 명시.

---

## 6. 프롬프트 패턴 / Good vs Avoid

**편집 by 레퍼런스**: 베이스 이미지의 노드 id 를 `reference_node_ids` 에 넣어 부착 → 프롬프트는 `Edit @image1: [한 가지 편집].`
**멀티 레퍼런스**: 각 입력 노드를 `reference_node_ids` 에 순서대로 넣고, 프롬프트에서 `@imageN` 으로 지칭 + 역할 배정(`use @image2 as the location, place the subject from @image1`). 같은 인물/사물을 여러 컷에 유지할 땐 **피사체마다 서로 다른 노드를 넣고 `@image1`/`@image2` 로 구분 지칭**한다 — 여러 레퍼런스를 모두 `@image1` 로 부르면 정체성이 섞인다.
**under-specified 목표형**: 입력 + 목표만 주고 모델이 채우게(웹 그라운딩).

```
피사체 구체화:
  Avoid: A person at school.
  Good:  Create a wide-shot image of a high-school student smiling next to a group of friends
         and holding their books as they walk through the hallway in warm, soft lighting.

"바꿀 것 / 지킬 것":
  Avoid: change the background
  Good:  Change the background to a sunset beach scene while keeping the subject unchanged.
```

> Meta AI 출처(위 일부 예시)는 Nano Banana 가 아니라 일반 대화형 편집 작법이다. 재사용 가능한 구문 템플릿으로만 쓰고, Nano Banana 고유 사실로 단정하지 않는다.

---

## 7. infision 적합성 메모

- infision 가 노출하는 레버가 곧 이 계열의 정답 레버다: **`reference_node_ids`(부착) + `@imageN` 지칭 + 지시 표현 + aspect/size.** seed/guidance/steps/quality 가 없어도 일관성은 레퍼런스 부착 + 태깅으로 만든다. `@imageN` 태깅은 부착된 이미지를 가리킬 뿐이므로, `reference_node_ids` 가 비면 일관성 자체가 성립하지 않는다.
- 역할 배정은 **에이전트가 `reference_node_ids` 에 넣는 노드 순서**로 정한다: 첫 노드 = `@image1`, 둘째 노드 = `@image2` …. "스타일은 @image1, 피사체는 @image2" 식으로 노드 순서와 프롬프트 지칭을 맞춘다 — 사용자 @멘션 순서는 한 턴만 살아 증발하므로 의존하지 않는다.

---

## 출처 (1차, deep-research 검증)

- Google Gemini API — Image generation: <https://ai.google.dev/gemini-api/docs/image-generation> (멀티턴 편집·14 레퍼런스·object/character 상한)
- Google Developers Blog — Gemini 2.5 Flash Image 프롬프팅: <https://developers.googleblog.com/how-to-prompt-gemini-2-5-flash-image-generation-for-the-best-results/> ("describe the scene"·시맨틱 네거티브)
- 핸드북(기법): `study/openart-blog/nano-banana-2-handbook.md`
