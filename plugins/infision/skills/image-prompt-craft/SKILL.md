---
name: image-prompt-craft
description: infision 캔버스 image-generate 로 이미지를 만들거나 고칠 때 모델별 작법(FLUX 2 · Nano Banana/Gemini · GPT Image 2)을 프롬프트에 반영하기 위한 번들. 공통 원칙과 고른 모델의 작법 파일을 열어 문법·강점·레퍼런스 결합·네거티브 처리·텍스트 렌더링을 반영한다.
---

# 이미지 프롬프트 작법 번들 (infision image-generate)

이미지 생성/편집 프롬프트는 **공통 원칙 + 고른 모델 파일**의 작법을 반영해 쓴다.

- **고유명사 금지** — 스튜디오/작가/작품/실존인물/브랜드·IP 는 프롬프트 문자열에 쓰지 말고 시각 속성으로 분해한다(예: "지브리풍" → `soft hand-painted watercolor backgrounds, lush pastoral scenery, warm diffused light, gentle cel-style character shading`).
- infision 가 `image-generate` 로 생성하는 모델은 **FLUX 2 / Nano Banana(Gemini) / GPT Image 2** 셋. 셋 다 negative 필드가 없고 자연어 idiom + 어순 강조 + 레퍼런스 지칭으로 수렴한다.
- **레퍼런스 부착 ≠ 지칭.** 레퍼런스 이미지의 부착은 `image-generate` 도구 args 의 `reference_node_ids` 에 노드 id 를 넣는 것으로만 이뤄진다. 프롬프트의 `@imageN`/`image N` 은 **이미 부착된** N번째 입력(부착 순서 = image1, image2, …)에 대한 모델 지시일 뿐, 그 자체로는 아무 이미지도 부착하지 않는다 — `reference_node_ids` 가 비면 `@imageN` 은 허공 참조가 되어 매 생성마다 형태가 달라진다. 직전 user 턴의 `@멘션` 은 한 턴만 살아남아 신뢰할 수 없으니, 레퍼런스를 쓰는 모든 생성에서 에이전트가 `reference_node_ids` 를 직접 채운다. 순수 text-to-image(레퍼런스 불필요)면 `reference_node_ids`·`@imageN` 둘 다 쓰지 않는다. 같은 피사체를 여러 컷에 유지할 땐 피사체마다 서로 다른 노드를 넣고 프롬프트에서 `@image1`/`@image2` 로 구분 지칭한다.
- 비율·해상도·모델명·출력포맷은 **프롬프트 문자열이 아니라 설정**(승인 카드)이다 — 프롬프트에 넣지 않는다.

## 파일

| 파일 | 내용 | infision 모델 |
| --- | --- | --- |
| `00-common-principles.md` | 모든 프롬프트의 토대 — 시각 축·구체성·어순·네거티브(긍정 치환)·반복·실패 모드·사진 어휘 | (공통) |
| `01-flux.md` | 자연어 산문, 변형별 차이, prompt_upsampling, 텍스트(따옴표)·HEX 색, 편집=변화+보존, 멀티레퍼런스(image 1/2 지칭) | `flux-2-*` |
| `02-gemini-nano-banana.md` | 서술형, 멀티턴 편집, 다중 레퍼런스 합성(`reference_node_ids` 부착 + 프롬프트 `@imageN` 지칭), 캐릭터 일관, 웹 그라운딩 | `nano-banana*` |
| `03-gpt-image.md` | 지시 충실, 용도 명시, 정확한 텍스트/UI, 마스크 인페인팅, 안전 | `gpt-image-2` |

## 모델별 작법 한눈에

| 축 | FLUX 2 | Nano Banana | GPT Image 2 |
| --- | --- | --- | --- |
| 프롬프트 idiom | 자연어 산문 | 서술 단락 | 지시 충실(+용도 명시) |
| negative | 없음 → 긍정 치환 | 없음 → 시맨틱 네거티브 | 없음 → 긍정 치환 |
| 강조 | 어순 | 어순 | 어순 |
| 레퍼런스 | 8, "image 1/2" | 10~14, `@imageN` | 16, +마스크 |
| 이미지 내 텍스트 | 따옴표·짧게 | 강함·다국어 | 강함·리터럴 명시 |
