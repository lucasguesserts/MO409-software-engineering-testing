Feature: User Authentication Resource API

  Background:
    * url 'http://localhost:8080/'
    # Auth
    Given path '/api/v1/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token

  Scenario Outline: <id>
  	Given path '/api/v1/private/products/type/<id>'
  	And header Authorization = 'Bearer ' + token
    When method get
    Then status <response_status>
    Then print response

    Examples:
    	| id              | response_status  |
      | 50              | 200              |     
      | 51              | 200              |
      | 17              | 400              |
      | batatinhafrita  | 500              |
      |                 | 405              |
      | ''              | 500              |
      | &%a=            | 500              |
      
      
