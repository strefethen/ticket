Feature: Ticket Edit
  As a user
  I want to edit tickets in my editor
  So that I can make complex changes easily

  Background:
    Given a clean tickets directory
    And a ticket exists with ID "edit-0001" and title "Editable ticket"

  Scenario: Edit in non-TTY mode shows file path
    When I run "ticket edit edit-0001" in non-TTY mode
    Then the command should succeed
    And the output should contain "Edit ticket file:"
    And the output should contain ".tickets/edit-0001.md"

  Scenario: Edit in non-TTY mode runs explicit editor script
    Given an editor script that appends "Edited by script"
    When I run "ticket edit edit-0001" in non-TTY mode with EDITOR set to that script
    Then the command should succeed
    And ticket "edit-0001" should contain "Edited by script"

  Scenario: Edit in non-TTY mode replaces content from file
    Given a replacement ticket file "replacement.md" with title "Replacement ticket"
    When I run "ticket edit edit-0001 --from-file replacement.md" in non-TTY mode
    Then the command should succeed
    And the output should contain "Updated ticket file:"
    And ticket "edit-0001" should contain "Replacement body"
    And ticket "edit-0001" should not contain "Editable ticket"

  Scenario: Edit from file accepts flag before ticket id
    Given a replacement ticket file "replacement.md" with title "Replacement ticket"
    When I run "ticket edit --from-file replacement.md edit-0001" in non-TTY mode
    Then the command should succeed
    And ticket "edit-0001" should contain "Replacement body"

  Scenario: Edit from missing file fails
    When I run "ticket edit edit-0001 --from-file missing.md" in non-TTY mode
    Then the command should fail
    And the output should contain "Error: from-file 'missing.md' not found"

  Scenario: Edit non-existent ticket
    When I run "ticket edit nonexistent"
    Then the command should fail
    And the output should contain "Error: ticket 'nonexistent' not found"

  Scenario: Edit with partial ID
    When I run "ticket edit 0001" in non-TTY mode
    Then the command should succeed
    And the output should contain "edit-0001.md"
