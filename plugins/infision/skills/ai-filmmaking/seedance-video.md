# 3단계 — Seedance Video Prompt

캐릭터 시트와 스토리보드를 Seedance 영상 프롬프트로 옮긴다. 이 파일은 **워크플로 레벨**(시트+스토리보드를 어떻게 조립하는지, `@image` 번호, 변형 선택)만 다룬다. Seedance 2.0 의 파라미터·립싱크·오디오·카메라 등 **모델 작법**은 `video-prompt-craft` 번들의 `seedance-prompt-craft.md`를 본다.

가진 레퍼런스에 따라 세 변형:

- **Variant A**: 텍스트 중심 샷, 캐릭터 시트는 선택.
- **Variant B**: 스토리보드 그리드를 메인 레퍼런스로.
- **Variant C**: 캐릭터 시트 + 스토리보드 모두.

## 길이는 설정이다

infision 에서 영상 길이는 설정(승인 카드)이다 — 프롬프트 문자열에 "15초" 같은 숫자를 박지 않는다. 다만 **타임라인 비트(0:00-... 무엇이 언제)는 프롬프트 내용**이다. 타임라인은 설정한 길이 전체를 채우도록 쓰고, 길이가 바뀌면 비트를 거기에 맞춰 나눈다. (아래 예시 타임라인은 15초 기준 — 설정 길이에 맞춰 재분배한다.)

## 부착은 `reference_node_ids`, `@imageN` 은 지칭일 뿐

레퍼런스를 실제로 **부착하는 것은 video-generate 도구의 `reference_node_ids` args** 다. 프롬프트의 `@image1`/`@image2`/`@image3` 텍스트는 *이미 부착된* N번째 이미지를 가리키는 지시일 뿐, 그 자체로는 아무 이미지도 붙이지 않는다.

- Variant B/C 등 레퍼런스를 쓰는 **모든 변형**에서, 프롬프트에 `@imageN` 을 적는 것과 별개로 `reference_node_ids` 에 해당 캐릭터 시트·스토리보드 노드 id 를 **부착 순서대로** 직접 넣는다.
- `reference_node_ids` 의 부착 순서가 곧 `image1, image2, image3, …` 번호다. `reference_node_ids` 순서와 프롬프트의 `@imageN` 이 일치해야 올바른 이미지를 지칭한다.
- `reference_node_ids` 를 비운 채 `@imageN` 만 적으면 허공 참조가 되어 매 생성마다 다른 얼굴/형태가 나온다.
- 사용자가 직전 턴에 `@멘션` 했는지 여부에 의존하지 마라. 레퍼런스를 쓰는 생성이면 항상 `reference_node_ids` 로 직접 부착한다.
- Variant A 처럼 레퍼런스 없는 순수 텍스트 샷이면 `reference_node_ids` 도 `@imageN` 도 쓰지 않는다.

## `@image` 번호 규칙

여러 레퍼런스를 쓸 때 각각 다른 번호를 준다. 서로 다른 레퍼런스를 같은 `@image1`로 부르면 캐릭터가 섞인다. (번호는 `reference_node_ids` 의 부착 순서와 1:1로 맞춘다.)

- 캐릭터 A 시트 `@image1`, 캐릭터 B 시트 `@image2`, 스토리보드는 다음 번호.
- 캐릭터 시트 1 + 스토리보드 1 = 캐릭터 `@image1`, 스토리보드 `@image2`.
- 스토리보드만 = 스토리보드 `@image1`.

## Variant A — 텍스트 중심 샷

개별 캐릭터 시트만 있거나 레퍼런스가 없을 때, 텍스트로 샷을 자유롭게 반복 생성.

```text
FORMAT: [NUMBER] CUTS / [GENRE + TONE] / [AUDIO INSTRUCTION]

SUBJECT 1: [Physical description, defining traits, style]. [Reference @image1 if a sheet exists].
SUBJECT 2: [Optional - second subject or environmental force. Reference @image2 if a second sheet exists].

ENVIRONMENT: [Location, time of day, weather, lighting, atmosphere].

AUDIO / MOOD: [Music direction or absence]. [Key sounds, ambient layers, sonic textures].

TIMELINE (must cover the full selected duration; example below is for a 15s setting):
0:00-0:05: [Shot type or camera movement] - [What is in frame and what happens].
0:05-0:10: [Shot type or camera movement] - [What is in frame and what happens].
0:10-0:15: [Shot type or camera movement] - [What is in frame and what happens].
```

## Variant B — 스토리보드 그리드 메인 레퍼런스

9패널 스토리보드가 있고 이를 하나의 연속 영상으로. 그리드가 캐릭터 정체성·공간·프레이밍·페이싱을 담당. 스토리보드 노드 id 를 `reference_node_ids` 에 넣어야 `@image1` 이 실제 그리드를 가리킨다.

```text
Use the provided cinematic storyboard grid @image1 as the main visual and motion reference. Create a cinematic sequence for the selected duration. Read the storyboard panels as sequential shots, not as one image. Follow the panel order, camera logic, motion arrows and camera framing consistently. Handheld camera moments to boost realism. NO TEXT ON SCREEN, NO MUSIC.

Storyline:
[Fill briefly from the storyboard - a compressed through-line, not a panel-by-panel novelization. The grid is the reference; the storyline is just the narrative spine.]
```

## Variant C — 캐릭터 시트 + 스토리보드

시트와 스토리보드 모두 있을 때. 가장 높은 일관성. 단 일관성의 실제 메커니즘은 `reference_node_ids` 부착이다 — 캐릭터1·캐릭터2·스토리보드 노드 id 를 그 순서로 `reference_node_ids` 에 넣어야 `@image1`/`@image2`/`@image3` 지시가 의미를 갖는다.

```text
Character 1: @image1
Character 2: @image2

Use the provided character sheets and cinematic storyboard grid @image3 as the main visual and motion reference. Create a cinematic sequence for the selected duration. Read the storyboard panels as sequential shots, not as one image. Follow the panel order, camera logic, motion arrows and camera framing consistently and temporally. NO TEXT ON SCREEN, NO MUSIC.

Storyline:
[Fill briefly from the storyboard.]
```

캐릭터 시트가 한 장이면 `Character 2`를 빼고 스토리보드를 `@image2`로. 세 장이면 `@image1~3`을 캐릭터에, 스토리보드를 `@image4`로. 어느 경우든 이 번호는 `reference_node_ids` 에 넣은 노드의 부착 순서와 1:1로 맞춘다 — 순서가 어긋나면 잘못된 이미지를 지칭한다.

## 오디오 규칙

기본값은 **음악 없음**이다. 사용자가 음악을 명시하지 않으면 `NO MUSIC`을 넣는다 — 음악은 생성 후 제거가 어려워 후반 작업에서 넣는 편이 안전하다. 특정 음악/분위기를 요청한 경우에만 반영한다.

## 대사 장면

대사는 타임라인 안에 넣는다. 두 번째 캐릭터가 응답할 때는 `She replies:` / `He replies:` — `reply`가 순차 대화를 모델에 더 명확히 전달한다. (립싱크·보이스 태그 세부는 `seedance-prompt-craft.md`.)

```text
0:00-0:03: Medium shot - She says (excited, eyes wide): "This is the best gift I ever received!" (pointing at the box).
0:03-0:06: Reverse over-the-shoulder - He replies (quietly amused): "I wasn't sure you'd open it."
```

## 스토리보드 없이 여러 샷

샷마다 Variant A 프롬프트를 하나씩. `SUBJECT`·`ENVIRONMENT`·`AUDIO` 블록은 동일하게 유지하고 `TIMELINE`과 카메라 프레이밍만 바꾼다. 스토리보드가 있다면 Variant B/C 가 낫다 — 텍스트 프롬프트를 체인으로 잇는 것보다 드리프트가 적다.
