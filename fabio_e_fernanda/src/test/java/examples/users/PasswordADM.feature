Feature: User Authentication Resource API

  Background:
    * url 'http://localhost:8080/api/v1/private/login'

  Scenario Outline: <email>
    And request { "username": <email>, "password": <password> }
    And method post
    And def status = response.status
    Then status <response_status>
    Then print response

    Examples:
      | email                      | password              | response_status  |
      | admin@shopizer.com         | password              | 200              |
      | admin@shopizer.com         | batatinhafrita123     | 401              |
      | qualquercoisa@hotmail.com  | password              | 401              |
      | adminshopizer.com          | password              | 401              |
      | ''                         | password              | 401              |
      |                            | password              | 401              |
      | &%a=                       | password              | 401              |
      