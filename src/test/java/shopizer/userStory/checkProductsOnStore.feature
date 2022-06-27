Feature: Products

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'
    * def token = ''

  Scenario Outline: Verify Wheter Product Data Matches SKU -> <product_sku>
    # Checks Product Id
    Given path '/api/v1/products'
    And param sku = <product_sku>
    When method GET
    Then status 200
    And print response
    And match response.number == '#present'
    And match response.number == 1
    And match response.products == '#present'
    And match response.products == '#[1]'
    And match response.products[0].id == '#present'
    And match response.products[0].id == '#number'
    And match response.products[0].dateAvailable == '#present'
    And match response.products[0].dateAvailable == <date_available>
    And match response.products[0].price == '#present'
    And match response.products[0].price == '#number'
    And match response.products[0].price == <price>
    And match response.products[0].quantity == '#present'
    And match response.products[0].quantity == '#number'
    And match response.products[0].quantity == <quantity>
    And match response.products[0].quantity == '#present'
    And match response.products[0].quantity == '#number'
    And match response.products[0].quantity == <quantity>

    Examples:
      | read('Products.csv') |
