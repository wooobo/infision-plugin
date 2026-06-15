# Kling 조명·색온도·포토리얼리즘

조명 어휘를 정확히 쓰면 톤이 안정된다. 조명어는 **프롬프트 앞쪽**에 둘수록 출력이 안정적이다. 어휘는 영문 그대로.

## 조명 어휘

- 시간대: `golden hour lighting`(따뜻, 긴 그림자) · `blue hour`(차가움) · `midday sun`(harsh) · `overcast skylight`(무그림자).
- 품질: `soft diffused light` · `hard-edged light` · `diffuse glow` · `focused beams`.
- 볼류메트릭: `volumetric light shafts cutting through fog` · `god rays illuminating floating dust` · `atmospheric haze` · `steam swirling`.
- 3점 조명: `direct warm key light at 45 degrees` + `subtle diffused fill` + `strong golden rim light`. 비율 `2:1 key-to-fill`(드라마틱은 3:1).
- 위치: `side-lit from camera left` · `backlit halo` · `top-down spotlight` · `window light from the left`.

## 장르 프리셋

- Film noir: `hard side lighting with venetian blind patterns, extreme contrast`
- Cyberpunk: `neon blue and pink lighting, reflections on wet surfaces, industrial haze`
- Commercial: `high key studio lighting, soft diffused shadows, bright white background`
- Nordic noir: `bleak atmosphere, desaturated blues and grays, overcast lighting`

## 색온도 (CCT)

| 조건 | K | 성격 |
| --- | --- | --- |
| 촛불/불 | 1800~1900 | 앰버, 로맨스 |
| golden hour | 3000~3500 | 따뜻·향수 |
| 텅스텐 | ~3200 | 따뜻·집중 |
| daylight | 5500~6000 | 중립·사실 |
| overcast | 6000~7000 | 차가움·프로페셔널 |
| blue hour/그늘 | 7500~10000 | 냉·긴장 |

한 장면엔 **지배적 CCT 하나**. 모순 조합 금지(`soft diffuse` + `razor-sharp shadows`). 심도용 혼합은 의도적으로: `warm 3000K key vs cool 6000K shadow`.

## 면별 조명

| 면 | 프롬프트 | 효과 |
| --- | --- | --- |
| matte plastic | `soft, diffused light` | 깔끔·모던 |
| polished metal | `hard light, specular highlights` | 럭셔리·정밀 |
| skin | `warm, diffused, rim light` | 건강·플래터링 |
| glass/liquid | `backlighting, refraction` | 신선·심도 |
| fabric | `soft diffused light emphasizing softness` | 자연 질감 |

## 포토리얼리즘

| 목표 | 전략 |
| --- | --- |
| 플라스틱 피부 제거 | `ultra-detailed, realistic skin texture, visible pores` |
| 눈의 생기 | `realistic eye reflections, natural blinking` |
| 머리/직물 | `fine hair texture, intricate fabric weave` |
| 심도 | `shallow depth of field, blurred background` |
| 렌즈 질감 | `35mm film texture` / `24mm wide lens` |
| 대기 심도 | `volumetric light`, 혼합 CCT |

- 해상도 명시: `photorealistic, 4K` / `8K detail, masterpiece cinematography`. 4K 가 필요하면 처음부터 4K mode 로(업스케일 의존 금지).
- 조명 네거티브: `flickering, harsh reflections, clipped highlights, distorted shadows`. 하이라이트 보존: `protect highlights, visible shadow detail, soft highlight rolloff`.
