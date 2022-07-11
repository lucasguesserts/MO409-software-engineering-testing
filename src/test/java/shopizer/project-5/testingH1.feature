Feature: H1 Story

  Background:
    * url 'http://localhost:8080/api/v1'

Scenario: H1 story - path [1, 4, 5, 7, 8, 9]

    # perform customer login
    Given path '/customer/login'
    And request { "username": boloceno@hotmail.com, "password": Faabio123@ }
    And method post
    Then status 200
    And def token = response.token
    
    # get user data
    Given path '/auth/customer/profile'
    And header Authorization = 'Bearer ' + token
    And method get
    Then status 200
    And print response
    
    # order history
    Given path '/auth/orders'
    And header Authorization = 'Bearer ' + token
    And method get
    Then print response
    And status 200

Scenario: H1 story - path [1, 3, 2, 1, 4, 6, 7, 8, 9]

    # invalid login credentials
    Given path '/customer/login'
    And request { "username": anakin@jedi.com, "password": blue }
    And method post
    Then status 401
    
    # register user
    Given path '/customer/register'
    And request { "userName": anakin,"password": blue,"emailAddress": anakin@jedi.com,"gender":"M","language":"en","billing":{"country":"CA","stateProvince":"ON","firstName":"Teste","lastName":"Teste"}}
    And method post
    Then status 200
		And print response

    # now login is valid
    Given path '/customer/login'
    And request { "username": anakin@jedi.com, "password": blue }
    And method post
		Then status 200
    And def token = response.token
    And def userId = response.id
    
    # change password
    Given path '/auth/customer/password'
    And header Authorization = 'Bearer ' + token
    And request 
	    """
	    {
			  "current": "blue",
			  "password": "red",
			  "repeatPassword": "red",
			  "username": "anakin@jedi.com"
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
    #Then status 200   
      
      
      
      
      

    
    
    