Feature: GET API demo

Background:
    * url 'https://reqres.in/api'
    * header Accept = 'application/json'
 
Scenario: testing the get call for User Details
    Given path '/users'
    And param page = 2
    When method GET
    Then status 200
    And match response.page == 2
    And print response