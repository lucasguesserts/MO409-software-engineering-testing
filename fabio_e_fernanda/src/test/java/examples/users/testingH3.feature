Feature: H1 Story

  Background:
    * url 'http://localhost:8080/api/v1'

Scenario: H1 story - user does not exist - create and delete

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
    

Scenario: H1 story - login fails - then succeeds

    # login fails
    Given path '/customer/login'
    And request { "username": brigadeiro@hotmail.com, "password": "wrong password" }
    And method post
		Then status 401

    # login succeeds
    Given path '/customer/login'
    And request { "username": brigadeiro@hotmail.com, "password": Henrique123@ }
    And method post
		Then status 200
    

Scenario: H1 story - path [1, 3, 4, 5, 4, 6, 8, 7]

    # login
    Given path '/customer/login'
    And request { "username": brigadeiro@hotmail.com, "password": Henrique123@ }
    And method post
		Then status 200
    And def token = response.token
    And def userId = response.id

		# product order
		Given path '/products'
    When method get
    Then status 200
    And print response

		# cart does not exist
		Given path '/auth/customer/cart'
    And header Authorization = 'Bearer ' + token
    When method get
  	Then status 404
    And print response

		# add product to cart
		Given path '/cart'
    And header Authorization = 'Bearer ' + token
    And request 
	    """
	    {
			  "product": "113",
			  "quantity": "2"
			}
	    """
    And method post
		Then status 201
		And def cartCode = response.code
		And print response

		# check cart
		Given path Path = '/cart/' + cartCode
    When method get
    Then status 200
    And print response
    
    # add product to cart
		Given path Path = '/cart/' + cartCode
    And request 
	    """
	    {
			  "product": "5",
			  "quantity": "2"
			}
	    """
    When method put
    Then status 201
    And print response

		# check cart
		Given path Path = '/cart/' + cartCode
    When method get
    Then status 200
    And print response
    
    # add product to cart with not enough quantity
		Given path Path = '/cart/' + cartCode
    And request 
	    """
	    {
			  "product": "1",
			  "quantity": "1000"
			}
	    """
    When method put
    Then status 400
    And print response

		# check cart
		Given path Path = '/cart/' + cartCode
    When method get
    Then status 200
    And print response  
