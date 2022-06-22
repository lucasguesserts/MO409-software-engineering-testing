Feature: Simple Inventory Testing

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  Scenario Outline: Create Categories
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Checks Category Id
    Given path '/api/v1/category/name/<friendly_url>'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And print response
    And match response.id == '#present'
    And match response.id == '#number'
    And def category_id = response.id
    And print category_id
    # Delete Category
    Given path '/api/v1/private/category/' + category_id
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 200

    Examples:
      | read('Categories.csv') |
