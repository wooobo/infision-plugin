# infision (Claude Code 플러그인)

infision 캔버스를 Claude 에 붙인다. 설치 한 번으로 두 가지가 들어온다:

- **MCP 도구** — 원격 infision 서버(`https://dev.infision.ai/mcp`)의 캔버스 읽기/쓰기 + 이미지·비디오 생성 + 작법 스킬 도구(`list_skills`/`read_skill`).
- **작법 스킬** — 모델별 이미지/영상 프롬프트 작법, AI 영화제작 워크플로(캐릭터 시트 → 스토리보드 → 영상). `backend/internal/skillsrc` 의 크리에이티브 번들을 동봉.

> 이 플러그인은 **Claude 전용** 패키지다. Codex/ChatGPT 는 같은 MCP 서버를 각자 커넥터로 붙인다 — [`docs/specs/mcp-plugin-distribution.md`](../../docs/specs/mcp-plugin-distribution.md) 참고.

## 설치

```
/plugin marketplace add wooobo/infision-plugin
/plugin install infision@infision
```

설치 후:
- `/mcp` 로 `infision` 서버가 보이면 OAuth 인증을 진행한다(서버가 401 + WWW-Authenticate 를 내면 Claude 가 자동으로 OAuth 흐름을 띄운다).
- 스킬은 `infision:image-prompt-craft` 처럼 네임스페이스로 노출된다.

## 구성

```
plugins/infision/
  .claude-plugin/plugin.json   매니페스트 (skills + mcpServers 경로)
  .mcp.json                    원격 MCP 커넥터 (type:http, url)
  skills/                      동봉 작법 스킬 (skillsrc 사본)
    image-prompt-craft/
    video-prompt-craft/
    ai-filmmaking/
  sync-skills.sh               skillsrc → skills/ 재동기화
```

## 스킬 동기화

`skills/` 는 `backend/internal/skillsrc` 의 사본이다(단일 진실원본 = skillsrc). 번들 콘텐츠를 고쳤으면:

```bash
plugins/infision/sync-skills.sh
```

## 전제

원격 도구가 동작하려면 `https://dev.infision.ai/mcp` 가 떠 있어야 한다(배포 환경에 `INFISION_MCP_RESOURCE_URL` 설정 필요). 미배포 상태에서 로컬 테스트는 [`docs/specs/mcp-plugin-distribution.md`](../../docs/specs/mcp-plugin-distribution.md) 의 localhost 절을 따른다.
