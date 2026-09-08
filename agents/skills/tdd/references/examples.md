# Positive and Negative Test Examples

Use these pairs to assess feedback and maintenance cost. They use Python-like
pseudocode so the testing ideas stay independent of a framework.

A negative pattern can be valid when the project has a different public
contract or cost profile. Explain that context instead of applying a label
mechanically.

## Test Public Behavior

Negative pattern: the test reaches through the public object to test a private
calculation.

```python
def test_discount_rounding_helper():
    cart = Cart()

    assert cart._round_discount(999, 10) == 100
```

Positive pattern: the test states the customer-visible rule through the public
interface.

```python
def test_member_discount_uses_currency_rounding():
    cart = Cart(member_discount_percent=10)
    cart.add(Product(price_cents=999))

    assert cart.total_cents() == 899
```

The positive test can survive a change to the internal rounding design. Test a
helper directly only when the helper is itself a supported boundary or a public
test would hide the failure.

## Use an Independent Expected Value

Negative pattern: the test repeats the production formula.

```python
def test_discounted_total():
    subtotal = 1_250
    rate = 20
    expected = subtotal - subtotal * rate // 100

    assert discounted_total(subtotal, rate) == expected
```

Positive pattern: the expected value comes from a worked business example.

```python
def test_twenty_percent_discount_on_twelve_fifty():
    assert discounted_total(subtotal_cents=1_250, percent=20) == 1_000
```

The negative test can repeat the same defect on both sides. A calculated oracle
is useful when it is an intentionally independent reference implementation.

## Observe Outcomes Instead of Internal Choreography

Negative pattern: mocks couple the test to an internal call sequence.

```python
def test_checkout_calls_collaborators():
    payments = Mock()
    orders = Mock()

    checkout(CART, payments=payments, orders=orders)

    payments.charge.assert_called_once_with(CARD, 2_500)
    orders.save.assert_called_once()
```

Positive pattern: controlled collaborators support a public behavior test.

```python
def test_successful_checkout_creates_a_paid_order():
    app = Shop(payment_gateway=FakeApprovedPayments())

    order_id = app.checkout(CART, CARD)

    assert app.order(order_id).status == "paid"
    assert app.order(order_id).total_cents == 2_500
```

The positive test permits internal refactoring. Verify calls when the
interaction itself is a contract, such as charging exactly once.

## Control Nondeterminism

Negative pattern: wall-clock time and sleeping make the result slow and
unreliable.

```python
def test_reminder_is_sent():
    schedule_reminder(delay_seconds=1)

    sleep(1)

    assert inbox.last_message.subject == "Reminder"
```

Positive pattern: the test controls time and observes the result.

```python
def test_reminder_is_sent_when_it_becomes_due():
    clock = FakeClock("2030-01-01T09:00:00Z")
    app = ReminderApp(clock=clock, inbox=FakeInbox())
    app.schedule(delay_seconds=60)

    clock.advance(seconds=60)
    app.send_due_reminders()

    assert app.inbox.subjects == ["Reminder"]
```

Introduce this control only when nondeterminism is a real cost. Do not add
indirection merely to make every collaborator mockable.

## Reproduce Broad Failures at a Focused Boundary

Negative pattern: a slow browser test is the only protection for a small
rounding rule.

```python
def test_checkout_rounds_tax(browser):
    browser.add_product(price="9.99")
    browser.checkout(postcode="10001")

    assert browser.order_total() == "$10.88"
```

Positive pattern: a focused test protects the rule that caused the defect.

```python
def test_invoice_rounds_tax_once_after_summing_items():
    invoice = Invoice(items=[Item(333), Item(666)], tax_percent=8.875)

    assert invoice.total_cents() == 1_088
```

Keep a broader checkout test when it protects distinct browser, API, or wiring
risk. If the broad test is fast, reliable, and cheap to change, it can be the
best test without a focused duplicate.

## Remove Tests With No Distinct Value

Negative pattern: one test observes behavior while another verifies the current
implementation of the same behavior.

```python
def test_checkout_calls_email_validator():
    validator = Mock()
    checkout(email="", validator=validator)

    validator.validate.assert_called_once_with("")


def test_checkout_rejects_an_empty_email():
    with raises(InvalidEmail):
        checkout(email="")
```

Positive pattern: retain the behavior test when it provides all required
confidence.

```python
def test_checkout_rejects_an_empty_email():
    with raises(InvalidEmail):
        checkout(email="")
```

Keep both only when the interaction protects a separate contract. Tests have
value when they add confidence or explain behavior, not merely when they add
coverage.

## Distinguish Structure from Runtime Behavior

Negative pattern: a source-text assertion claims to prove runtime behavior.

```python
def test_container_runs_as_non_root():
    dockerfile = read_text("Dockerfile")

    assert "USER app" in dockerfile
```

Positive pattern: the test observes the property on the built artifact.

```python
def test_container_runs_as_non_root(built_image):
    result = run_container(built_image, command="id -u")

    assert result.exit_code == 0
    assert result.stdout.strip() != "0"
```

The source-text test cannot detect a later directive, entrypoint, or runtime
override. A structural assertion is still valid when the exact structure is
the supported contract. Describe it as a structure check, not runtime proof.

## Choose a Broad Test When Its Economics Are Better

Negative pattern: many isolated tests mock each layer but never verify that the
layers work together.

```python
def test_route_calls_service(): ...
def test_service_calls_repository(): ...
def test_repository_calls_database(): ...
```

Positive pattern: one sociable API test exercises the real stack when that
stack is fast and deterministic.

```python
def test_create_order_can_be_read_back(api):
    created = api.post("/orders", json={"sku": "BOOK", "quantity": 1})

    fetched = api.get(f"/orders/{created.json['id']}")

    assert fetched.status == 200
    assert fetched.json == {"sku": "BOOK", "quantity": 1, "status": "new"}
```

The shape is not the goal. Prefer the test that gives sufficient fidelity with
acceptable frequency, overhead, and maintenance cost.
