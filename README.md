# Ralph Wiggum Loop

The Ralph Wiggum loop is agile and TDD applied to agentic AI. There is a Claude Code plugin for this, but from my understanding, it doesn't make sense to use it because the main advantage of that loop is to have each instance remember the minimum amount of context possible, so running it in one single instance defeats the purpose. Inspiration for this was [this video](https://www.youtube.com/watch?v=I7azCAgoUHc).

## Overview

The Ralph Wiggum Loop spawns headless Claude instances that:
1. Pick the next available task from an implementation plan
2. Write a failing test (TDD)
3. Implement the minimum code to pass
4. Run tests and linting
5. Commit the changes
6. Repeat until all tasks are done

## Quick Start

**/!\ THIS IS STILL VERY MUCH EXPERIMENTAL WHILE I'M FIGURING THINGS OUT. KEEP AN EYE ON IT ESPECIALLY IF THE TOKEN LIMIT IS YOUR CREDIT CARD :p**

```bash
# 1. Create a new feature folder
ruby ralph_wiggum/ralph_wiggum_setup.rb my-feature-name

# 2. Fill in the generated files. You're in charge of those 2 files since the ultimate goal is to go to sleep while this computes,
# You want to be as detailed/precised/aligned (whatever your buzzword du jour is) as possible
#    - ralph_wiggum/features/my-feature-name/specification.md  (describe what you're building)
#    - ralph_wiggum/features/my-feature-name/implementation_plan.md  (add your tasks)

# 3. Run the loop
ruby ralph_wiggum/ralph_wiggum.rb ralph_wiggum/features/my-feature-name/prompt.md
```

## Folder Structure

```
ralph_wiggum/
├── ralph_wiggum.rb        # Main loop runner
├── ralph_wiggum_setup.rb  # Feature folder generator
├── README.md              # This file
└── features/              # Feature folders created here
    └── <feature-name>/
        ├── prompt.md              # Agent instructions (auto-configured)
        ├── specification.md       # Feature spec (you fill this in)
        ├── implementation_plan.md # Task checklist (you fill this in)
        ├── progress.md            # Iteration log (agent updates this)
        └── missing_permissions.txt # Permission issues log
```

## Failure Handling

This part is still WIP. IMO good failure handling should lead to shorter loops.
The agent handles failures by marking tasks appropriately:

| Situation | Action |
|-----------|--------|
| Tests fail after 5 attempts | Mark `[FAILED]`, add note, move on |
| Missing permission | Mark `[BLOCKED: permission - X]`, log to `missing_permissions.txt` |
| Context limit reached | Mark `[PARTIAL: context limit]`, exit iteration |
| Task marked failed | All sub-tasks also marked failed |

## After Completion

When the loop finishes, check:
1. `implementation_plan.md` - verify all tasks in DONE section
2. `missing_permissions.txt` - review any permission issues
3. `progress.md` - see the iteration history

## Current State

I haven't tested this too much yet. I've simply done enough to get something out that we can all use simply.

Improvements include:
- Properly testing the system (^-^)"
- Add possibility to limit the amount of iterations instead of working in "until it's done" mode
- Add an "explore mode" with a different prompt for cases where we want the loop to investigate the codebase and come up with reports instead of code
- Improving the failing tasks management
- Add a "task reprioritization" step to be ran sometimes to make sure the implementation plan is up to date
- Make the whole system LLM-agnostic (it's close enough since most of it is markdown anyway, planning to implement this by adding another argument to the setup script)
- Improve/format logging
- Maybe add logic to push the commits and rely on the CI to run the full test suite and get results back to be able to iterate faster
