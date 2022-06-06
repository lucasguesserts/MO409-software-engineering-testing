Feature: POST API demo

Background:
    * url 'https://reqres.in/api'
    * header Accept = 'application/json'
 
Scenario: test POST
    Given path '/users'
    And request {"name": "Ajeet", "job": "Lead"}
    When method POST
    Then status 201
    And print response