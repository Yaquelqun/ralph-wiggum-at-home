#!/usr/bin/env ruby
# frozen_string_literal: true

require 'shellwords'

# Usage: ruby ralph_wiggum.rb <path-to-prompt.md>
#
# This Ruby script implements the Ralph Wiggum Loop.
# It spawns headless Claude instances to work through tasks until complete.
class RalphWiggumLoop
  def initialize(prompt_path, model = 'opus')
    @prompt_path = File.expand_path(prompt_path)
    @model = model
    @feature_dir = File.dirname(@prompt_path)
  end

  def run
    check_rwl_file_presence
    puts "Starting Ralph Wiggum Loop for: #{@feature_dir}"
    iteration = 0

    loop do
      iteration += 1
      puts "\n━━━ Iteration #{iteration} ━━━"
      iterate
      break if implementation_complete?
    end

    puts "\nAll tasks complete!. Please check the missing_permission.txt file and implementation_plan.md to check the actual state"
  end

  private

  # Spawn a new headless Claude instance with the prompt
  def iterate
    prompt = File.read(@prompt_path)
    system("echo #{Shellwords.escape(prompt)} | claude -p --model #{@model} --verbose")
  end

  # Validate that all required files exist in the feature folder
  def check_rwl_file_presence
    required_files = %w[prompt.md specification.md implementation_plan.md]

    missing_files = required_files.reject do |file|
      File.exist?(File.join(@feature_dir, file))
    end

    return if missing_files.empty?

    abort "Error: Missing required files in #{@feature_dir}: #{missing_files.join(', ')}"
  end

  # The implementation is complete once the TODO block is empty
  # (no unchecked tasks remaining)
  def implementation_complete?
    implementation_plan_path = File.join(@feature_dir, 'implementation_plan.md')
    content = File.read(implementation_plan_path)

    # Extract content between ## TODO and the next ## heading (or end of file)
    todo_block = content[/## TODO\s*\n(.*?)(?=\n## |\z)/m, 1]

    return true if todo_block.nil?

    # Check if any unchecked tasks remain (lines starting with - [ ])
    unchecked_tasks = todo_block.lines.select { |line| line.strip.start_with?('- [ ]') }
    unchecked_tasks.empty?
  end
end

# Main execution
if ARGV.empty?
  puts "Usage: ruby ralph_wiggum.rb <path-to-prompt.md>"
  puts ""
  puts "Example: ruby ralph_wiggum/ralph_wiggum.rb ralph_wiggum/features/my-feature/prompt.md"
  puts ""
  puts "To create a new feature folder, use:"
  puts "  ruby ralph_wiggum/ralph_wiggum_setup.rb <feature-name>"
  exit 1
end

prompt_path = ARGV[0]

unless File.exist?(prompt_path)
  abort "Error: Prompt file not found: #{prompt_path}"
end

RalphWiggumLoop.new(prompt_path).run
