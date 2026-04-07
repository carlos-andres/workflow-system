# Decision Log

> Index of all architecture and technical decisions across this project.

---

## Decisions

| ID | Date | Ticket | Decision | Status | ADR Location |
|----|------|--------|----------|--------|--------------|
| D001 | {YYYY-MM-DD} | {TICKET-ID} | {Brief decision title} | Accepted | `.devwork/decisions/D001-{slug}.md` |
| D002 | {YYYY-MM-DD} | {TICKET-ID} | {Brief decision title} | Accepted | `.devwork/decisions/D002-{slug}.md` |
| D003 | {YYYY-MM-DD} | {TICKET-ID} | {Brief decision title} | Proposed | `.devwork/decisions/D003-{slug}.md` |

---

## By Category

### Architecture
- D001: {decision}

### Database
- D002: {decision}

### API Design
- {none yet}

### Performance
- {none yet}

### Security
- {none yet}

---

## Superseded Decisions

| Original | Superseded By | Reason |
|----------|---------------|--------|
| D001 | D005 | {why it changed} |

---

## How to Add

When making a significant decision during a ticket:

1. Draft in working folder: `.devwork/{type}/{ticket-id}/adr.md`
2. Add entry to this log with `Proposed` status
3. Assign next ID (D001, D002, etc.)
4. On `/work ship` → Graduate to `.devwork/decisions/D{NNN}-{slug}.md` and mark `Accepted`

### What Qualifies as a Decision?

- Technology choices (library, framework, service)
- Architecture patterns (how components interact)
- Data model changes (schema design)
- API design choices (endpoints, formats)
- Security approaches
- Performance optimizations

### What Doesn't Need an ADR?

- Implementation details (how to write a function)
- Bug fixes (unless they reveal a design flaw)
- Routine changes following existing patterns

---

## Graduation Process

ADRs live in two places depending on their lifecycle stage:

| Stage | Location |
|-------|----------|
| Working (in-progress) | `.devwork/{type}/{ticket-id}/adr.md` |
| Graduated (accepted, permanent) | `.devwork/decisions/D{NNN}-{slug}.md` |

During `/work ship` Gate 3, accepted ADRs are promoted from working folders to `.devwork/decisions/`. Update this log with the final location and mark status `Accepted`.
