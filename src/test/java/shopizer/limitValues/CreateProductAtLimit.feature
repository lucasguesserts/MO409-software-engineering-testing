Feature: Inventory Management - Create Product

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  Scenario Outline: <test_id>
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Create Products
    Given path '/api/v2/private/product/definition'
    And param store = 'DEFAULT'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
          "identifier": <product_sku>,
          "visible": <visible>,
          "dateAvailable": <date_available>,
          "manufacturer": <manufacturer>,
          "type": "",
          "display": true,
          "canBePurchased": true,
          "timeBound": false,
          "price": <price>,
          "quantity": <quantity>,
          "sortOrder": "1",
          "productSpecifications": {
              "weight": "",
              "height": "",
              "width": "",
              "length": ""
          },
          "descriptions": [
              {
                  "language": "en",
                  "name": <name>,
                  "highlights": "",
                  "friendlyUrl": <friendly_url>,
                  "description": "",
                  "title": "<name>",
                  "keyWords": "",
                  "metaDescription": ""
              }
          ]
      }
      """
    When method POST
    Then status 201
    And print response
    And match response.id == '#present'
    And def productId = response.id
    And print productId
    # Remove Product
    Given path '/api/v1/private/product/' + productId
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 200

    Examples:
      | read('CreateProductAtLimit.csv') |
