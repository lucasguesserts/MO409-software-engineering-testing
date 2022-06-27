Feature: Search Tools - Find Product by SKU

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  Scenario: T39
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Checks Category Id
    Given path '/api/v1/category/name/null'
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 500
    And print response
    And match response.status == '#present'
    And match response.status == 500
    And match response.error == '#present'
    And match response.error == 'Internal Server Error'

  Scenario: T40
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Checks Category Id
    Given path '/api/v1/category/name/-1'
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 500
    And print response
    And match response.status == '#present'
    And match response.status == 500
    And match response.error == '#present'
    And match response.error == 'Internal Server Error'
    
  Scenario: T41
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
        "parent":{"id":41,"code":"root"},
        "store":"DEFAULT",
        "visible":true,
        "code":41,
        "sortOrder":0,
        "selectedLanguage":"en",
        "descriptions": [
          {
            "language":"en",
            "name":"CategoryT41",
            "highlights":"",
            "friendlyUrl":"category_t41",
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
    # Checks Category Id
    Given path '/api/v1/category/name/category_t41'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And print response
    And match response.id == '#present'
    And match response.id == '#number'
    # Clean Up -> Delete Category
    Given path '/api/v1/private/category/' + catId
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 200
