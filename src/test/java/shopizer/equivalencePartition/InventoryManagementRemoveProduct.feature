Feature: Inventory Management - Remove Product

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  Scenario: T33
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Remove Product
    Given path '/api/v1/private/product/null'
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'

  Scenario: T34
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Remove Product
    Given path '/api/v1/private/product/-1'
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 500
    And print response
    And match response.status == '#present'
    And match response.status == 500
    And match response.error == '#present'
    And match response.error == 'Internal Server Error'

  Scenario: T35
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
        "identifier":"t35",
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
            "name":"T35",
            "highlights":"",
            "friendlyUrl":"t_35",
            "description":"",
            "title":"getMerchantName(){return localStorage.getItem(\"merchant\")} | 'T35'",
            "keyWords":"","metaDescription":""
          }]}
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
    