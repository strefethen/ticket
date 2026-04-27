Feature: Ticket Lint
  As a user
  I want lint to work in the default shell environment
  So that plan-ready tickets can be validated consistently

  Background:
    Given a clean tickets directory

  Scenario: Lint passes under system bash
    Given a lint-ready ticket exists with ID "lint-0001" and title "Lint-ready ticket"
    When I run ticket-lint under system bash for ticket "lint-0001"
    Then the command should succeed
    And the output should contain "lint-0001  PASS"

  Scenario: writes-tests warns when source path lacks paired test reference
    Given a lint-ready ticket exists with ID "lint-wt-0001", writes "src/feature.ts" and testing "- Manual smoke."
    When I run "ticket lint lint-wt-0001"
    Then the command should succeed
    And the output should contain "writes-tests"
    And the output should contain "lack paired test reference"

  Scenario: writes-tests passes when test file is referenced in Testing Obligations
    Given a lint-ready ticket exists with ID "lint-wt-0002", writes "src/feature.ts" and testing "- Run vitest src/feature.test.ts"
    When I run "ticket lint lint-wt-0002"
    Then the command should succeed
    And the output should contain "writes-tests"
    And the output should contain "have paired test references"

  Scenario: writes-tests is silent when no source paths have language-derived candidates
    Given a lint-ready ticket exists with ID "lint-wt-0003", writes "README.md, package.json" and testing "- Manual smoke."
    When I run "ticket lint lint-wt-0003"
    Then the command should succeed
    And the output should not contain "writes-tests"
