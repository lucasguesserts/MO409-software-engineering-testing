Feature: Products

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  Scenario Outline: Remove Products SKU -> <product_sku>
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
    # Remove Product
    Given path '/api/v1/private/product/' + product_id
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 200

    Examples:
      | read('Products.csv') |
