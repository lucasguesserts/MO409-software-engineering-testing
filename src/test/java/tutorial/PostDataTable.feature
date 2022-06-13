Feature: PostDataTable

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
      | action_id | card_id | pipe_id  |
      | create    |       1 | "pipe01" |
      | move      |       2 | pipe02   |
      | delete    |       3 | 'pipe03' |

  Scenario Outline: Get data
    Given path '/get/<pipe_id>/<card_id>'
    When method get
    Then status 200
    And print response
    And match response.success == '#present'
    And match response.success == true
    And match response.pipe_id == '#present'
    And match response.pipe_id == '<pipe_id>'
    And match response.card_id == '#present'
    And match response.card_id == <card_id>

    Examples:
      | card_id | pipe_id |
      |       1 | pipe01  |
      |       2 | pipe02  |
      |       3 | pipe03  |
