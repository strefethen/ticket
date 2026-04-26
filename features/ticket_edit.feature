Feature: Ticket Edit
  As a user
  I want to edit tickets in my editor
  So that I can make complex changes easily

  Background:
    Given a clean tickets directory
    And a ticket exists with ID "edit-0001" and title "Editable ticket"

  Scenario: Edit in non-TTY mode requires structured input
    When I run "ticket edit edit-0001" in non-TTY mode
    Then the command should fail
    And the output should contain "Error: non-interactive edit requires body section flags"

  Scenario: Edit in non-TTY mode rejects EDITOR as an automation path
    When I run "ticket edit edit-0001" in non-TTY mode with EDITOR set to "/bin/false"
    Then the command should fail
    And the output should contain "Error: non-interactive edit requires body section flags"

  Scenario: Edit rejects whole-ticket replacement from file
    When I run "ticket edit edit-0001 --from-file replacement.md" in non-TTY mode
    Then the command should fail
    And the output should contain "Error: --from-file has been removed"

  Scenario: Edit updates body sections from inline values
    When I run "ticket edit edit-0001 --design 'Use direct flags' --acceptance '- The ticket is updated' --testing 'Run make test'" in non-TTY mode
    Then the command should succeed
    And the output should be "Updated edit-0001"
    And the output should not contain ".tickets"
    And ticket "edit-0001" should contain "# Editable ticket"
    And ticket "edit-0001" should contain "## Design"
    And ticket "edit-0001" should contain "Use direct flags"
    And ticket "edit-0001" should contain "## Acceptance Criteria"
    And ticket "edit-0001" should contain "- The ticket is updated"
    And ticket "edit-0001" should contain "## Testing Obligations"
    And ticket "edit-0001" should contain "Run make test"

  Scenario: Edit replaces existing body sections without removing unrelated sections
    Given a lint-ready ticket exists with ID "edit-0001" and title "Editable ticket"
    And ticket "edit-0001" has a notes section
    When I run "ticket edit edit-0001 --design 'Use replacement design'" in non-TTY mode
    Then the command should succeed
    And ticket "edit-0001" should contain "Use replacement design"
    And ticket "edit-0001" should not contain "Use the existing ticket body schema"
    And ticket "edit-0001" should contain "## Acceptance Criteria"
    And ticket "edit-0001" should contain "## Notes"

  Scenario: Edit rejects body section reads from files
    When I run "ticket edit edit-0001 --design @design.md" in non-TTY mode
    Then the command should fail
    And the output should contain "Error: --design only supports inline text or @- stdin"

  Scenario: Edit reads one body section from stdin
    When I run "ticket edit edit-0001 --testing @-" with stdin "Testing from stdin"
    Then the command should succeed
    And ticket "edit-0001" should contain "## Testing Obligations"
    And ticket "edit-0001" should contain "Testing from stdin"

  Scenario: Edit accepts goal and testing obligation aliases
    When I run "ticket edit edit-0001 --goal 'Updated goal' --testing-obligations 'Verify the alias path'" in non-TTY mode
    Then the command should succeed
    And ticket "edit-0001" should contain "## Goal"
    And ticket "edit-0001" should contain "Updated goal"
    And ticket "edit-0001" should contain "## Testing Obligations"
    And ticket "edit-0001" should contain "Verify the alias path"

  Scenario: Edit rejects multiple body sections reading from stdin
    When I run "ticket edit edit-0001 --design @- --acceptance @-" with stdin "One stdin body"
    Then the command should fail
    And the output should contain "Error: @- can only be used by one body section flag"

  Scenario: Edit non-existent ticket
    When I run "ticket edit nonexistent"
    Then the command should fail
    And the output should contain "Error: ticket 'nonexistent' not found"

  Scenario: Edit with partial ID
    When I run "ticket edit 0001 --design 'Partial ID update'" in non-TTY mode
    Then the command should succeed
    And the output should be "Updated edit-0001"
    And ticket "edit-0001" should contain "Partial ID update"
