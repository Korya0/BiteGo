---
name: work-flow
description: "Autonomous Feature Production Workflow"
---

# Autonomous Feature Production Workflow

## Purpose

This skill defines an autonomous workflow for taking a Flutter feature from initial idea and provided inputs to production-ready implementation.

The human developer should provide all available feature inputs once, answer one consolidated batch of questions, and then allow the agent to execute the complete feature lifecycle autonomously.

The agent must not repeatedly ask for confirmation between phases unless a genuinely blocking business or technical decision cannot be safely resolved from the available context.

---

# Core Principle

The workflow follows:

Feature Handoff
→ Full Discovery
→ One-Time Human Decision Gate
→ Autonomous Planning
→ Autonomous Implementation
→ Autonomous Verification
→ Production Ready

The developer should NOT manually drive the agent through F01, F02, F03, etc.

The agent owns the complete workflow after the initial approval.

---

# Human Responsibilities

The human developer provides:

- Feature idea
- Figma designs
- Screenshots when necessary
- User flows
- API documentation
- API examples
- Firebase requirements
- Firebase documentation/configuration when applicable
- Assets
- Business rules already known
- Existing constraints
- Special requirements
- Any known edge cases
- Any relevant existing feature references

The human developer is responsible for business decisions and final QA.

The agent is responsible for engineering execution.

---

# Agent Responsibilities

The agent is responsible for:

- Project discovery
- Requirements analysis
- PRD
- Architecture
- Data/API/Firebase design
- Task breakdown
- Implementation
- Code review
- Refactoring
- Testing
- Documentation
- Git commits
- Pull Request preparation
- Final technical verification

---

# IMPORTANT: Existing Project Rules

Before making any changes, inspect the existing project.

The agent MUST identify and follow existing project conventions.

Inspect:

- Architecture
- Folder structure
- Naming conventions
- File naming
- State management
- Repository pattern
- Dependency injection
- Routing
- Error handling
- Failure models
- API clients
- Firebase usage
- DTO patterns
- Entity patterns
- Model patterns
- Mapper patterns
- Testing patterns
- Theme system
- Reusable widgets
- Extensions
- Utilities
- Localization
- Existing feature implementations
- Existing dependencies
- Existing lint rules
- Existing formatting rules

Do not introduce a new pattern when an equivalent project pattern already exists.

Existing project conventions have priority over generic recommendations.

---

# Project Stack

The expected project architecture is:

- Flutter
- Clean Architecture
- Feature First
- Cubit
- Repository Pattern

However, the agent must verify the actual project before assuming these conventions.

If the existing project differs, follow the existing project architecture unless the feature explicitly requires an architectural change.

---

# CODE RULES

## No Code Comments

The agent MUST NOT add comments inside production code.

Do not add:

- Explanatory comments
- Inline comments
- TODO comments
- Generated comments
- Documentation comments
- Commented-out code
- AI-generated explanations inside source files

Code should communicate intent through:

- Clear naming
- Small responsibilities
- Proper abstractions
- Clean structure

Existing comments must not be removed unless they are directly related to the requested change.

---

# Follow Existing Code Style

The agent MUST match the surrounding code style.

Do not introduce:

- Different naming conventions
- Different architecture patterns
- Different state patterns
- Different error handling
- Different dependency injection approaches
- Different formatting styles
- Unnecessary abstractions

Prefer consistency with existing production code.

---

# DO NOT Over-Engineer

Do not introduce abstractions unless they solve an actual requirement.

Avoid:

- Unnecessary base classes
- Unnecessary interfaces
- Unnecessary generic abstractions
- Unnecessary helpers
- Unnecessary services
- Unnecessary packages
- Unnecessary architecture changes

Implement the smallest clean solution that satisfies the feature requirements and project conventions.

---

# FEATURE DOCUMENTATION

Each feature must have its own documentation workspace.

Recommended structure:

docs/features/<feature_name>/

    README.md

    01-requirements.md
    02-prd.md
    03-architecture.md
    04-data-design.md
    05-testing-strategy.md

    tasks/
        TASK-001.md
        TASK-002.md
        TASK-003.md

    execution-log.md
    code-review.md
    testing-report.md
    documentation.md
    pull-request.md
    final-qa.md

The agent may adapt the structure when the feature does not require a specific document.

---

# README.md

README.md is the Feature Control Center.

It must contain:

- Feature name
- Current status
- Current phase
- Current task
- Planning status
- Architecture status
- Data design status
- Testing status
- Completed tasks
- Remaining tasks
- Blocking decisions
- Human decisions
- Final status

Example status:

Feature: Order Tracking

Status: IN_PROGRESS

Planning: APPROVED
Architecture: APPROVED
Data Design: APPROVED

Current Phase: F06
Current Task: TASK-007

Completed:
TASK-001
TASK-002
TASK-003

Remaining:
TASK-007
TASK-008
TASK-009

Blocked:
None

---

# PHASES

The workflow contains the following phases:

F01 — Requirements

F02 — Product Spec / PRD

F03 — Architecture

F04 — Data / API / Firebase Design

F05 — Task Breakdown

F06 — Coding

F07 — Code Review

F08 — Refactoring

F09 — Testing

F10 — Documentation

F11 — Pull Request

F12 — Final QA

---

# F01 — Requirements

Objective:

Understand the feature completely before implementation.

Analyze:

- Goal
- User Story
- Business Rules
- Functional Requirements
- Non Functional Requirements
- Edge Cases
- Acceptance Criteria
- Dependencies
- Constraints

Do not implement code.

Output:

01-requirements.md

---

# F02 — Product Spec

Create the feature PRD.

Include:

- Overview
- User Flow
- Functional Requirements
- Non Functional Requirements
- Screen Behavior
- Loading States
- Empty States
- Error States
- Success States
- Acceptance Criteria

Output:

02-prd.md

---

# F03 — Architecture

Design the implementation according to the existing project architecture.

Analyze:

- Folder Structure
- Layers
- Classes
- Responsibilities
- Data Flow
- Interfaces
- Dependencies
- State Management
- Navigation
- Dependency Injection

Do not blindly introduce generic Clean Architecture patterns.

Follow existing project conventions.

Output:

03-architecture.md

---

# F04 — Data / API / Firebase Design

Determine which external or internal data sources are required.

Depending on the feature, analyze:

- REST APIs
- Firebase
- Firestore
- Realtime Database
- Authentication
- Authorization
- Local Storage
- Cache
- Pagination
- DTOs
- Models
- Entities
- Repository Contracts
- Error Models
- Failure Mapping
- Data Mapping

Only create what the feature actually requires.

Output:

04-data-design.md

---

# F05 — Task Breakdown

Break the implementation into small, independently verifiable tasks.

Tasks should generally be small enough to understand and verify independently.

Each task must contain:

- Task ID
- Objective
- Context
- Dependencies
- Files to create
- Files to modify
- Expected behavior
- Acceptance criteria
- Testing requirements
- Implementation constraints
- Definition of Done

Store each task under:

docs/features/<feature_name>/tasks/

Example:

TASK-001.md
TASK-002.md
TASK-003.md

The agent generates the task execution instructions automatically.

The developer does not manually create prompts for each task.

---

# F06 — Coding

Execute tasks sequentially.

For every task:

1. Read the task contract.
2. Inspect existing related code.
3. Implement only the required task.
4. Follow existing project conventions.
5. Do not add production comments.
6. Do not modify unrelated code.
7. Run relevant checks.
8. Verify acceptance criteria.
9. Review the implementation.
10. Fix issues if required.
11. Mark the task complete.
12. Continue to the next task.

Do not implement unrelated future tasks early unless required by an explicit dependency.

---

# F07 — Code Review

Review the implementation against:

- Requirements
- PRD
- Architecture
- Task Contract
- Acceptance Criteria
- Existing Project Conventions
- Clean Architecture
- SOLID
- Error Handling
- Performance
- Memory Management
- Naming
- Code Smells
- Security
- Maintainability
- Testability

The review must identify real issues.

Do not invent problems merely to produce a longer review.

If issues are found:

Fix them automatically when they can be safely fixed.

Then rerun verification.

---

# F08 — Refactoring

Refactor only when there is a meaningful improvement.

Goals:

- Improve readability
- Improve maintainability
- Reduce duplication
- Improve structure
- Improve naming
- Remove unnecessary complexity

Do not change feature behavior.

Do not refactor unrelated project code.

After refactoring:

- Run tests
- Run analyzer
- Verify acceptance criteria

---

# F09 — Testing

Create and execute a testing strategy.

Test according to what the feature actually contains.

Possible test categories:

- Unit Tests
- UseCase Tests
- Repository Tests
- DataSource Tests
- Mapper Tests
- Cubit Tests
- Widget Tests
- Integration Tests
- Edge Cases
- Failure Cases

Before writing tests, determine the important behavior.

Test behavior rather than implementation details.

Verify:

- Success
- Failure
- Loading
- Empty states
- Error states
- Important edge cases
- User behavior

Run:

flutter test

flutter analyze

Run additional relevant checks based on the project.

Output:

09-testing-report.md

---

# F10 — Documentation

Document the final implementation.

Include:

- Architecture
- Data Flow
- Responsibilities
- Important decisions
- Extension Points
- Known limitations
- Future Improvements

Documentation must reflect the actual implementation.

Do not document functionality that does not exist.

---

# F11 — Pull Request

Prepare a professional Pull Request.

Include:

- Summary
- Changes
- Technical Details
- Testing
- Screenshots Placeholder
- Breaking Changes
- Known Limitations
- Checklist

Output:

11-pull-request.md

---

# F12 — Final QA

Perform final technical verification.

Verify:

- Feature requirements
- Acceptance criteria
- User flow
- UI states
- Loading
- Success
- Error
- Empty states
- API/Firebase integration
- Navigation
- Error handling
- Tests
- Analyzer
- Formatting
- No unintended changes
- No production code comments introduced
- No debug code
- No temporary files
- No unnecessary dependencies

The agent must not claim final QA passed unless the required checks were actually performed.

Output:

12-final-qa.md

---

# ONE-TIME HUMAN QUESTION GATE

This is one of the most important rules of the workflow.

Before autonomous execution, analyze the COMPLETE feature.

Do not ask questions phase-by-phase.

Instead, inspect F01 through F12 conceptually and identify every decision that requires human input.

Group all questions into one response.

Questions should cover:

- Business rules
- Product decisions
- Ambiguous UI behavior
- API behavior
- Firebase behavior
- Error behavior
- Empty states
- Authentication
- Authorization
- Navigation
- Permissions
- Offline behavior
- Caching
- Data persistence
- Edge cases
- Performance requirements
- Security requirements
- Analytics requirements
- Notifications
- Any other decision that can materially affect implementation

---

# QUESTION QUALITY

Do not ask questions whose answers can be determined from:

- Existing project code
- Existing architecture
- Existing documentation
- Figma
- API documentation
- Firebase configuration
- Existing feature patterns
- Standard project conventions

Research and inspect first.

Ask only questions that genuinely require human input.

---

# QUESTION FORMAT

Questions should be grouped and easy to answer.

Example:

## Business Decisions

### Q1 — Order Cancellation

Can a user cancel an order after preparation starts?

A. Yes
B. No
C. Only before a specific status

### Q2 — Failed Tracking

What should happen if tracking fails?

A. Show error
B. Show cached location
C. Retry automatically
D. Other

---

# FINAL OPEN-ENDED QUESTION

At the END of the consolidated questions, the agent MUST always ask:

## Final Question

Is there anything else you want to add?

Include anything that may affect the implementation, such as:

- Additional requirements
- Special behavior
- Business rules
- UI details
- Constraints
- Things to avoid
- Performance requirements
- Future considerations
- Any personal preference for this feature

The user may provide a free-form response.

This question must be asked even if no other questions remain.

---

# HUMAN APPROVAL

After receiving the answers, summarize the decisions.

Create:

01-requirements.md
02-prd.md
03-architecture.md
04-data-design.md
05-testing-strategy.md
05-task-plan

Then verify that the decisions are sufficient to proceed.

Enter:

AUTONOMOUS MODE

---

# AUTONOMOUS MODE

Once the human has answered the consolidated question batch, do not repeatedly request confirmation.

Proceed through:

F01
→ F02
→ F03
→ F04
→ F05
→ F06
→ F07
→ F08
→ F09
→ F10
→ F11
→ F12

The agent owns execution.

---

# BLOCKING DECISION RULE

The agent may stop autonomous execution only when:

1. A genuinely unresolved decision is discovered.
2. The decision materially affects behavior or architecture.
3. The answer cannot be safely inferred from project context.
4. Continuing would require guessing.

If blocked, clearly report:

- What is blocked
- Why it matters
- What was investigated
- Available options
- Recommended option if appropriate

Do not continue by guessing.

---

# GIT WORKFLOW

Git history must remain clean and meaningful.

## Commit Strategy

Do NOT create a commit for every file.

Do NOT create a commit for every 2–3 files.

Do NOT create commits for trivial modifications.

Create commits based on meaningful completed work.

The preferred commit unit is:

## One Logical Phase / Milestone = One Commit

Examples:

feat: add order tracking data layer

feat: add order tracking domain layer

feat: add order tracking presentation layer

test: add order tracking tests

docs: document order tracking feature

However, commit grouping should follow the actual implementation structure.

If an entire phase can be represented by one coherent commit, use one commit.

If a phase contains multiple independent logical units, multiple commits are acceptable.

Never split commits merely because files are separate.

---

# Git Commit Rules

Commit messages must be:

- Short
- Clear
- Professional
- Consistent
- Related to the actual change

Use Conventional Commits when the project follows or allows them.

Preferred format:

type: short description

Examples:

feat: add order tracking feature

test: add order tracking coverage

refactor: simplify order tracking state handling

docs: document order tracking architecture

fix: handle tracking request failure

---

# NEVER

Do not create commits such as:

update file
changes
fix stuff
AI changes
more changes
final
final final
test
updated

Do not mention AI in commit messages.

Do not create noisy commit history.

---

# Git Safety

Before committing:

- Inspect git status
- Review changed files
- Ensure no unrelated changes are included
- Ensure no secrets are committed
- Ensure no generated temporary files are committed
- Ensure formatting is correct
- Run relevant tests
- Run analyzer

Do not reset, revert, delete, or overwrite unrelated user changes.

Never discard user work without explicit permission.

---

# Unrelated Changes

The agent must preserve unrelated existing modifications.

If the working tree already contains user changes:

- Inspect them
- Do not overwrite them
- Do not include them in feature commits
- Keep feature changes isolated

---

# Dependencies

Do not add a package unless required.

Before adding a dependency:

1. Check whether the project already contains an equivalent capability.
2. Check existing dependencies.
3. Prefer existing project solutions.
4. Add a new package only when justified.

Document important dependency decisions.

---

# Definition of Done

A feature is complete only when:

- Requirements are documented
- PRD is documented
- Architecture is documented
- Data/API/Firebase design is documented when applicable
- Tasks are completed
- Implementation is complete
- Code review is complete
- Refactoring is complete when needed
- Tests are implemented
- Tests pass
- Analyzer passes
- Documentation is complete
- PR is prepared
- Final QA is complete
- Git history is clean
- No unintended changes are included

---

# Final Output

When the feature is complete, provide a concise final report containing:

Feature:
Status:

Implemented:
- ...

Tests:
- ...

Checks:
- flutter test
- flutter analyze
- Other relevant checks

Git:
- Commits created
- Branch status

Documentation:
- Feature documentation location

Known Limitations:
- ...

Final QA:
PASS / BLOCKED

Do not claim something passed unless it was actually verified.

---

# Autonomous Execution Philosophy

The agent should behave as a senior engineer executing an approved plan.

The agent should:

- Think before coding
- Inspect before modifying
- Reuse before creating
- Verify before committing
- Test before declaring success
- Document actual behavior
- Preserve existing project conventions
- Keep changes focused
- Keep Git history clean
- Avoid unnecessary questions
- Never guess important business decisions

The developer should make decisions once.

The agent should execute the approved plan from beginning to end.