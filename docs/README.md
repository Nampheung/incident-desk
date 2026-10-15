# Docs index

Where to look before you start a task. Paths are relative to this file. Entries marked _created later_ do not exist yet; skip them until they do.

## Task → files to read

| Task                                           | Read                                                                                                                                  |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| Understand the product, roles, and scope       | [requirements.md](requirements.md), [user-stories.md](user-stories.md)                                                                |
| Implement a user story or ticket               | The GitHub issue, [user-stories.md](user-stories.md), the matching [mockup](#ui-mockups), `GLOSSARY.md` (_created later_), `adr/` (_created later_) |
| Build or change a screen                       | The matching [mockup](#ui-mockups), [requirements.md](requirements.md)                                                                |
| Add real-time updates (Turbo, broadcasts)      | [requirements.md](requirements.md) §3.3, skill `rails-hotwire`                                                                        |
| Add the overdue escalation job or audit events | [requirements.md](requirements.md) §3.4–3.5, [user-stories.md](user-stories.md) Story 6                                               |
| Create, read, or update GitHub issues          | [agents/issue-tracker.md](agents/issue-tracker.md)                                                                                    |
| Name a domain concept or record a decision     | [agents/domain.md](agents/domain.md), `GLOSSARY.md` (_created later_), `adr/` (_created later_)                                       |
| Finish a ticket or open a PR                   | [definition-of-done.md](definition-of-done.md)                                                                                        |
| Review a branch or PR                          | [requirements.md](requirements.md), [user-stories.md](user-stories.md), skill `code-review`                                           |
| Set up the app, seed users, run tests          | [../README.md](../README.md)                                                                                                          |
| Write or change code                           | `../.claude/rules/` (_created later_)                                                                                                 |

## How to read the rules

`.claude/rules/` is _created later_. Until it exists, skip this section.

- Each file is one Markdown rule set for one topic.
- A file whose frontmatter has `paths:` (a list of globs) applies only to files matching those globs. A file without `paths:` applies to all work.
- Before editing, list `.claude/rules/` and read every rule whose `paths:` match a file you will touch, plus every rule without `paths:`. Claude Code loads these automatically; other agents must read them by hand.
- Rules are this repo's coding standards. The `code-review` skill checks the diff against them.

## How to read the definition of done

Read [definition-of-done.md](definition-of-done.md) twice per ticket:

1. **Before you start:** turn each item that applies into a test or a task in your plan.
2. **Before you report done or open a PR:** go through every category in order. Run each command and check each item. Mark it `[x]`, or write "n/a" with a reason.

- A required item that fails means the ticket is not done. Fix it, or report the failure with the command output.
- _(optional)_ items never block. Do them when they apply and cost little, and say which ones you ran.
- Put the checked list in the PR body.
- If a rule in `.claude/rules/` conflicts with the definition of done, stop and ask the user which one wins.

## Documents

| File                                           | Contents                                                                    |
| ---------------------------------------------- | --------------------------------------------------------------------------- |
| [requirements.md](requirements.md)             | Roles, functional requirements, out-of-scope list                           |
| [user-stories.md](user-stories.md)             | Stories 1–6 with acceptance criteria                                        |
| [definition-of-done.md](definition-of-done.md) | Checklist a ticket must pass before merge                                   |
| [agents/issue-tracker.md](agents/issue-tracker.md) | `gh` commands and conventions for issues                                |
| [agents/domain.md](agents/domain.md)           | How to use the glossary and ADRs                                            |
| [../README.md](../README.md)                   | Setup, users and roles, demo users, tests                                   |
| `../GLOSSARY.md`                               | _Created later_ by the `domain-modeling` skill                              |
| `adr/`                                         | _Created later_ by the `domain-modeling` skill                              |
| `../.claude/rules/`                            | _Created later_: coding rules, see [How to read the rules](#how-to-read-the-rules) |

## UI mockups

Static HTML in [design/](design/). Open in a browser.

| File                                                   | Screen                                         | Role     | Story |
| ------------------------------------------------------ | ---------------------------------------------- | -------- | ----- |
| [design/index.html](design/index.html)                 | Sign in                                        | Both     | 1     |
| [design/my-tickets.html](design/my-tickets.html)       | My tickets list                                | Customer | 2     |
| [design/new-ticket.html](design/new-ticket.html)       | New ticket form                                | Customer | 2     |
| [design/customer-ticket.html](design/customer-ticket.html) | Ticket detail and comments                 | Customer | 5     |
| [design/agent-tickets.html](design/agent-tickets.html) | All tickets, with filter and overdue flag      | Agent    | 3, 6  |
| [design/agent-ticket.html](design/agent-ticket.html)   | Ticket detail: status, assignee, comments      | Agent    | 4, 5  |

## Skills

In [../.agents/skills/](../.agents/skills/) (linked from `.claude/skills/`).

| Skill             | Use for                                                          |
| ----------------- | ---------------------------------------------------------------- |
| `implement`       | Implementing a spec or tickets (user-invoked only)               |
| `tdd`             | Building features or fixing bugs test-first                      |
| `rails-hotwire`   | Turbo Drive/Frames/Streams, morphing, Stimulus                   |
| `code-review`     | Reviewing changes against coding standards and the spec          |
| `domain-modeling` | Editing `GLOSSARY.md` or recording an ADR                        |
| `to-tickets`      | Splitting a plan or spec into GitHub issues (user-invoked only)  |
