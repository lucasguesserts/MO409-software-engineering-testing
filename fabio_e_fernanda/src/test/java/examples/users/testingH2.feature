Feature: H1 Story

  Background:
    * url 'http://localhost:8080/api/v1'

Scenario: H2 story - user does not exist - create and delete

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

Scenario: H2 story - login fails - then succeeds

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

Scenario: H2 story - list categories

    # login succeeds
    Given path '/customer/login'
    And request { "username": brigadeiro@hotmail.com, "password": Henrique123@ }
    And method post
		Then status 200
		
		# list all categories
		Given path '/category'
		And method get
		Then status 200
		And print response
		
		# show category 1 info
		Given path '/category/1'
		And method get
		Then status 200
		And print response
		
		# show category 2 info
		Given path '/category/2'
		And method get
		Then status 200
		And print response

Scenario: H2 story - category 1 product variants

    # login succeeds
    Given path '/customer/login'
    And request { "username": brigadeiro@hotmail.com, "password": Henrique123@ }
    And method post
		Then status 200
		
		# get product variants in category
		Given path '/category/1/variants'
		And method get
		Then status 200
		And print response

Scenario: H2 story - category 2 product variants

    # login succeeds
    Given path '/customer/login'
    And request { "username": brigadeiro@hotmail.com, "password": Henrique123@ }
    And method post
		Then status 200
		
		# get product variants in category
		Given path '/category/2/variants'
		And method get
		Then status 200
		And print response
		
