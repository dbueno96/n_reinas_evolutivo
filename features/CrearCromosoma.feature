Feature: Create chromosome
  In order to make a chromosome
  As an user
  I want verify that the genes are different

  Scenario: genes
    Given I have array of genes
    When I verify the elements of the array
    Then I should not find repeated genes

