@simple-books @api @crud @regression
Feature: Simple Books API - CRUD

  # -------------------------
  # 🔧 CONFIG BASE
  # -------------------------
  Background:
    # Base URL viene de karate-config.js -> baseUrl
    * url baseUrl

    # ✅ logs más legibles
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

    # Headers default para todas las requests (sin Authorization)
    * configure headers = { Accept: 'application/json', 'Content-Type': 'application/json' }

  # -------------------------
  #  HEALTH CHECK
  # -------------------------

  @health @get @smoke
  Scenario: Health (Status)
    # GET /status
    Given path 'status'
    When method get
    Then status 200
    # Validación del payload
    And match response.status == 'OK'

  # -------------------------
  #  BOOKS (READ)
  # -------------------------

  @books @read @get
  Scenario: Read - List books
    # GET /books
    Given path 'books'
    When method get
    Then status 200

    # Validación: lista
    And match response == '#[]'

    # Validación de estructura por item
    And match each response contains
      """
      { id: '#number', name: '#string', type: '#string', available: '#boolean' }
      """

  @books @read @get
  Scenario: Read - Get single book by id
    # 1) GET /books -> para agarrar un id válido
    Given path 'books'
    When method get
    Then status 200
    * def firstId = response[0].id

    # 2) GET /books/{id}
    Given path 'books', firstId
    When method get
    Then status 200

    # Validación de campos esperados
    And match response contains
      """
      { id: '#number', name: '#string', author: '#string', type: '#string', available: '#boolean' }
      """

  # -------------------------
  # AUTH (CREATE TOKEN)
  # -------------------------

  @auth @token @post @smoke
  Scenario: Create - Get token
    # Genera email único para evitar duplicados
    * def email = 'karate' + java.util.UUID.randomUUID() + '@mail.com'

    # POST /api-clients
    Given path 'api-clients'
    And request { clientName: 'Karate Client', clientEmail: '#(email)' }
    When method post
    Then status 201

    # Validación token
    And match response.accessToken == '#string'

    # Guarda token para uso local del scenario
    * def token = response.accessToken

  # -------------------------
  #  ORDERS (CREATE / READ / DELETE)
  # -------------------------

  @orders @create @post @regression
  Scenario: Create - Place an order (needs token)
    # ===== 1) POST /api-clients (obtener token) =====
    * def email = 'karate' + java.util.UUID.randomUUID() + '@mail.com'

    Given path 'api-clients'
    And request
      """
      { "clientName": "Karate Client", "clientEmail": "#(email)" }
      """
    When method post
    Then status 201
    * def token = response.accessToken

    # ===== 2) GET /books (obtener bookId) =====
    Given path 'books'
    When method get
    Then status 200
    * def bookId = response[0].id

    # ===== 3) Headers con Authorization para orders =====
    * configure headers =
      """
      {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        Authorization: '#("Bearer " + token)'
      }
      """

    # ===== 4) POST /orders (crear orden) =====
    Given path 'orders'
    And request { bookId: '#(bookId)', customerName: 'Aaron' }
    When method post
    Then status 201

    # Validación de respuesta create
    And match response == { orderId: '#string', created: true }

    # Guarda orderId
    * def orderId = response.orderId

  @orders @read @get @regression
  Scenario: Read - Get all orders (needs token)
    # ===== 1) POST /api-clients (obtener token) =====
    * def email = 'karate' + java.util.UUID.randomUUID() + '@mail.com'

    Given path 'api-clients'
    And request
      """
      { "clientName": "Karate Client", "clientEmail": "#(email)" }
      """
    When method post
    Then status 201
    * def token = response.accessToken

    # ===== 2) Headers con Authorization =====
    * configure headers =
      """
      {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        Authorization: '#("Bearer " + token)'
      }
      """

    # ===== 3) GET /orders =====
    Given path 'orders'
    When method get
    Then status 200
    And match response == '#[]'

  @orders @read @get @regression
  Scenario: Read - Get order by id (needs token)
    # ===== 1) POST /api-clients (token) =====
    * def email = 'karate' + java.util.UUID.randomUUID() + '@mail.com'

    Given path 'api-clients'
    And request
      """
      { "clientName": "Karate Client", "clientEmail": "#(email)" }
      """
    When method post
    Then status 201
    * def token = response.accessToken

    # ===== 2) GET /books (bookId) =====
    Given path 'books'
    When method get
    Then status 200
    * def bookId = response[0].id

    # ===== 3) Headers con Authorization =====
    * configure headers =
      """
      {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        Authorization: '#("Bearer " + token)'
      }
      """

    # ===== 4) POST /orders (crear orden) =====
    Given path 'orders'
    And request { bookId: '#(bookId)', customerName: 'Aaron' }
    When method post
    Then status 201
    * def orderId = response.orderId

    # ===== 5) GET /orders/{id} =====
    Given path 'orders', orderId
    When method get
    Then status 200

    # Validación mínima del payload
    And match response contains { id: '#string', bookId: '#number', customerName: '#string' }

  @orders @delete @delete @regression
  Scenario: Delete - Delete order by id (needs token)
    # ===== 1) POST /api-clients (token) =====
    * def email = 'karate' + java.util.UUID.randomUUID() + '@mail.com'

    Given path 'api-clients'
    And request
      """
      { "clientName": "Karate Client", "clientEmail": "#(email)" }
      """
    When method post
    Then status 201
    * def token = response.accessToken

    # ===== 2) GET /books (bookId) =====
    Given path 'books'
    When method get
    Then status 200
    * def bookId = response[0].id

    # ===== 3) Headers con Authorization =====
    * configure headers =
      """
      {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        Authorization: '#("Bearer " + token)'
      }
      """

    # ===== 4) POST /orders (crear orden) =====
    Given path 'orders'
    And request { bookId: '#(bookId)', customerName: 'Aaron' }
    When method post
    Then status 201
    * def orderId = response.orderId

    # ===== 5) DELETE /orders/{id} =====
    Given path 'orders', orderId
    When method delete
    Then status 204