# Incident Desk

## Setup

```sh
bin/setup
```

## Users and roles

Sign-in uses Rails' built-in authentication. Each user has exactly one role, `customer` or `agent`
(managed with `rolify`). There is no password-reset flow.

### Demo users

`bin/rails db:seed` creates a demo customer and a demo agent. Their passwords are read from
environment variables and are never stored in the code. A demo user is skipped if its password is not set.

| Variable                 | Purpose                                                 |
| ------------------------ | ------------------------------------------------------- |
| `DEMO_CUSTOMER_PASSWORD` | Password for the demo customer                          |
| `DEMO_AGENT_PASSWORD`    | Password for the demo agent                             |
| `DEMO_CUSTOMER_EMAIL`    | Optional. Defaults to `customer@example.com`            |
| `DEMO_AGENT_EMAIL`       | Optional. Defaults to `agent@example.com`               |
| `PASSWORD`               | Optional. Password for `users:create`; prompted for if unset |
| `TEST_USER_PASSWORD`     | Optional. Fixture user password in tests; random if unset |

### Creating a user

```sh
bin/rails "users:create[someone@example.com,agent]"
```

The task prompts for the password. In a non-interactive shell, set `PASSWORD` instead.
Never pass the password as a task argument. The task fails if the role is not `customer` or `agent`,
or if the email is already taken.

## Tests

```sh
bin/rails test
```
