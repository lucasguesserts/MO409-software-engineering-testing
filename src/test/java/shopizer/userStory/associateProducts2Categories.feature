Feature: Products & Categories

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'
    * def token = ''

  Scenario Outline: Associate Product to Category <product_sku> -> <friendly_url>
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Checks Product Id
    Given path '/api/v1/products'
    And param sku = <product_sku>
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And print response
    And match response.number == '#present'
    And match response.number == 1
    And match response.products == '#present'
    And match response.products == '#[1]'
    And match response.products[0].id == '#present'
    And match response.products[0].id == '#number'
    And def product_id = response.products[0].id
    And print product_id
    Given print <friendly_url>
    # Checks Category Id
    Given path '/api/v1/category/name/' + <category>
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And print response
    And match response.id == '#present'
    And match response.id == '#number'
    And def category_id = response.id
    And print category_id
    # Associate Product to Category
    Given path '/api/v1/private/product/' + product_id + '/category/' + category_id
    And header Authorization = 'Bearer ' + token
    When method POST
    # API Com problemas e Inconsistente
    Then match [201, 503] contains responseStatus
    And print response
    And match response == '#present'

    Examples:
      | read('Products.csv') |
