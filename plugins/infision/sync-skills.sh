#!/usr/bin/env bash
# 플러그인 skills/ 는 backend/internal/skillsrc 의 크리에이티브 번들을 복사한 사본이다.
# skillsrc 가 단일 진실원본(챗 에이전트 주입 + Anthropic 업로드 + 이 플러그인이 공유) —
# 번들 콘텐츠를 고쳤으면 이 스크립트로 플러그인 사본을 다시 맞춘다.
#
# 사용: plugins/infision/sync-skills.sh   (repo 어디서 실행해도 됨)
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="$(cd "$here/../.." && pwd)"
src="$repo/backend/internal/skillsrc"
dst="$here/skills"

# 플러그인에 동봉하는 크리에이티브 번들(개발 워크플로 스킬은 제외).
bundles=(image-prompt-craft video-prompt-craft ai-filmmaking)

for b in "${bundles[@]}"; do
  if [[ ! -d "$src/$b" ]]; then
    echo "missing source bundle: $src/$b" >&2
    exit 1
  fi
  rm -rf "${dst:?}/$b"
  cp -R "$src/$b" "$dst/$b"
  echo "synced $b ($(find "$dst/$b" -type f | wc -l | tr -d ' ') files)"
done

echo "done — plugins/infision/skills 가 skillsrc 와 일치합니다."
