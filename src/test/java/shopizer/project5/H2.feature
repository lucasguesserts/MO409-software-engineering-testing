Feature: H1 Story

  Background:
    * url 'http://localhost:8080/api'

  Scenario: Setup
    # Auth
    Given path '/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Setup -> Create Category
    Given path '/v1/private/category'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        "parent":{"id":99,"code":"root"},
        "store":"DEFAULT",
        "visible":true,
        "code":99,
        "sortOrder":0,
        "selectedLanguage":"en",
        "descriptions": [
          {
            "language":"en",
            "name":"Category99",
            "highlights":"",
            "friendlyUrl":"category_99",
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
    And print  response.id

  Scenario: H2 story - user does not exist - create and delete
    # invalid login credentials
    Given path '/v1/customer/login'
    And request { "username": anakin@jedi.com, "password": blue }
    And method post
    Then status 401
    # register user
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
            "firstName": "Teste",
            "lastName": "Teste"
        }
       }
      """
    And method post
    Then status 200
    And print response
    # now login is valid
    Given path '/v1/customer/login'
    And request { "username": "anakin@jedi.com", "password": "blue" }
    And method post
    Then status 200
    And def token = response.token
    And def userId = response.id

  Scenario: H2 story - list categories
    # login succeeds
    Given path '/v1/customer/login'
    And request { "username": "anakin@jedi.com", "password": "blue" }
    And method post
    Then status 200
    And def token = response.token
    And def userId = response.id
    # list all categories
    Given path '/v1/category'
    And method get
    Then status 200
    And print response
    # Checks Category Id
    Given path '/v1/category/name/category_99'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And print response
    And match response.id == '#present'
    And match response.id == '#number'
    And def cat99Id = response.id
    # show category 99 info
    Given path '/v1/category/' + cat99Id
    And method get
    Then status 200
    And print response

  Scenario: H2 story - category 1 product variants
    # login succeeds
    Given path '/v1/customer/login'
    And request { "username": "anakin@jedi.com", "password": "blue" }
    And method post
    Then status 200
    And def token = response.token
    And def userId = response.id
    # Checks Category Id
    Given path '/v1/category/name/category_99'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And print response
    And match response.id == '#present'
    And match response.id == '#number'
    And def cat99Id = response.id
    # get product variants in category
    Given path '/v2/category/' + cat99Id +'/variants'
    And method get
    Then status 200
    And print response

  Scenario: H2 story - Absent Category Product Variants
    # login succeeds
    Given path '/v1/customer/login'
    And request { "username": "anakin@jedi.com", "password": "blue" }
    And method post
    Then status 200
    And def token = response.token
    And def userId = response.id
    # get product variants in category
    Given path '/v2/category/123456/variants'
    And method get
    Then status 404
    And print response

  Scenario: CleanUp:
    # login succeeds
    Given path '/v1/customer/login'
    And request { "username": "anakin@jedi.com", "password": "blue" }
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
    # Checks Category Id
    Given path '/v1/category/name/category_99'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And print response
    And match response.id == '#present'
    And match response.id == '#number'
    And def cat99Id = response.id
    # Clean Up -> Delete Category
    Given path '/v1/private/category/' + cat99Id
    And header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 200
