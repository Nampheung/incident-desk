# Definition of Done

A ticket is done when every item below is checked. If an item does not apply, write "n/a" and a reason. Items marked _(optional)_ are not yet project policy: they are guesses, or steps the repo has but has not turned on.

## Functionality

- [ ] Every acceptance criterion of the story in [user-stories.md](user-stories.md) works in the running app (`bin/dev`).
- [ ] Ticket fields and values match [requirements.md](requirements.md) §3.2: severity is one of `Low`, `Medium`, `High`, `Urgent`; status is one of `Open`, `In Progress`, `Resolved`; a new ticket starts as `Open`.
- [ ] Ticket form validation matches Story 2: title has at least 5 characters, description has at least 10.
- [ ] Each status change creates an audit event (§3.5).
- [ ] Status changes and new comments show up in another signed-in browser tab without a reload (§3.3).
- [ ] A `High` or `Urgent` ticket that is still `Open` and unassigned after 15 minutes is flagged and a notification is logged (§3.4, Story 6).
- [ ] The screen matches its mockup in [design/](design/): same headings, columns, labels, and controls.
- [ ] Nothing from the out-of-scope list (§4) is built: no password-reset email, no attachments, no extra roles, no WYSIWYG editor.

## Access Control

- [ ] Every new controller action requires sign-in. `allow_unauthenticated_access` is used only in `SessionsController`.
- [ ] A customer who requests another customer's ticket (view, edit, update, or comment) is refused, and a controller test covers it.
- [ ] Only agents can change a ticket's status or assignee. A controller test shows a customer's attempt fails.
- [ ] Agents can view, assign, and update any ticket. A controller test covers it.
- [ ] Each Turbo Stream subscription is scoped to one ticket, so a customer gets broadcasts only for their own tickets.
- [ ] Roles are checked with `customer?` / `agent?` on `User`. Only `customer` and `agent` exist.

## Code Quality

- [ ] `bin/rubocop` passes.
- [ ] The diff adds no `rubocop:disable` comments.
- [ ] The diff has no leftover `debugger`, `binding.irb`, or `console.log`.
- [ ] Each new model validation has a matching database constraint: `null: false`, a foreign key, or a unique index.
- [ ] Domain names (models, methods, tests) use the terms in `GLOSSARY.md`, once that file exists.
- [ ] _(optional)_ Real-time updates use Turbo Streams or broadcasts, with no hand-written WebSocket JavaScript.

## Testing

- [ ] `bin/rails test` passes.
- [ ] `env RAILS_ENV=test bin/rails db:seed:replant` passes.
- [ ] Each acceptance criterion in the story has at least one test.
- [ ] Access rules are tested for a signed-out visitor, a customer, and an agent.
- [ ] _(optional)_ Broadcasts are tested with `assert_turbo_stream_broadcasts`.
- [ ] _(optional)_ Jobs are tested with `assert_enqueued_with` and `perform_enqueued_jobs`.
- [ ] _(optional)_ `bin/rails test:system` passes. This step is commented out in `config/ci.rb`, and `test/system/` does not exist yet.

## Security

- [ ] `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error` passes.
- [ ] `bin/bundler-audit` passes.
- [ ] `yarn audit` passes.
- [ ] The diff contains no passwords, tokens, keys, or other credentials. Secrets come from environment variables or Rails credentials. If one was committed, rotate it and purge it from git history before merging.
- [ ] `git ls-files config/*.key` prints nothing.
- [ ] New sensitive parameters are added to `config/initializers/filter_parameter_logging.rb`.
- [ ] User-entered text (titles, descriptions, comments) is rendered escaped, with no `raw` or `html_safe` on it.
- [ ] Seeds, fixtures, and tests use made-up data only, such as `@example.com` addresses. No real customer or employee data.

## Operations

- [ ] `bin/setup --skip-server` succeeds on a fresh clone.
- [ ] Background jobs inherit from `ApplicationJob` and run on Solid Queue, the database queue. No other queue adapter is added.
- [ ] Each new environment variable is listed in the root [README.md](../README.md) table, and the app handles it being unset.
- [ ] With `bin/dev` running, `curl -s -o /dev/null -w '%{http_code}' http://localhost:3000/up` prints `200`.
- [ ] `RAILS_ENV=test bin/rails db:migrate:redo STEP=<number of new migrations>` passes, and the matching `db/schema.rb` change is committed. Run it against the test database so it does not drop development data.
- [ ] `git diff --diff-filter=M main...HEAD -- db/migrate` prints nothing: no migration already on `main` is edited.
- [ ] _(optional)_ `bin/kamal deploy` succeeds. Deployment is not set up yet: `config/deploy.yml` still has a placeholder server and registry.

## Documentation

- [ ] The root [README.md](../README.md) covers any new setup step, command, or environment variable.
- [ ] A new domain term is added to `GLOSSARY.md` with the `domain-modeling` skill. The file is created when the first term is added.
- [ ] A hard-to-reverse decision is recorded as an ADR in `docs/adr/` with the `domain-modeling` skill.
- [ ] A new doc, mockup, or skill is added to [docs/README.md](README.md).

## Delivery

- [ ] `bin/ci` passes locally with every step green. It is the only CI: the repo has no GitHub Actions.
- [ ] The work is on a branch off `main`, and the GitHub issue is linked from the PR. The issue is in the repository the PR targets: a fork and its upstream number issues separately.
- [ ] _(optional)_ Commit messages follow the `type(scope): Subject` style from the git history.
- [ ] _(optional)_ The `code-review` skill was run against `main`, and its findings are fixed or answered.
- [ ] _(optional)_ `gh signoff` sets a green commit status. This step is commented out in `config/ci.rb`.
- [ ] **Last step:** the PR is open, and its body follows [`.github/pull_request_template.md`](../.github/pull_request_template.md), written as [pull-requests.md](pull-requests.md) describes:
  - The title has the form `type(scope): Subject` and is under 72 characters.
  - Every template section is filled in, and _Risks / notes_ says **None.** when there are none.
  - The body has `Closes #<issue>`, so the issue closes on merge.
  - This checked list is pasted into the _Definition of done_ block.
