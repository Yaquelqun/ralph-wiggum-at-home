# Specification: remove-deprecation-warnings

## Overview

Remove Ruby 3.3 and Rails 7.2 deprecation warnings from the codebase to prepare for Rails 8.0 upgrade. The app runs on Ruby 3.3.9 and Rails ~> 7.2.2.1.

## Goals

- Eliminate all deprecation warnings emitted at runtime during test suite and app boot
- Update deprecated APIs to their modern equivalents
- Ensure no behavioral changes — these are mechanical replacements only

## Non-Goals

- Upgrading to Rails 8.0 (just preparing for it)
- Refactoring code beyond the minimum needed to replace deprecated APIs
- Fixing non-deprecation warnings (e.g. unused variables, RuboCop offenses)
- Changing test assertions or test structure beyond what's needed for deprecation fixes

## Acceptance Criteria

- [ ] No deprecation warnings appear when running a few specs (in stderr)
- [ ] No deprecation warnings appear during app boot (`RAILS_ENV=development bundle exec rails runner "puts 'ok'"`)
- [ ] All existing tests continue to pass after changes

## Technical Notes

- This is a component-based Rails app with engines in `components/`. Enum definitions exist in both `app/models/` and in component relation/model files.
- Changes should be purely mechanical — no behavioral differences expected.
- Each task in the implementation plan should be independently committable and testable.
- Detailed per-task context is in the implementation plan — refer to that for specifics.
