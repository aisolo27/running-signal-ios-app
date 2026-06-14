# Physical iPhone Repeat-Block Proof - 2026-06-14

This folder archives physical-iPhone screenshots from the latest repeat-block normal-detail build installed on `AIS17PM`.

## Screenshots

- `screenshots/may 20 v1.PNG`
- `screenshots/may 20 v2.PNG`
- `screenshots/may 20 v3.PNG`
- `screenshots/may 20 v4.PNG`
- `screenshots/may 20 v5.PNG`
- `screenshots/Jun 3 v1.PNG`
- `screenshots/Jun 3 v2.PNG`
- `screenshots/Jun 3 v3.PNG`
- `screenshots/Jun 3 v4.PNG`
- `screenshots/jun 10 v1.PNG`
- `screenshots/jun 10 v2.PNG`
- `screenshots/jun 10 v3.PNG`
- `screenshots/jun 10 v4.PNG`
- `screenshots/jun 10 v5.PNG`
- `screenshots/jun 10 v6.PNG`

## Review

### 2026-05-20

Physical screenshots show the clean repeat-block normal-detail gate rendering the expected ten-row sequence:

1. Warmup
2. Work 1
3. Recovery 1
4. Work 2
5. Recovery 2
6. Work 3
7. Recovery 3
8. Work 4
9. Recovery 4
10. Cooldown

The visible rows preserve Work/Recovery numbering, keep the final row labeled `Cooldown`, and do not show an `Open / Extra` tail.

### 2026-06-03

Physical screenshots show the clean repeat-block normal-detail gate rendering the expected eight-row sequence:

1. Warmup
2. Work 1
3. Recovery 1
4. Work 2
5. Recovery 2
6. Work 3
7. Recovery 3
8. Cooldown

The visible rows preserve Work/Recovery numbering, keep the final row labeled `Cooldown`, and do not show an `Open / Extra` tail.

### 2026-06-10

Physical screenshots show the clean repeat-block fixed-cooldown Open/Extra-tail normal-detail gate rendering the expected eleven-row sequence:

1. Warmup
2. Work 1
3. Recovery 1
4. Work 2
5. Recovery 2
6. Work 3
7. Recovery 3
8. Work 4
9. Recovery 4
10. Cooldown
11. Open / Extra

The visible rows preserve Work/Recovery numbering, keep the fixed planned row labeled `Cooldown`, and show the final residual row as `Open / Extra`.

## Decision

This is physical-iPhone proof that the narrow clean repeat-block gate works for May 20 and June 3, and that the narrow clean repeat-block fixed-cooldown Open/Extra-tail gate works for June 10 on the latest installed build.

This proof does not approve broad repeat-block promotion. April 22-style paused/timer-drift repeat blocks, May 1-style recovery/tail/pause cases, ambiguous repeat-tail cases, and recovery-containing Open/Extra tail cases remain blocked.
