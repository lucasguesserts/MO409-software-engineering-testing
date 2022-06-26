Feature: Inventory Management - Associate Product to Category

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'
    * def token = ''

  Scenario: T26
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Associate Product to Category
    Given path '/api/v1/private/product/null/category/1'
    And header Authorization = 'Bearer ' + token
    When method POST
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'

  Scenario: T27
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Associate Product to Category
    Given path '/api/v1/private/product/-1/category/1'
    And header Authorization = 'Bearer ' + token
    When method POST
    Then status 503
    And print response
    And match response.status == '#present'
    And match response.status == 503
    And match response.error == '#present'
    And match response.path == '#present'

  Scenario: T28
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Associate Product to Category
    Given path '/api/v1/private/product/1/category/null'
    And header Authorization = 'Bearer ' + token
    When method POST
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'

  Scenario: T29
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Associate Product to Category
    Given path '/api/v1/private/product/1/category/-1'
    And header Authorization = 'Bearer ' + token
    When method POST
    Then status 503
    And print response
    And match response.status == '#present'
    And match response.status == 503
    And match response.error == '#present'
    And match response.path == '#present'
    