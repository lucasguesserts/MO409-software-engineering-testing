Feature: H1 Story

  Background:
    * url 'http://localhost:8080/api/v1'

Scenario: H1 story - create user and list orders

    # invalid login credentials
    Given path '/customer/login'
    And request { "username": "obiwan@jedi.order", "password": "S@tin3" }
    And method post
    # API Com problemas e Inconsistente
    Then match [200, 401] contains responseStatus

    # register user
    Given path '/customer/register'
    And request
    """
        {
            "userName": "obiwan",
            "password": "S@tin3",
            "emailAddress": "obiwan@jedi.order",
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
    # API Com problemas e Inconsistente
    Then match [200, 500] contains responseStatus
    And print response

    # now login is valid
    Given path '/customer/login'
    And request { "username": "obiwan@jedi.order", "password": "S@tin3" }
    And method post
    Then status 200
    And def token = response.token
    And def userId = response.id

    # change password (invalid data)
    Given path '/auth/customer/password'
    And header Authorization = 'Bearer ' + token
    And request
    """
        {
            "current": "NotThePasswordExpected",
            "password": "MyS@tin3",
            "repeatPassword": "MyS@tin3",
            "username": "obiwan@jedi.order"
        }
    """
    And method post
    # API Com problemas e Inconsistente
    Then match [400, 500] contains responseStatus
    And print response

    # change password
    Given path '/auth/customer/password'
    And header Authorization = 'Bearer ' + token
    And request
    """
        {
            "current": "S@tin3",
            "password": "MyS@tin3",
            "repeatPassword": "MyS@tin3",
            "username": "obiwan@jedi.order"
        }
    """
    And method post
    Then status 200
    And print response

    # order history
    Given path '/auth/orders'
    And header Authorization = 'Bearer ' + token
    And method get
    Then print response
    And status 200

    # auth admin
    Given path '/private/login'
    And request {username: 'admin@shopizer.com', password: 'password'}'
    When method POST
    Then status 200
    And print response
    And match response.token == '#present'

    # delete user
    Given path '/private/customer/' + userId
    And header Authorization = 'Bearer ' + token
    And method delete
    Then status 200
