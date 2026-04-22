Feature: Ticket Status Management
  As a user
  I want to change ticket statuses
  So that I can track progress on tasks

  Background:
    Given a clean tickets directory
    And a ticket exists with ID "test-0001" and title "Test ticket"

  Scenario: Set status to in_progress
    When I run "ticket status test-0001 in_progress"
    Then the command should succeed
    And the output should be "Updated test-0001 -> in_progress"
    And ticket "test-0001" should have field "status" with value "in_progress"

  Scenario: Set status to closed
    When I run "ticket status test-0001 closed"
    Then the command should succeed
    And the output should be "Updated test-0001 -> closed"
    And ticket "test-0001" should have field "status" with value "closed"

  Scenario: Set status to open
    Given ticket "test-0001" has status "closed"
    When I run "ticket status test-0001 open"
    Then the command should succeed
    And the output should be "Updated test-0001 -> open"
    And ticket "test-0001" should have field "status" with value "open"

  Scenario: Start command sets status to in_progress
    When I run "ticket start test-0001"
    Then the command should succeed
    And the output should be "Updated test-0001 -> in_progress"
    And ticket "test-0001" should have field "status" with value "in_progress"

  Scenario: Close command sets status to closed
    When I run "ticket close test-0001"
    Then the command should succeed
    And the output should be "Updated test-0001 -> closed"
    And ticket "test-0001" should have field "status" with value "closed"

  Scenario: Reopen command sets status to open
    Given ticket "test-0001" has status "closed"
    When I run "ticket reopen test-0001"
    Then the command should succeed
    And the output should be "Updated test-0001 -> open"
    And ticket "test-0001" should have field "status" with value "open"

  Scenario: Invalid status value
    When I run "ticket status test-0001 invalid"
    Then the command should fail
    And the output should contain "Error: invalid status 'invalid'"
    And the output should contain "open in_progress closed deferred"

  Scenario: Status of non-existent ticket
    When I run "ticket status nonexistent open"
    Then the command should fail
    And the output should contain "Error: ticket 'nonexistent' not found"

  Scenario: Status command with partial ID
    When I run "ticket status 0001 in_progress"
    Then the command should succeed
    And ticket "test-0001" should have field "status" with value "in_progress"

  Scenario: Set status to deferred
    When I run "ticket status test-0001 deferred"
    Then the command should succeed
    And the output should be "Updated test-0001 -> deferred"
    And ticket "test-0001" should have field "status" with value "deferred"

  Scenario: Defer command sets status to deferred
    When I run "ticket defer test-0001"
    Then the command should succeed
    And the output should be "Updated test-0001 -> deferred"
    And ticket "test-0001" should have field "status" with value "deferred"

  Scenario: Defer command with no id
    When I run "ticket defer"
    Then the command should fail
    And the output should contain "Usage:"
    And the output should contain "defer <id>"

  Scenario: Reopen command works on deferred ticket
    Given ticket "test-0001" has status "deferred"
    When I run "ticket reopen test-0001"
    Then the command should succeed
    And the output should be "Updated test-0001 -> open"
    And ticket "test-0001" should have field "status" with value "open"

  Scenario: Close with -r reason appends a labelled note
    When I run "ticket close test-0001 -r 'fixed in PR 42'"
    Then the command should succeed
    And the output should be "Updated test-0001 -> closed"
    And ticket "test-0001" should have field "status" with value "closed"
    And ticket "test-0001" should contain "## Notes"
    And ticket "test-0001" should contain "Closed: fixed in PR 42"

  Scenario: Defer with -r reason appends a labelled note
    When I run "ticket defer test-0001 -r 'waiting on API redesign'"
    Then the command should succeed
    And ticket "test-0001" should contain "Deferred: waiting on API redesign"

  Scenario: Reopen with -r reason appends a labelled note
    Given ticket "test-0001" has status "closed"
    When I run "ticket reopen test-0001 -r 'regression found'"
    Then the command should succeed
    And ticket "test-0001" should contain "Reopened: regression found"

  Scenario: Start with -r reason appends a labelled note
    When I run "ticket start test-0001 -r 'picking this up for sprint 7'"
    Then the command should succeed
    And ticket "test-0001" should contain "Started: picking this up for sprint 7"

  Scenario: Generic status command supports -r reason
    When I run "ticket status test-0001 closed -r 'done'"
    Then the command should succeed
    And ticket "test-0001" should contain "Closed: done"

  Scenario: Close without -r does not append a note
    When I run "ticket close test-0001"
    Then the command should succeed
    And ticket "test-0001" should not contain "## Notes"

  Scenario: -r without a reason argument fails
    When I run "ticket close test-0001 -r"
    Then the command should fail
    And the output should contain "requires a reason argument"

  Scenario: Multiple close/reopen cycles preserve reason history
    When I run "ticket close test-0001 -r 'first close'"
    And I run "ticket reopen test-0001 -r 'needed again'"
    And I run "ticket close test-0001 -r 'second close'"
    Then ticket "test-0001" should contain "Closed: first close"
    And ticket "test-0001" should contain "Reopened: needed again"
    And ticket "test-0001" should contain "Closed: second close"
