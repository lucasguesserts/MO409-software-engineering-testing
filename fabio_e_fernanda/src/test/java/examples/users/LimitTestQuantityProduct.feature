Feature: Inventory Management - Create Product

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  Scenario Outline: <test_id>
    # Auth
    Given path '/api/v1/private/login'
    And param store = 'DEFAULT'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Create Products
    Given path '/api/v2/private/product/definition'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
          "identifier": "lucas product",
          "visible": true,
          "dateAvailable": "2022-07-06",
          "manufacturer": "DEFAULT",
          "type": "",
          "display": true,
          "canBePurchased": true,
          "timeBound": false,
          "price": 666,
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
                  "name": "lucas product",
                  "highlights": "",
                  "friendlyUrl": "lucas_product",
                  "description": "",
                  "title": "lucas product",
                  "keyWords": "",
                  "metaDescription": ""
              }
          ]
      }
      """
    When method POST
    Then status <response_status>
    And print response
    And match response.id == '#present'
    And def productId = response.id
    And print productId
    # Remove Product
    Given path '/api/v1/private/product/' + productId
    And header Authorization = 'Bearer ' + token
    When method DELETE

    Examples:
      | test_id | quantity     | response_status  |
      | below   | 2147483646   | 201              |
      | at      | 2147483647   | 201              |
      | zero    | 0            | 201              |

  Scenario Outline: <test_id>
    # Auth
    Given path '/api/v1/private/login'
    And param store = 'DEFAULT'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Create Products
    Given path '/api/v2/private/product/definition'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
          "identifier": "lucas product",
          "visible": true,
          "dateAvailable": "2022-07-06",
          "manufacturer": "DEFAULT",
          "type": "",
          "display": true,
          "canBePurchased": true,
          "timeBound": false,
          "price": 666,
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
                  "name": "lucas product",
                  "highlights": "",
                  "friendlyUrl": "lucas_product",
                  "description": "",
                  "title": "lucas product",
                  "keyWords": "",
                  "metaDescription": ""
              }
          ]
      }
      """
    When method POST
    Then status <response_status>
    And print response

    Examples:
      | test_id | quantity     | response_status  |
      | above   | 2147483648   | 500              |
      | negat   | -1           | 500              |  
      | null    |              | 400              |
      | empty   |''            | 400              |
      | other1  | a            | 500              |
      | other2  | &            | 500              |
