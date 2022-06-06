Feature: Put API demo

Background:
    * url 'https://reqres.in/api'
    * header Accept = 'application/json'

Scenario: Put Demo 1
    Given path '/users'
    And param page = 2
    And request { "name": "morpheus", "job": "zion resident" }
    When method PUT
    Then status 200
    And print response
    And match response.name == "morpheus"