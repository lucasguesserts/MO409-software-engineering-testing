Feature: Categories

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  Scenario Outline: Create Category -> <friendly_url>
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
      "parent": { "id": <cat_id>, "code": "root" },
      "store": <store>,
      "visible": <visible>,
      "code": <cat_id>,
      "sortOrder": 0,
      "selectedLanguage": "en",
      "descriptions":
      [
        {
          "language": "en",
          "name": <name>,
          "highlights": "",
          "friendlyUrl": <friendly_url>,
          "description": "",
          "title": "",
          "metaDescription": "",
        },
      ],
      }
      """
    When method POST
    Then status 201
    And print response
    And match response.id == '#present'

    Examples:
      | read('Categories.csv') |
