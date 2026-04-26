Feature: Set and Append Body Sections
  As an agent working through the tk CLI
  I want first-class commands to mutate body sections without an editor
  So that I never need to know the underlying storage format

  Background:
    Given a clean tickets directory
    Given a lint-ready ticket exists with ID "set-0001" and title "Section setter"

  Scenario: set-goal replaces the Goal section with inline text
    When I run "ticket set-goal set-0001 'Replaced goal text'"
    Then the command should succeed
    And the output should contain "Updated set-0001: Goal"

  Scenario: set-goal accepts markdown formatting in the value
    When I run "ticket set-goal set-0001 '**Bold** intent\n- bullet one\n- bullet two'"
    Then the command should succeed

  Scenario: set-goal reads value from stdin via @-
    When I run "ticket set-goal set-0001 @-" with stdin "Goal from stdin"
    Then the command should succeed
    And the output should contain "Updated set-0001: Goal"

  Scenario: set-design replaces the Design section
    When I run "ticket set-design set-0001 'New design notes'"
    Then the command should succeed
    And the output should contain "Updated set-0001: Design"

  Scenario: set-acceptance replaces the Acceptance Criteria section
    When I run "ticket set-acceptance set-0001 '- criterion one'"
    Then the command should succeed
    And the output should contain "Updated set-0001: Acceptance Criteria"

  Scenario: set-testing replaces the Testing Obligations section
    When I run "ticket set-testing set-0001 'Run make test'"
    Then the command should succeed
    And the output should contain "Updated set-0001: Testing Obligations"

  Scenario: append-design adds to the existing Design section
    When I run "ticket append-design set-0001 'Additional design note'"
    Then the command should succeed
    And the output should contain "Appended to set-0001: Design"

  Scenario: append-acceptance adds to the existing Acceptance Criteria
    When I run "ticket append-acceptance set-0001 '- another criterion'"
    Then the command should succeed
    And the output should contain "Appended to set-0001: Acceptance Criteria"

  Scenario: set-goal with no value fails with usage
    When I run "ticket set-goal set-0001"
    Then the command should fail
    And the output should contain "Usage:"

  Scenario: set-goal rejects @file inputs (only @- for stdin)
    When I run "ticket set-goal set-0001 @somefile.md"
    Then the command should fail
    And the output should contain "@file inputs are not supported"

  Scenario: set-goal on a non-existent ticket fails
    When I run "ticket set-goal nope-9999 'value'"
    Then the command should fail
    And the output should contain "not found"

  Scenario: set-design on a ticket without Design creates the section
    Given a ticket exists with ID "no-design-0001" and title "Sparse ticket"
    When I run "ticket set-design no-design-0001 'Design content'"
    Then the command should succeed
