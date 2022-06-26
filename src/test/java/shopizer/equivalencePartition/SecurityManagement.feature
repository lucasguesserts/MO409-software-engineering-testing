Feature: Security Management

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  Scenario: T0
    Given path '/api/v1/private/login'
    And request {username: null, password: 'password'}'
    When method POST
    Then status 401
    And print response
    And match response.message == '#present'
    And match response.message == 'Bad credentials'

  Scenario: T1
    Given path '/api/v1/private/login'
    And request {username: '', password: 'password'}'
    When method POST
    Then status 401
    And print response
    And match response.message == '#present'
    And match response.message == 'Bad credentials'

  Scenario: T2
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: null}'
    When method POST
    Then status 401
    And print response
    And match response.message == '#present'
    And match response.message == 'Bad credentials'

  Scenario: T3
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: ''}'
    When method POST
    Then status 401
    And print response
    And match response.message == '#present'
    And match response.message == 'Bad credentials'
