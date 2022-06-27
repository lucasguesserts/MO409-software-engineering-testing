Feature: Inventory Management - Remove Category

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  Scenario: T30
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Delete Category
    Given path '/api/v1/private/category/null'
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'

  Scenario: T31
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Delete Category
    Given path '/api/v1/private/category/null'
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'
    
  Scenario: T32
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Setup -> Create Category
    Given path '/api/v1/private/category'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "parent":{"id":32,"code":"root"},
        "store":"DEFAULT",
        "visible":true,
        "code":32,
        "sortOrder":0,
        "selectedLanguage":"en",
        "descriptions": [
          {
            "language":"en",
            "name":"CategoryT32",
            "highlights":"",
            "friendlyUrl":"category_t32",
            "description":"",
            "title":"",
            "metaDescription":""
          }]
        }
      """
    When method POST
    Then status 201
    And print response
    And match response.id == '#present'
    And def catId = response.id
    And print catId
    # Delete Category
    Given path '/api/v1/private/category/' + catId
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 200
