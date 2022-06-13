Feature: PostDataTableCSV

  Background:
    * url 'http://api.1dt.com.br/services/api/v1'

  Scenario Outline: create a user from given details.

    Given path '/post'
    And request {data: {action:<action_id>, card:{id:<card_id>, pipe_id:<pipe_id>}}}
    When method post
    Then status 200
    Then print response

    And match response.result == '#present'
    And match response.result == 'ok'

    Examples:
      | read('PostDataTableCSV.csv') |
