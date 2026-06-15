# Seedance 2.0 프롬프트 작법 (Atlas)

파라미터는 infision Atlas 스키마(ground truth). 프롬프트 작법은 공식/준공식 가이드(fal.ai, cutout.pro, videoai.me 등) 기반 — 핵심은 검증됨. 영문 토큰은 그대로 프롬프트에.

## 파라미터 (infision 스키마 — 최우선)

- `prompt`: EN/中文. 中文 <500자. t2v 필수, i2v/r2v 선택(권장).
- `duration`: `-1,4,5,…,15`(초). `-1`=자동. default 5.
- `resolution`: std = `480p/720p/720p-SR/1080p/1080p-SR/1440p-SR`. **fast = `1080p` 제외**. default 720p. `-SR`=초해상 업스케일.
- `ratio`: `16:9/4:3/1:1/3:4/9:16/21:9/adaptive`. default adaptive.
- `generate_audio`: bool, **default true** — 음성+효과음+BGM 동시 1-pass.
- i2v: `image`(필수 첫프레임) + `last_image`(선택 끝프레임).
- r2v: `reference_images`(≤9) + `reference_videos`(≤3) + `reference_audios`(≤3).

## 구조

- **Subject+Action → Camera → Audio → (멀티샷이면) Shot 전환** 순. 정적 묘사("cinematic 4K beautiful")는 모델에 모션 단서를 거의 안 줌 — **무엇이 어떻게 움직이고 카메라가 뭘 하는지**를 써라.
- 페이싱은 말로(`slow, gentle`), fps/조리개로 쓰지 말 것.
- 멀티샷/컷: `Shot 1:` 라벨 또는 `[0-3s]`·`(00:00-00:05)` 타임스탬프 = **하드 컷 지시**(서술 라벨 아님). 각 타임스탬프에 Visuals+Action+Details.

## 대사 · 립싱크 (Kling과 다름 — 핵심)

- **`<<<voice_N>>>` 같은 태그 없음.** 대사는 **따옴표 + 자연어 화자 묘사 + 언어 명시**로:
  ```
  The woman in a cream sweater speaks in Korean: "요즘 잘 지냈어?"
  The man in a navy shirt replies in Korean: "응, 나름 잘 지냈어. 너는?"
  ```
- 언어 명시("speaks in Korean/Japanese: …")가 음소→입모양 매핑을 잡는다. 지원: 中/영/일/한 등 8+. **정확도: 中文 > 영어 > 일/한.**
- **짧게 5~10단어/줄.** 잰말·빠른 발화 회피. 길면 나눠 생성 후 잇기.
- **말하는 동안 카메라·머리 고정** — "nodding/turning head"는 립싱크와 충돌해 어정쩡한 모션. 미디엄 클로즈업 + 정면(또는 살짝 3/4)이 립싱크 최적, **단일 화자**가 가장 안정.
- 감정/페이싱 큐가 싱크를 올림: `"calm, slight pause before the punchline"`, `"brief pause at 2s, then urgent"`.
- ⚠️ Seedance 오디오는 **SFX·앰비언트가 대사보다 강함** — 대사 중심 콘텐츠는 납품 전 품질 확인 권장.

## 오디오 (SFX · BGM · 믹스)

- 소리는 **소스+표면** 구체적으로: `"boots on wet cobblestone"` ≠ `"sneakers on hardwood"`. 비 보이면 빗소리 자동.
- 타임스탬프 앵커: `"SFX: thunder crack at 3s"`. **동시 SFX 2~3개**까지(넘으면 뭉개짐).
- BGM은 장르·무드: `"lo-fi ambient piano"`, `"tense orchestral build"`. 템포(~70 BPM)는 참고, 무드 키워드가 더 신뢰적.
- **믹스 우선순위 명시**(대사 묻힘 방지): `"Dialogue clean and prominent, music low, ambient subtle."`
- 무음/루프/후처리 오디오 예정이면 `generate_audio:false`.

## 카메라 & 모션

- 카메라: `push-in / pull-out / pan / tracking / orbit / aerial / handheld / fixed`.
- **카메라 모션과 피사체 모션 분리**: `subject spins slowly, camera holds fixed framing`.
- **클립당 주 카메라 방향 하나.** **"fast" 남발 금지**(fast 카메라+fast 피사체+바쁜 장면 ≈ 지터). 하나만 빠르게.

## t2v / i2v / r2v

- **t2v** — 입력 없음, 프롬프트가 전부. ratio 명시 권장.
- **i2v** — `image`=첫프레임. 프롬프트는 정지 장면 재서술 말고 **모션을 묘사**. `last_image`로 시작→끝 전환.
- **r2v** — ref를 **인덱스 주소**(`image 1`, `video 1`, `audio 1`)로 + 역할 명시. 모션은 video ref에서 빌려옴(정체성=이미지, 거동=영상 분리).

## 해상도·길이 × 모션

- 고모션 → 고해상 + 짧은 길이로 아티팩트 억제, `slow`/`fixed` 병행. 긴 길이(12~15s)는 모션 단순하게.
- `adaptive` 안전 기본. 플랫폼이면 명시(`9:16` 소셜 / `21:9` 시네마 / `16:9` 표준). fast는 plain `1080p` 불가 → `1080p-SR`/`720p`.
- 음성/립싱크 품질은 **해상도와 무관** — 음성 위주면 720p로 충분(비용↓).

## 2.0 vs fast

- **2.0(std)**: 품질 우위, plain `1080p` 지원. 최종·멀티샷·레퍼런스 중심.
- **fast**: ~3배 빠름·저렴, plain `1080p` 없음. 드래프트·타이밍 체크. (비용은 Atlas 요금 확인.)

## Seedance vs Kling (선택 기준)

- **대사 문법**: Seedance = 자연어+따옴표+언어 명시. Kling = `<<<voice_1>>>` 태그. ← 모델 바꾸면 작법도 바꿔야 함.
- 오디오 파라미터: Seedance `generate_audio`(기본 true) vs Kling `sound`.
- 화질: Seedance `resolution` 파라미터(480p→1440p-SR) vs Kling `std/pro/4k`(identity).
- 화면비: Seedance 7종+`adaptive` vs Kling 16:9/9:16/1:1.
- 레퍼런스: Seedance r2v 이미지≤9+영상≤3+오디오≤3 인덱스 주소(멀티모달 강함). Kling 은 첫·끝 프레임 + r2v 참고 이미지 ≤7.
- **Seedance**: 기본 동기 오디오·레퍼런스 연출·21:9/4:3·많은 ref. **Kling**: `multi_shot` 디렉터·정밀 6축 카메라/모션 컨트롤·보이스 태그(`<<<voice_1>>>`) 립싱크·의미적 네거티브.

## 예시 (영문, 고유명사 없음)

대사(t2v, 카페 — Kling 버전과 비교용):
```
Two young adults at a round wooden cafe table, warm window light, medium two-shot, camera locked.
The woman with dark shoulder-length hair in a cream sweater leans forward and speaks in Korean:
"요즘 잘 지냈어?" The man in a navy shirt smiles and replies in Korean: "응, 나름 잘 지냈어. 너는?"
Soft cafe ambience. Dialogue clean and prominent, ambient low. Photorealistic.
```
멀티샷(타임스탬프 컷 + SFX):
```
[0-3s] Wide shot of a rain-soaked neon alley, camera slow push-in. SFX: distant thunder.
[3-6s] Medium shot, a figure in a long coat walks toward camera, boots splashing on wet asphalt.
Music: low synth pad enters at 3s, resolves on last frame. Dialogue none, ambient rain prominent.
```
i2v(모션만, 첫프레임 공급):
```
The still product on the table comes alive: condensation slides down the glass, steam curls up.
Camera holds a fixed close-up, subtle slow rise at the end. Quiet ambient kitchen sound.
```

(출처: fal.ai / cutout.pro Seedance 2.0 audio guide / videoai.me / lipsync.video / crepal.ai — 2026-06 조사.)
