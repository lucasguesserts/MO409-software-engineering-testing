Feature: Inventory Management - Create Category

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'


  #Scenario: T4 -> Esse Funciona
    # Auth
    #Given path '/api/v1/private/login'
    #And request {username: 'admin@shopizer.com', password: 'password'}'
    #When method POST
    #Then status 200
    #And print response
    #And match response.token == '#present'
    #And def token = response.token
    #And print token
    # Create Category
    #Given path '/api/v1/private/category'
    #And header Authorization = 'Bearer ' + token
    #And request
      #"""
      #{
      #"parent": { "id": null, "code": "root" },
      #"store": 'DEFAULT',
      #"visible": true,
      #"code": 1,
      #"sortOrder": 0,
      #"selectedLanguage": "en",
      #"descriptions":
      #[
        #{
          #"language": "en",
          #"name": 'T4',
          #"highlights": "",
          #"friendlyUrl": 'T4',
          #"description": "",
          #"title": "",
          #"metaDescription": "",
        #},
      #],
      #}
      #"""
    #When method POST
    #Then status 201
    #And print response
    #And match response.id == '#present'

  Scenario: T5
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Create Category
    Given path '/api/v1/private/category'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
      "parent": { "id": '', "code": "root" },
      "store": 'DEFAULT',
      "visible": true,
      "code": 1,
      "sortOrder": 0,
      "selectedLanguage": "en",
      "descriptions":
      [
        {
          "language": "en",
          "name": 'T4',
          "highlights": "",
          "friendlyUrl": 'T4',
          "description": "",
          "title": "",
          "metaDescription": "",
        },
      ],
      }
      """
    When method POST
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'
    
  Scenario: T6
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Create Category
    Given path '/api/v1/private/category'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
      "parent": { "id": '99', "code": "root" },
      "store": 'DEFAULT',
      "visible": true,
      "code": '99',
      "sortOrder": 0,
      "selectedLanguage": "en",
      "descriptions":
      [
        {
          "language": "en",
          "name": null,
          "highlights": "",
          "friendlyUrl": 'T6',
          "description": "",
          "title": "",
          "metaDescription": "",
        },
      ],
      }
      """
    When method POST
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'
    
  Scenario: T7
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Create Category
    Given path '/api/v1/private/category'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
      "parent": { "id": '99', "code": "root" },
      "store": 'DEFAULT',
      "visible": true,
      "code": '99',
      "sortOrder": 0,
      "selectedLanguage": "en",
      "descriptions":
      [
        {
          "language": "en",
          "name": '',
          "highlights": "",
          "friendlyUrl": 'T7',
          "description": "",
          "title": "",
          "metaDescription": "",
        },
      ],
      }
      """
    When method POST
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'
    
  Scenario: T8
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Create Category
    Given path '/api/v1/private/category'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
      "parent": { "id": '99', "code": "root" },
      "store": 'DEFAULT',
      "visible": true,
      "code": '99',
      "sortOrder": 0,
      "selectedLanguage": "en",
      "descriptions":
      [
        {
          "language": "en",
          "name": 'T8',
          "highlights": "",
          "friendlyUrl": null,
          "description": "",
          "title": "",
          "metaDescription": "",
        },
      ],
      }
      """
    When method POST
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'
    
  Scenario: T9
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Create Category
    Given path '/api/v1/private/category'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
      "parent": { "id": '99', "code": "root" },
      "store": 'DEFAULT',
      "visible": true,
      "code": '99',
      "sortOrder": 0,
      "selectedLanguage": "en",
      "descriptions":
      [
        {
          "language": "en",
          "name": 'T9',
          "highlights": "",
          "friendlyUrl": '',
          "description": "",
          "title": "",
          "metaDescription": "",
        },
      ],
      }
      """
    When method POST
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'
    
  Scenario: T10
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token
    # Create Category
    Given path '/api/v1/private/category'
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
      "parent": { "id": '99', "code": "root" },
      "store": 'DEFAULT',
      "visible": true,
      "code": '99',
      "sortOrder": 0,
      "selectedLanguage": "en",
      "descriptions":
      [
        {
          "language": "en",
          "name": 'T10',
          "highlights": "",
          "friendlyUrl": 'T10~!@#$%^&*()?_+|\=-',
          "description": "",
          "title": "",
          "metaDescription": "",
        },
      ],
      }
      """
    When method POST
    Then status 500
    And print response
    And match response.errorCode == '#present'
    And match response.errorCode == '500'
    And match response.message == '#present'
    