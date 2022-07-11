Feature: H1 Story

  Background:
    * url 'http://localhost:8080/api/v1/'

Scenario: H4 story - user does not exist - create and delete

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

Scenario: H4 story - user abandon the shopping removing all products from shopping cart

    # login
    Given path '/customer/login'
    And request { "username": brigadeiro@hotmail.com, "password": Henrique123@ }
    And method post
		Then status 200
    And def token = response.token
    And def userId = response.id

		# add product P113 to cart
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
    
    # add product P5 to cart
		Given path Path = '/cart/' + cartCode
    And request 
	    """
	    {
			  "product": "5",
			  "quantity": "9"
			}
	    """
    When method put
    Then status 201
    And print response
    
    # add product P8 to cart
		Given path Path = '/cart/' + cartCode
    And request 
	    """
	    {
			  "product": "8",
			  "quantity": "3"
			}
	    """
    When method put
    Then status 201
    And print response
    
    # change product P5 quantity in cart
		Given path Path = '/cart/' + cartCode
    And request 
	    """
	    {
			  "product": "5",
			  "quantity": "7"
			}
	    """
    When method put
    Then status 201
    And print response
    
    # remove product P113 from cart
		Given path Path = '/cart/' + cartCode
    And request 
	    """
	    {
			  "product": "113",
			  "quantity": "0"
			}
	    """
    When method put
    Then status 201
    And print response
    
    # remove product P8 from cart
		Given path Path = '/cart/' + cartCode
    And request 
	    """
	    {
			  "product": "8",
			  "quantity": "0"
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
    And response.total == 245
    
    # remove product P5 from cart
		Given path Path = '/cart/' + cartCode + '/product/5'
    When method delete
    Then status 204 # it means the cart is empty
    And print response

Scenario: H4 - realize payment

    # login
    Given path '/customer/login'
    And request { "username": brigadeiro@hotmail.com, "password": Henrique123@ }
    And method post
		Then status 200
    And def token = response.token
    And def userId = response.id

		# add product P113 to cart
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
    And def cart_total_price = response.total

		# payment
		Given path '/auth/cart/' + cartCode + '/payment/init'
    And header Authorization = 'Bearer ' + token
		And request
			"""
			{
			  "amount": "#(cart_total_price)",
			  "paymentModule": "Card",
			  "paymentType": "Money order",
			  "transactionType": "INIT"
			}
			"""
		And method post
		Then print response
		Then status 200

Scenario: H4 story - user creates a shopping cart, removes all items and checks it

    # login
    Given path '/customer/login'
    And request { "username": brigadeiro@hotmail.com, "password": Henrique123@ }
    And method post
		Then status 200
    And def token = response.token
    And def userId = response.id

		# add product P113 to cart
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
    
    # remove product P113 from cart
		Given path Path = '/cart/' + cartCode + '/product/113'
    When method delete
    Then status 204 # it means the cart is empty
    And print response

    