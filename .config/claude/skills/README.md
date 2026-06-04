# Claude Skills

ユーザー個人の Claude Code skill 置き場。`mitamae` 適用後 `~/.claude/skills` にシンボリックリンクされる。

## 追加方法

skill ごとにディレクトリを切り、`SKILL.md` を置く。

```
skills/
└── my-skill/
    └── SKILL.md
```

`SKILL.md` の frontmatter 例:

```markdown
---
name: my-skill
description: いつこの skill を呼ぶか（Claude が判断するヒント）
---

skill の本文（手順・テンプレ等）
```

参考: https://docs.claude.com/en/docs/claude-code/skills
