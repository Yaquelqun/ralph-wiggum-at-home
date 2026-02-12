#!/usr/bin/env ruby
# frozen_string_literal: true

# Usage: ruby ralph_wiggum_setup.rb <feature-name>
#
# Creates a new Ralph Wiggum feature folder with all required files.
# The folder will be created at ralph_wiggum/features/<feature-name>/

class RalphWiggumSetup
  RALPH_WIGGUM_DIR = File.dirname(__FILE__)
  FEATURES_DIR = File.join(RALPH_WIGGUM_DIR, 'features')

  def initialize(feature_name)
    @feature_name = sanitize_feature_name(feature_name)
    @feature_dir = File.join(FEATURES_DIR, @feature_name)
  end

  def run
    validate_feature_name!
    ensure_features_dir_exists
    check_folder_does_not_exist!
    create_folder
    create_files
    puts "Created Ralph Wiggum feature folder: #{@feature_dir}"
    puts ""
    puts "Next steps:"
    puts "  1. Fill in #{@feature_dir}/specification.md with your feature spec"
    puts "  2. Add tasks to #{@feature_dir}/implementation_plan.md"
    puts "  3. Run: ruby ralph_wiggum/ralph_wiggum.rb #{@feature_dir}/prompt.md"
  end

  private

  def sanitize_feature_name(name)
    name.to_s.strip.gsub(/\s+/, '_').gsub(/[^a-zA-Z0-9_-]/, '')
  end

  def validate_feature_name!
    if @feature_name.empty?
      abort "Error: Feature name cannot be empty"
    end
  end

  def ensure_features_dir_exists
    Dir.mkdir(FEATURES_DIR) unless Dir.exist?(FEATURES_DIR)
  end

  def check_folder_does_not_exist!
    if Dir.exist?(@feature_dir)
      abort "Error: Folder already exists: #{@feature_dir}"
    end
  end

  def create_folder
    Dir.mkdir(@feature_dir)
  end

  def create_files
    create_prompt_file
    create_specification_file
    create_implementation_plan_file
    create_progress_file
    create_missing_permissions_file
  end

  def create_prompt_file
    content = <<~PROMPT
      # Ralph Wiggum Agent - #{@feature_name}

      You are an autonomous coding agent making incremental progress on a project, one task at a time.

      ## Setup

      Read these files first:
      - CLAUDE.md (project root)
      - ralph_wiggum/features/#{@feature_name}/specification.md
      - ralph_wiggum/features/#{@feature_name}/implementation_plan.md

      ## Constraints

      - Headless mode: no additional permissions granted
      - If blocked by permissions, log to ralph_wiggum/features/#{@feature_name}/missing_permissions.txt and continue
      - Only modify files related to your current task
      - If context is getting long, wrap up and exit

      ## Workflow

      1. Pick the first unfinished task with no unmet dependencies
      2. Write a failing test
      3. Implement minimum code to pass
      4. Run related tests + `RAILS_ENV=test bundle exec rubocop` on changed files
      5. Refactor if obvious improvement, re-run tests
      6. Mark task done in ralph_wiggum/features/#{@feature_name}/implementation_plan.md
      7. Commit with descriptive message referencing the task
      8. Log summary to ralph_wiggum/features/#{@feature_name}/progress.md
      9. Exit

      ## Failure Handling

      All failures result in the task being marked as failed with an additional comment:
      - Tests won't pass after 5 attempts → note in implementation_plan, move on
      - Missing permission → mark `[BLOCKED: permission - X]`
      - Context limit → mark `[PARTIAL: context limit]`
      If you mark a task as failed, mark all sub_tasks as failed as well
    PROMPT

    File.write(File.join(@feature_dir, 'prompt.md'), content)
  end

  def create_specification_file
    content = <<~SPEC
      # Specification: #{@feature_name}

      ## Overview

      <!-- Brief description of what this feature does -->

      ## Goals

      <!-- What we want to achieve -->

      ## Non-Goals

      <!-- What is explicitly out of scope -->

      ## Acceptance Criteria

      <!-- Concrete criteria to determine when the feature is complete -->
      - [ ] Criterion 1
      - [ ] Criterion 2

      ## Technical Notes

      <!-- Any technical constraints, dependencies, or architectural decisions -->
    SPEC

    File.write(File.join(@feature_dir, 'specification.md'), content)
  end

  def create_implementation_plan_file
    content = <<~PLAN
      # Implementation Plan: #{@feature_name}

      ## Task Format

      Tasks should follow this format:
      ```
      - [ ] [T001] Task description
            depends: T000 (optional, comma-separated)
            notes: Additional context (optional)
      ```

      ## TODO

      - [ ] [T001] Example task - replace with your first task

      ## DONE

      ## FAILED
    PLAN

    File.write(File.join(@feature_dir, 'implementation_plan.md'), content)
  end

  def create_progress_file
    content = <<~PROGRESS
      # Progress: #{@feature_name}

      ## Log

      <!-- Each iteration appends a summary here -->
      <!-- Format: [YYYY-MM-DD HH:MM] Task ID - Summary -->
    PROGRESS

    File.write(File.join(@feature_dir, 'progress.md'), content)
  end

  def create_missing_permissions_file
    File.write(File.join(@feature_dir, 'missing_permissions.txt'), '')
  end
end

# Main execution
if ARGV.empty?
  puts "Usage: ruby ralph_wiggum_setup.rb <feature-name>"
  puts ""
  puts "Example: ruby ralph_wiggum/ralph_wiggum_setup.rb user-authentication"
  exit 1
end

RalphWiggumSetup.new(ARGV[0]).run
