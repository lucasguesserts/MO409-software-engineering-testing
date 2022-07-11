Feature: Customer Authentication Resource API

  Background:
    * url 'http://localhost:8080/api/v1/customer/register'

  Scenario Outline: <email>.
    Given path '/'
    And request { "userName": <email>,"password": <password>,"emailAddress": <email>,"gender":"M","language":"en","billing":{"country":"CA","stateProvince":"ON","firstName":"Teste","lastName":"Teste"}}
    And method post
    And def status = response.status
    Then status <response_status>
    Then print response
   
    Examples:
      | email                  | password         | response_status  |
      | chocolate@hotmail.com  | Fernanda123@     | 200              |    
      | brigadeiro@hotmail.com | Henrique123@     | 200              |
      | boloceno@hotmail.com   | Faabio123@       | 200              |
      | boloceno@hotmail.com   | Faabio123@       | 500              |
      | bologoshotmail.com     | Faabio123@       | 400              |
      | ''                     | Faabio123@       | 500              |
      |                        | Faabio123@       | 500              |
      | &%a=                   | Faabio123@       | 500              |
      
      
 