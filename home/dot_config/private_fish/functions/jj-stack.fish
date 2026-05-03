# function jj-stack -d "GitHub Stacked PR with JJ"
#     # Configuration - can be overridden with environment variables
#     set -l main_branch (test -n "$JJ_STACK_MAIN_BRANCH"; and echo $JJ_STACK_MAIN_BRANCH; or echo "master")
#     set -l branch_prefix (test -n "$JJ_STACK_BRANCH_PREFIX"; and echo $JJ_STACK_BRANCH_PREFIX; or echo "$USER/pr-")
#     set -l create_draft (test -n "$JJ_STACK_DRAFT"; and echo $JJ_STACK_DRAFT; or echo "true")

#     # Handle subcommands
#     if test (count $argv) -gt 0
#         switch $argv[1]
#             case up update
#                 _jj_stack_update $main_branch
#                 return
#             case help -h --help
#                 _jj_stack_help
#                 return
#             case '*'
#                 echo "Unknown command: $argv[1]"
#                 _jj_stack_help
#                 return 1
#         end
#     end

#     # Main stacked PR creation logic
#     _jj_create_prs_from_revset "$main_branch..@" $main_branch $branch_prefix $create_draft
# end

# function jj-pr -d "GitHub PR for single commit with JJ"
#     # Configuration - can be overridden with environment variables
#     set -l main_branch (test -n "$JJ_STACK_MAIN_BRANCH"; and echo $JJ_STACK_MAIN_BRANCH; or echo "master")
#     set -l branch_prefix (test -n "$JJ_STACK_BRANCH_PREFIX"; and echo $JJ_STACK_BRANCH_PREFIX; or echo "$USER/pr-")
#     set -l create_draft (test -n "$JJ_STACK_DRAFT"; and echo $JJ_STACK_DRAFT; or echo "true")

#     set -l revset "@"
#     if test (count $argv) -gt 0
#         set revset $argv[1]
#     end

#     # Main PR creation logic
#     _jj_create_prs_from_revset "$revset" $main_branch $branch_prefix $create_draft
#     # Clean empty changes
#     _jj_cleanup_empty_commits
# end

# function _jj_create_prs_from_revset -a revset main_branch branch_prefix create_draft
#     # Get stack change IDs
#     set -l change_ids (_jj_get_change_ids "$revset")
#     if test $status -ne 0
#         echo "Error: Failed to get stack change IDs for revset '$revset'"
#         return 1
#     end

#     if test (count $change_ids) -eq 0
#         echo "No changes to stack"
#         return 0
#     end

#     set -l pr_stack
#     set -l descriptions
#     set -l last_branch ""

#     # Process each change in the stack
#     for change_id in $change_ids
#         echo "Processing change: $change_id"

#         # Get description
#         set -l desc (jj log --no-graph -T 'description' -r $change_id 2>&1)
#         if test $status -ne 0
#             echo "Error: Failed to get description for change $change_id"
#             echo "jj log output: $desc"
#             return 1
#         end

#         # Get existing branch/bookmark
#         set -l branch (_jj_get_bookmark $change_id)

#         # Create branch if it doesn't exist
#         if test -z "$branch"
#             set -l next_pr_num (_jj_get_next_pr_number)
#             if test $status -ne 0
#                 echo "Error: Failed to get next PR number"
#                 return 1
#             end

#             set branch "$branch_prefix$next_pr_num"

#             if not jj bookmark create -r $change_id $branch >/dev/null 2>&1
#                 echo "Error: Failed to create bookmark $branch"
#                 return 1
#             end

#             echo "Created bookmark: $branch"
#         end

#         # Push to remote
#         echo "Pushing bookmark $branch (change $change_id)..."

#         # Try different push methods based on jj version
#         set -l push_output
#         if jj git push --bookmark $branch 2>/dev/null
#             set push_output "Success with --bookmark"
#         else if jj git push -B $branch 2>/dev/null
#             set push_output "Success with -B"
#         else if jj git push --all 2>/dev/null
#             set push_output "Success with --all"
#         else
#             # Fallback: try to push the specific revision
#             set push_output (jj git push -r $change_id 2>&1)
#             if test $status -ne 0
#                 echo "Error: Failed to push bookmark $branch to remote"
#                 echo "Push output: $push_output"
#                 return 1
#             end
#         end

#         echo "Pushed bookmark: $branch ($push_output)"

#         # Check if PR exists and its state
#         set -l pr_info (_jj_get_pr_info $branch)
#         set -l pr_num (echo $pr_info | cut -d: -f1)
#         set -l pr_state (echo $pr_info | cut -d: -f2)

#         # Create PR if it doesn't exist, or reopen if closed
#         if test $pr_num -eq -1
#             echo "Creating PR for branch: $branch"

#             set -l base_branch
#             if test -z "$last_branch"
#                 set base_branch $main_branch
#             else
#                 set base_branch $last_branch
#             end

#             set -l gh_args pr create -H $branch -B $base_branch --fill-first
#             if test "$create_draft" = "true"
#                 set gh_args $gh_args --draft
#             end

#             set -l pr_output (gh $gh_args 2>&1)
#             if test $status -ne 0
#                 echo "Error: Failed to create PR - $pr_output"
#                 return 1
#             end

#             echo "Created PR: $pr_output"
#             set pr_num (_jj_get_pr_number $branch)
#         else if test "$pr_state" = "CLOSED"
#             echo "Reopening closed PR #$pr_num for branch: $branch"
#             set -l reopen_output (gh pr reopen $pr_num 2>&1)
#             if test $status -ne 0
#                 echo "Warning: Failed to reopen PR #$pr_num - $reopen_output"
#             else
#                 echo "Reopened PR #$pr_num"
#             end
#         end

#         set pr_stack $pr_stack $pr_num
#         set descriptions $descriptions "$desc"
#         set last_branch $branch
#     end

#     # Update PR descriptions with stack info
#     for i in (seq (count $pr_stack))
#         set -l pr_num $pr_stack[$i]
#         set -l desc $descriptions[$i]

#         set -l pr_info (begin
#             # Show dependencies section only if there's more than one PR
#             if test (count $pr_stack) -gt 1
#                 echo ""
#                 echo ""
#                 echo "---"
#                 echo ""
#                 echo ""
#                 echo "Current dependencies on/for this PR:"

#                 # Show the stack hierarchy only if there's more than one PR
#                 for j in (seq (count $pr_stack))
#                     set -l stack_pr_num $pr_stack[$j]
#                     set -l stack_desc $descriptions[$j]

#                     if test $j -eq $i
#                         # Current PR - show with arrow
#                         echo "* PR: **$stack_desc** #$stack_pr_num 👈"
#                     else
#                         # Other PRs in stack
#                         echo "* PR: $stack_desc #$stack_pr_num"
#                     end
#                 end

#                 echo ""
#                 echo "This comment was auto-generated by jj-stack."
#             end
#         end | string collect)

#         set -l update_output (gh pr edit $pr_num -b "$desc$pr_info" 2>&1)
#         if test $status -eq 0
#             echo "Updated PR #$pr_num: $update_output"
#         else
#             echo "Warning: Failed to update PR #$pr_num - $update_output"
#         end
#     end
# end

# function _jj_stack_update -a main_branch
#     echo "Fetching from git..."
#     if not jj git fetch >/dev/null 2>&1
#         echo "Error: Failed to fetch from git"
#         return 1
#     end

#     echo "Rebasing to $main_branch..."
#     set -l rebase_output (jj rebase -d $main_branch 2>&1)
#     if test $status -ne 0
#         echo "Error: Failed to rebase to $main_branch - $rebase_output"
#         return 1
#     end

#     # Find empty commits - FIXED: Handle empty results properly
#     set -l empty_change_ids (_jj_get_change_ids "$main_branch..@- & empty()")
#     # Note: _jj_get_change_ids returns empty list if no matches, which is fine

#     # Show current log
#     echo "Current stack:"
#     jj log -r "$main_branch-..@"

#     # Check if there are any empty commits to process
#     if test (count $empty_change_ids) -eq 0
#         echo "No empty commits found in stack."
#         return 0
#     end

#     echo "Found "(count $empty_change_ids)" empty commit(s) to review."

#     # Abandon empty commits with confirmation
#     for change_id in $empty_change_ids
#         set -l short_id (string sub -l 8 $change_id)
#         echo -n "Abandon empty change '$short_id'? (y/n) "

#         read -l response
#         set response (string lower (string trim $response))

#         if test "$response" = "y" -o "$response" = "yes"
#             if jj abandon -r $change_id >/dev/null 2>&1
#                 echo "Abandoned $short_id"
#             else
#                 echo "Warning: Failed to abandon $short_id"
#             end
#         else
#             echo "Skipped $short_id"
#         end
#     end
# end


# function _jj_cleanup_empty_commits
#     echo "Cleaning up empty commits..."
    
#     # Get all empty commits that are descendants of master but not master itself
#     set -l empty_commits (_jj_get_change_ids "master..@ & empty()")
    
#     if test (count $empty_commits) -eq 0
#         echo "No empty commits to clean up."
#         return 0
#     end
    
#     echo "Found "(count $empty_commits)" empty commit(s) to clean up."
    
#     # Abandon empty commits automatically (since they're just artifacts)
#     for change_id in $empty_commits
#         set -l short_id (string sub -l 8 $change_id)
#         if jj abandon -r $change_id >/dev/null 2>&1
#             echo "Cleaned up empty commit $short_id"
#         else
#             echo "Warning: Failed to clean up $short_id"
#         end
#     end
# end

# function _jj_get_change_ids -a revset
#     jj log --no-graph --reversed -r "$revset" -T 'change_id ++ "\n"' 2>/dev/null | string trim | string match -v ''
# end

# function _jj_get_bookmark -a change_id
#     set -l output (jj bookmark list -r $change_id 2>/dev/null)
#     if test $status -ne 0 -o -z "$output"
#         return 0
#     end

#     echo $output | string split ':' | head -1 | string trim
# end

# function _jj_get_next_pr_number
#     set -l output (gh pr list -L 1 --state all --json number 2>/dev/null | jq -r '.[0].number // "null"' 2>/dev/null)
#     if test $status -ne 0
#         echo "1"
#         return 0
#     end

#     if test "$output" = "null"
#         echo "1"
#     else
#         math $output + 1
#     end
# end

# function _jj_get_pr_info -a branch
#     set -l output (gh pr list -L 1 --state all --json number,state --head $branch 2>/dev/null | jq -r '.[0] | "\(.number // -1):\(.state // "NONE")"' 2>/dev/null)
#     if test $status -ne 0
#         echo "-1:NONE"
#     else
#         echo $output
#     end
# end

# function _jj_get_pr_number -a branch
#     set -l output (gh pr list -L 1 --state all --json number --head $branch 2>/dev/null | jq -r '.[0].number // "null"' 2>/dev/null)
#     if test $status -ne 0 -o "$output" = "null"
#         echo "-1"
#     else
#         echo $output
#     end
# end

# function _jj_stack_help
#     echo "jj-stack - GitHub Stacked PR with JJ"
#     echo ""
#     echo "Usage:"
#     echo "  jj-stack           Create/update stacked PRs"
#     echo "  jj-stack up        Fetch, rebase, and clean up empty commits"
#     echo "  jj-stack help      Show this help"
#     echo ""
#     echo "Configuration (environment variables):"
#     echo "  JJ_STACK_MAIN_BRANCH    Main branch (default: master)"
#     echo "  JJ_STACK_BRANCH_PREFIX  Branch prefix (default: \$USER/pr-)"
#     echo "  JJ_STACK_DRAFT          Create draft PRs (default: true)"
#     echo ""
#     echo "Examples:"
#     echo "  jj-stack                           # Create stacked PRs"
#     echo "  JJ_STACK_DRAFT=false jj-stack      # Create non-draft PRs"
#     echo "  jj-stack up                        # Update and rebase"
# end
