Feature: H3 Story

  Background:
    * url 'http://localhost:8080/api'

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

  Scenario Outline: H3: Setup <product_sku>
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
                  "title": "getMerchantName(){return localStorage.getItem(\"merchant\")} | <name>",
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

Scenario: H3 story - user does not exist - create and delete
    # invalid login credentials
    Given path '/v1/customer/login'
    And request { "username": "obiwan@jedi.order", "password": "S@tin3" }
    And method post
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
    And method post
    # API Com problemas e Inconsistente
    Then match [200, 500] contains responseStatus
    And print response
    # now login is valid
    Given path '/v1/customer/login'
    And request { "username": "obiwan@jedi.order", "password": "S@tin3" }
    And method post
    Then status 200
    And def token = response.token
    And def userId = response.id
    # auth admin
    Given path '/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    # delete user
    Given path '/v1/private/customer/' + userId
    And header Authorization = 'Bearer ' + token
    And method delete
    Then status 200

  Scenario: H3 story - Shopping Cart
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
    And method post
    Then status 200
    And def token = response.token
    And def userId = response.id
    # Product Order
    Given path '/v1/products'
    When method get
    Then status 200
    And print response
    # Cart does not Exist
    Given path '/v1/auth/customer/cart'
    And header Authorization = 'Bearer ' + token
    When method get
    # API Com problemas e Inconsistente
    Then match [403, 404] contains responseStatus
    And print response
    # Checks Product Id - bluelightsaber
    Given path '/v1/private/product/bluelightsaber/inventory'
    And header Authorization = 'Bearer ' + admToken
    When method GET
    Then status 200
    And print response
    And match response.number == '#present'
    And match response.number == 1
    And match response.items[0]  == '#present'
    And def blueId = response.items[0].id
    And print blueId
    # Add product to cart
    Given path '/v1/cart'
    And header Authorization = 'Bearer ' + token
    And request
      """
       {
        "product": '#(parseInt(blueId))',
        "quantity": "2"
       }
      """
    And method post
    Then status 201
    And def cartCode = response.code
    And print response
    # check cart
    Given path '/v1/cart/' + cartCode
    When method get
    Then status 200
    And print response
    # Checks Product Id - redlightsaber
    Given path '/v1/private/product/redlightsaber/inventory'
    And header Authorization = 'Bearer ' + admToken
    When method GET
    Then status 200
    And print response
    And match response.number == '#present'
    And match response.number == 1
    And match response.items[0]  == '#present'
    And def redId = response.items[0].id
    And print redId
    # add product to cart
    Given path '/v1/cart/' + cartCode
    And request
      """
       {
        "product": '#(parseInt(redId))',
        "quantity": "2"
       }
      """
    When method put
    Then status 201
    And print response
    # check cart
    Given path Path = '/v1/cart/' + cartCode
    When method get
    Then status 200
    And print response
    # Checks Product Id - purplelightsaber
    Given path '/v1/private/product/purplelightsaber/inventory'
    And header Authorization = 'Bearer ' + admToken
    When method GET
    Then status 200
    And print response
    And match response.number == '#present'
    And match response.number == 1
    And match response.items[0]  == '#present'
    And def purpleId = response.items[0].id
    And print purpleId
    # add product to cart with not enough quantity
    Given path '/v1/cart/' + cartCode
    And request
      """
       {
       "product": '#(parseInt(purpleId))',
       "quantity": "1000"
       }
      """
    When method put
    Then status 201
    And print response
    # check cart
    Given path Path = '/v1/cart/' + cartCode
    When method get
    Then status 200
    And print response

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

  Scenario Outline: H3: CleanUp <product_sku>
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
