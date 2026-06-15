# infision — Claude 공식 플러그인

infision 캔버스를 Claude 에 연결한다. 원격 MCP 서버로 캔버스 읽기/쓰기와 이미지·비디오 생성을,
번들 스킬로 모델별 프롬프트 작법과 AI 영화제작 워크플로를 제공한다.

## 설치

```
/plugin marketplace add wooobo/infision-plugin
/plugin install infision@infision
```

설치 후 `/mcp` 에서 `infision` 서버 OAuth 인증을 진행한다.

## 구성

- `plugins/infision/.mcp.json` — 원격 MCP 커넥터 (infision 서버)
- `plugins/infision/skills/` — 이미지·영상 프롬프트 작법, AI 영화제작 스킬

> 이 repo 는 [infision 모노repo](https://github.com/wooobo/pago) 에서 생성·미러링된다.
> 스킬 원본은 모노repo 의 `backend/internal/skillsrc` — 직접 수정하지 말 것.
