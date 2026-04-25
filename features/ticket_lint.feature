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
