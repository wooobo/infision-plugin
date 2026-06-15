# Kling 카메라·모션

카메라 무브, 동작 묘사, 캐릭터 정합을 다루는 작법. 어휘 토큰은 영문 그대로 프롬프트에 넣는다.

## 카메라 컨트롤

6축(config pan/tilt/zoom 등, 각 −10 ~ +10):

| 축 | + | − |
| --- | --- | --- |
| Pan | rotate right | rotate left |
| Tilt | tilt up | tilt down |
| Roll | clockwise | counter-clockwise |
| Zoom | wider FOV(짧은 초점) | narrower FOV(긴 초점) |

움직임 어휘: `push in / dolly in` · `pull back / dolly out` · `pan left/right` · `tilt up/down` · `tracking shot` · `orbit / 360-degree orbit` · `crane shot`(상승) · `static camera` · `handheld`(제어된 흔들림) · `steadicam`.

샷 타입: `extreme close-up`(질감) · `medium close-up`(상반신, 대사/감정) · `full body shot`(액션/의상) · `establishing wide shot`(장소/스케일).

패턴 — 기본은 피사체가 또렷이 움직이는 쪽:
```
"[Subject] [강한 동사: lunges / sprints / swings / leaps] through [scene]; tracking shot follows, [debris / cloth / hair] reacting to the motion, [lighting], [style]."
"Camera pushes in on [subject] as they [action]; [secondary motion: dust drifts / sparks scatter], [lighting]."
"Start with a close-up of [X], then pull back to reveal [environment] while [subject] [moves]."
```
절제형(차분·앰비언트·제품 락처럼 정지가 의도일 때만):
```
"Slow, stable pan left across [scene], no sudden motion."
```

규칙:
- **샷당 주 카메라 무브 하나.** push-in+pan+orbit 동시 → 불안정.
- 카메라 무브와 피사체 무브 정렬(빠른 피사체 + push-in 은 난이도↑).
- 모순 지시 금지(`static camera with fast push-in and orbit`).

## 모션

구체 동사 > 일반 동사:

| 의도 | 약함 | 강함 |
| --- | --- | --- |
| 고강도 달리기 | running | sprinting, dashing, bolting |
| 감정적 달리기 | running | fleeing, lunging, charging |
| 신체상태 | running | limping, trudging, staggering |
| 수직 점프 | jumping | leaping straight up to grab a ledge |

Motion Intensity 1~10: **1~3** 미세(호흡/느린 구름), **7~10** 고강도(질주). 달리기엔 7~10, 해부 흔들리면 네거티브 `morphing, warping, extra limbs`.

**기본은 5~7**(피사체 동작이 또렷이 보이는 정도). 액션·스포츠·댄스는 7~10, **1~3은 앰비언트·루프·제품 매크로처럼 정지가 의도일 때만**. (깜빡임/지터가 문제일 땐 동적이면서도 안정적인 **4~5**로 내린다 — `kling-troubleshooting`.) `static camera` · `no sudden movement` · `… motion only` 같은 모션 억제 접미사는 사용자가 차분·정지를 **명시**할 때만 붙인다 — 기본으로 달지 말 것(omni 는 프롬프트가 유일한 모션 레버라, 이 접미사를 붙이면 영상이 거의 멈춘다).

FPS/강도: 시네마틱 24 / 표준·소셜 30 / 부드러운 액션 60. 소셜 9:16 은 30·intensity 80~90%, 교육은 30·40~60%.

구조: 약함 `A man running.` → 강함 `A full body shot of a man sprinting through a neon-lit street, steam rising from the pavement, tracking shot following the athlete, cinematic depth of field, 4-second duration.` 동작은 full body shot 에서 잘 보인다. 속도 수식 중요(`slow, deliberate wave` ≠ `frantic, rapid wave`).

## 정합·조명은 별도 가이드

- 캐릭터 일관성·드리프트 방지(subject binding, 멀티샷 정합, 멀티캐릭터) → `kling-consistency`.
- 조명 어휘·색온도·포토리얼리즘 → `kling-lighting`.
- 결과가 나쁠 때 증상→처방 → `kling-troubleshooting`.
