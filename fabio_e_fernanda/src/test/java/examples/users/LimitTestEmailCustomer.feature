Feature: Customer Authentication Resource API

  Background:
    * url 'http://localhost:8080/api/v1'
    # Auth
    Given path '/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'
    And def token = response.token
    And print token

  Scenario Outline: <email>.
    Given path '/customer/register'
    And request { "userName": <email>,"password": <password>,"emailAddress": <email>,"gender":"M","language":"en","billing":{"country":"CA","stateProvince":"ON","firstName":"Teste","lastName":"Teste"}}
    And method post
    Then status <response_status>
    And def id = response.id
    Then print response
    Given path '/private/customer/' + id
    And header Authorization = 'Bearer ' + token
    When method delete
    #Then status 200
   
    Examples:
      | email                                                                                              | password      | response_status  |
      | 5DIckeW3ejY3Ws1yhxlIAJA3xc1dnYbwJgVLSrLlDRzhUOPnOSVHztsLNu7MkmIkBNNdKKiF5I4FpX4Uj@trashmail.com    | Lucas123@     | 200              |    
      | ciXWOdGbCFnqPLUYS9Aj5R9EZ34Xt5tshsGg6BcmEDejasdgzlZn5qvA40hEfncneVkGuXkewG7cHmUDJT@trashmail.com   | Luqinha123@   | 200              |
      | 8fY3YpZn0gpOM7wS84QDU9huFZ9LvhXqWVijd3mR28DgXvv5fSDphW1lmdrTPUQ8HKVRW94qMwyRzBPP11U@trashmail.com  | Lucaas123@    | 500              |
      |                                                                                                    | Lucaas123@    | 500              |
      | ''                                                                                                 | Lucao123@     | 500              |
      | &%a=@trashmail.com                                                                                 | Lucareli      | 500              |

      
 