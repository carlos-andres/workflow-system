# Decision Log

> Index of all architecture and technical decisions across this project.

---

## Decisions

| ID | Date | Ticket | Decision | Status | ADR Location |
|----|------|--------|----------|--------|--------------|
| D001 | {YYYY-MM-DD} | {JIRA-ID} | {Brief decision title} | Accepted | `feature/{jira-id}/adr.md` |
| D002 | {YYYY-MM-DD} | {JIRA-ID} | {Brief decision title} | Accepted | `feature/{jira-id}/adr.md` |
| D003 | {YYYY-MM-DD} | {JIRA-ID} | {Brief decision title} | Proposed | `feature/{jira-id}/adr.md` |

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

1. Document in `feature/{jira-id}/adr.md`
2. Add entry to this log
3. Assign next ID (D001, D002, etc.)

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
