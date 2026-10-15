# Pull request guidelines

A pull request (PR) is written for one reader: the reviewer who decides whether it can merge. Give them what they need to make that decision quickly, and leave out the rest.

Every PR uses the template in [`.github/pull_request_template.md`](../.github/pull_request_template.md). GitHub fills it in when you open a PR.

## Keep the PR focused

- **One issue per PR.** Link it with `Closes #<number>` and check that the issue title matches the work. A wrong number closes the wrong issue on merge. A fork and its upstream number issues separately, so use the number from the repository the PR targets.
- **Split unrelated changes** into their own PR: refactors, dependency bumps, vendored files, formatting sweeps. If a split is not practical, name them in one line under _What changed_ so the reviewer can skip them.
- **Keep the diff small enough to review in one sitting.** As a rough guide, stay under about 400 lines of hand-written code. Generated files such as `db/schema.rb` and lockfiles don't count.
- **Open a draft** while `bin/ci` is still red or the work is unfinished. Mark it ready when every step passes.

## Title

Use the same `type(scope): Subject` style as the commit history:

| Type       | Use for                                  |
| ---------- | ---------------------------------------- |
| `feat`     | A new behaviour users can see            |
| `fix`      | A bug fix                                |
| `refactor` | A code change with no behaviour change   |
| `test`     | Tests only                               |
| `docs`     | Documentation only                       |
| `chore`    | Tooling, dependencies, configuration     |

- Describe the outcome, not the activity. Start the subject with a capitalized imperative verb.
- Keep the whole title under 72 characters.

| Weak                    | Strong                                                    |
| ----------------------- | --------------------------------------------------------- |
| `login`                 | `feat(auth): Sign in with email and password`             |
| `Fix bug`               | `fix(tickets): Show overdue flag on unassigned tickets`   |
| `Updates to user model` | `fix(auth): Enforce exactly one role per user`            |

## Description

Fill in every section of the template. Write each one for a reviewer who has not read the issue.

### Summary

One to three sentences on what the PR does, in user terms: what a customer or agent can now do, or what now works. End with `Closes #<number>`.

### What changed

- List the key changes as bullets, grouped by area: models, controllers, views, migrations, config, tests.
- Name the files or classes a reviewer should look at first.
- Describe behaviour, not lines. "Sign-in attempts are rate-limited to 10 per 3 minutes" helps more than "added `rate_limit` to `SessionsController`".
- When the shape of the change matters, a small tree, call flow, or pseudocode block beats a paragraph. Keep it to what the reviewer needs.
- Cover generated or vendored files in one line, for example: "`db/schema.rb` regenerated".

### Why

- The problem this solves, or the requirement it meets. Link the user story or requirement section.
- Why you chose this approach, when it isn't obvious. Name a rejected alternative in one line if a reviewer is likely to suggest it.

### Test plan

Show how you verified the change and how a reviewer can check it again.

- List the commands you ran, each with its result line, for example: `bin/rails test` → `33 runs, 0 failures`. `bin/ci` must pass.
- Give manual steps as a numbered list a reviewer can follow in `bin/dev`: which user to sign in as, which page to open, what to expect.
- For UI changes, add before and after screenshots.
- Name the tests that cover the new behaviour, especially access rules for a signed-out visitor, a customer, and an agent.
- Paste the checked [definition of done](definition-of-done.md) into the collapsed block. Mark each item that doesn't apply "n/a" with a reason.

### Risks / notes

List what could go wrong after merge, and anything else the reviewer must know:

- Breaking changes, and who or what they affect.
- Migrations: are they reversible, and do they change existing data?
- New environment variables, gems, or packages.
- Security-sensitive areas: authentication, access control, user-entered text.
- Known limitations and planned follow-ups, with issue links.

If there are none, write **None.** Never leave the section empty: an empty section reads as unchecked.

## Writing style

- Use the project's domain terms (_customer_, _agent_, _ticket_, _severity_, _status_), as defined in [requirements.md](requirements.md) and `GLOSSARY.md` once it exists.
- Prefer short sentences and bullets. Put file paths and commands in backticks.
- State facts plainly. "Tests pass" only after you ran them, and include the output line.
- Leave out the debugging story, commit-by-commit narration, and full file lists. The commits and the diff already hold them.
- Update the description when the scope changes during review.

## Security

- Never paste secrets into a PR, its comments, or its screenshots: passwords, tokens, keys, real customer data, internal employee data, or financial data. Refer to environment variable names instead, such as `DEMO_AGENT_PASSWORD`.
- If the diff or the branch history contains a hardcoded credential, don't merge. Rotate the credential, purge it from git history, then open the PR again.

## Make review easier

- Review your own diff on GitHub before you request a review.
- Leave a GitHub comment on lines that need context: a tricky query, a deliberate workaround.
- Reply to every review comment. During review, push fixes as new commits so the reviewer can see what changed.
