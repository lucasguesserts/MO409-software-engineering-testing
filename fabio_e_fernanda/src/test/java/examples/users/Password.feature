Feature: User Authentication Resource API

  Background:
    * url 'http://localhost:8080/api/v1/customer/login'

  Scenario Outline: <email>
    And request { "password": <password>, "username": <email> }
    And method post
    And def status = response.status
    Then status <response_status>
    Then print response

    Examples:
    	| email                  | password         | response_status  |
      | chocolate@hotmail.com  | Fernanda123@     | 200              |     
      | brigadeiro@hotmail.com | Henrique123@     | 200              |
      | boloceno@hotmail.com   | Faabio123@       | 200              |
      | bologoshotmail.com     | Faabio123@       | 200              |
      | admin@shopizer.com     | password         | 401              |
      | ''                     | Faabio123@       | 401             |
      |                        | Faabio123@       | 500              |
      | &%a=                   | Faabio123@       | 500              |

