Feature: Search Tools - Find Product by SKU

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  Scenario: T36
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
    And param sku = null
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And print response
    And match response.number == '#present'
    And match response.number == 0

  Scenario: T37
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
    And param sku = ''
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And print response
    And match response.number == '#present'
    And match response.number == 0

  Scenario: T38
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Setup -> Create Products
    Given path '/api/v2/private/product/definition'
    And param store = 'DEFAULT'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "identifier":"t38",
        "visible":true,
        "dateAvailable":"2022-06-21",
        "manufacturer":"DEFAULT",
        "type":"",
        "display":true,
        "canBePurchased":true,
        "timeBound":false,
        "price":56.78,
        "quantity":5678,
        "sortOrder":"1",
        "productSpecifications":{
          "weight":"",
          "height":"",
          "width":"",
          "length":""
        },
        "descriptions": [
          {
            "language":"en",
            "name":"T38",
            "highlights":"",
            "friendlyUrl":"t_38",
            "description":"",
            "title":"getMerchantName(){return localStorage.getItem(\"merchant\")} | 'T38'",
            "keyWords":"","metaDescription":""
          }]}
      """
    When method POST
    Then status 201
    And print response
    And match response.id == '#present'
    And def productId = response.id
    And print productId
    # Checks Product Id
    Given path '/api/v1/products'
    And param sku = 't38'
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And print response
    And match response.number == '#present'
    And match response.number == 1
    # Clean up -> Remove Product
    Given path '/api/v1/private/product/' + productId
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 200
