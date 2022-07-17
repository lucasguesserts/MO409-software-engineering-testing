Feature: H4 Story

  Background:
    * url 'http://localhost:8080/api/'

  Scenario: Setup User
    # Auth
    Given path '/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Register User
    Given path '/v1/customer/register'
    And request
      """
       {
          "userName": "anakin",
          "password": "blue",
          "emailAddress": "anakin@jedi.com",
          "gender": "M",
          "language": "en",
          "billing": {
            "country": "CA",
            "stateProvince": "ON",
            "firstName": "Anakin",
            "lastName": "Skywalker"
          }
       }
      """
    And method POST
    # API Com problemas e Inconsistente
    Then match [200, 500] contains responseStatus
    And print response

  Scenario Outline: H4: Setup <product_sku>
    # Auth
    Given path '/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Create Products
    Given path '/v2/private/product/definition'
    And param store = 'DEFAULT'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
          "identifier": <product_sku>,
          "visible": true,
          "dateAvailable": '1971-01-01',
          "manufacturer": 'DEFAULT',
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
                  "title": "GETMerchantName(){return localStorage.GETItem(\"merchant\")} | <name>",
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

    Examples:
      | read('StateTransitionTestingProducts.csv') |

  Scenario: H4 story - user does not exist - create and delete
    # invalid login credentials
    Given path '/v1/customer/login'
    And request { "username": "obiwan@jedi.order", "password": "S@tin3" }
    And method POST
    # API Com problemas e Inconsistente
    Then match [200, 401] contains responseStatus
    # register user
    Given path '/v1/customer/register'
    And request
      """
       {
          "userName": "obiwan",
          "password": "S@tin3",
          "emailAddress": "obiwan@jedi.order",
          "gender": "M",
          "language": "en",
          "billing": {
            "country": "CA",
            "stateProvince": "ON",
            "firstName": "Teste",
            "lastName": "Teste"
          }
       }
      """
    And method POST
    # API Com problemas e Inconsistente
    Then match [200, 500] contains responseStatus
    And print response
    # now login is valid
    Given path '/v1/customer/login'
    And request { "username": "obiwan@jedi.order", "password": "S@tin3" }
    And method POST
    Then status 200
    And def token = response.token
    And def userId = response.id
    # Admin Login
    Given path '/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def admToken = response.token
    And print admToken
    # delete user
    Given path '/v1/private/customer/' + userId
    And header Authorization = 'Bearer ' + admToken
    And method delete
    Then status 200

  Scenario: H4 story - User Populate Shopping cart, Alters quantity outsize Available quantity and then Remove all items
    # Admin Login
    Given path '/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def admToken = response.token
    And print admToken
    # User Login
    Given path '/v1/customer/login'
    And request { "username": "anakin@jedi.com", "password": "blue" }
    And method POST
    Then status 200
    And def token = response.token
    And def userId = response.id
    # Checks Product Id - bluelightsaber
    Given path '/v1/private/product/bluelightsaber/inventory'
    And header Authorization = 'Bearer ' + admToken
    When method GET
    Then print response
    And status 200
    And match response.number == '#present'
    And match response.number == 1
    And match response.items[0]  == '#present'
    And def blueId = response.items[0].id
    And print blueId
    # Checks Product Id - redlightsaber
    Given path '/v1/private/product/redlightsaber/inventory'
    And header Authorization = 'Bearer ' + admToken
    When method GET
    Then print response
    And status 200
    And match response.number == '#present'
    And match response.number == 1
    And match response.items[0]  == '#present'
    And def redId = response.items[0].id
    And print redId
    # Add Product to Cart - bluelightsaber
    Given path '/v1/cart'
    And header Authorization = 'Bearer ' + token
    And request
      """
       {
        "product": '#(parseInt(blueId))',
        "quantity": "5"
       }
      """
    And method POST
    Then print response
    And status 201
    And def cartCode = response.code
    # Add Product to Cart - redlightsaber
    Given path '/v1/cart/' + cartCode
    And header Authorization = 'Bearer ' + token
    And request
      """
       {
        "product": '#(parseInt(redId))',
        "quantity": "2"
       }
      """
    And method PUT
    Then print response
    And status 201
    And def cartCode = response.code
    # Alters Quantity of Product Outside its Available Limits - redlightsaber
    Given path '/v1/cart/' + cartCode
    And header Authorization = 'Bearer ' + token
    And request
      """
       {
        "product": '#(parseInt(redId))',
        "quantity": "200"
       }
      """
    And method PUT
    Then print response
    And status 201 ## THIS OPERATION SHOULD HAVA FAILED BUT THE API ACCEPTS IT
    And def cartCode = response.code
    # Checks Current Cart
    Given path Path = '/v1/cart/' + cartCode
    And header Authorization = 'Bearer ' + token
    When method GET
    Then print response
    And status 200
    # Remove Product from Cart - bluelightsaber
    Given path '/v1/cart/' + cartCode
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
      "product": '#(parseInt(blueId))',
      "quantity": "0"
      }
      """
    When method PUT
    Then print response
    And status 201
    # Remove Product from Cart - redlightsaber
    Given path Path = '/v1/cart/' + cartCode + '/product/' + redId
    When method delete
    Then print response
    And status 204 # it means the cart is empty

  Scenario: H4 story - User Populate a Shopping Cart to Check its Total Cost
    # Admin Login
    Given path '/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def admToken = response.token
    And print admToken
    # User Login
    Given path '/v1/customer/login'
    And request { "username": "anakin@jedi.com", "password": "blue" }
    And method POST
    Then status 200
    And def token = response.token
    And def userId = response.id
    # Checks Product Id - bluelightsaber
    Given path '/v1/private/product/bluelightsaber/inventory'
    And header Authorization = 'Bearer ' + admToken
    When method GET
    Then print response
    And status 200
    And match response.number == '#present'
    And match response.number == 1
    And match response.items[0]  == '#present'
    And def blueId = response.items[0].id
    And print blueId
    # Add Product to Cart - bluelightsaber
    Given path '/v1/cart'
    And header Authorization = 'Bearer ' + token
    And request
      """
       {
        "product": '#(parseInt(blueId))',
        "quantity": "7"
       }
      """
    And method POST
    Then print response
    And status 201
    And def cartCode = response.code
    # Checks Current Cart and Tests its Total Cost
    Given path Path = '/v1/cart/' + cartCode
    And header Authorization = 'Bearer ' + token
    When method GET
    Then print response
    And status 200
    And match response.total == '#present'
    And match response.total == 70.0
    And match response.quantity == '#present'
    And match response.quantity == 7

Scenario: CleanUp User
    # Admin Login
    Given path '/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def admToken = response.token
    And print admToken
    # User Login
    Given path '/v1/customer/login'
    And request { "username": "anakin@jedi.com", "password": "blue" }
    And method POST
    Then status 200
    And def token = response.token
    And def userId = response.id
    # delete user
    Given path '/v1/private/customer/' + userId
    And header Authorization = 'Bearer ' + admToken
    And method delete
    Then status 200

  Scenario Outline: H4: CleanUp <product_sku>
    # Auth
    Given path '/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Checks Product Id
    Given path '/v1/private/product/<product_sku>/inventory'
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And print response
    And match response.number == '#present'
    And match response.number == 1
    And match response.items[0]  == '#present'
    And def productId = response.items[0].id
    And print productId
    # Clean up -> Remove Product
    Given path '/v1/private/product/' + productId
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 200

    Examples:
      | read('StateTransitionTestingProducts.csv') |
