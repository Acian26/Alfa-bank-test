Feature: Checking a website

  Scenario: Downloading the page
    Given I am not on the page
    When I am on the page
    Then I check if the elements are on the page

  Scenario: Populating the text fields
    Given Im on the page
    When I enter something into the text field
    Then The text field is populated

  Scenario: Check Vznos and Summ
    Given I m on the page
    When I enter inputs into the text field
    Then Check text on the page

  Scenario: Clicking Result button
    Given I am on the main page
    When I click the Result button
    Then Monthly payment calculates