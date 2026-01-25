# Testing Philosophy

This guide captures the testing philosophy used across claude-tooling skills.

## Core Principle: Test Real Behavior

The #1 mistake in testing is mocking away the thing you're trying to test.

### Good
```python
def test_user_creation():
    db = create_test_database()  # Real database, test instance
    user = create_user(db, "alice@example.com")
    assert db.get_user(user.id).email == "alice@example.com"
```

### Bad
```python
def test_user_creation():
    mock_db = Mock()
    mock_db.save.return_value = True
    user = create_user(mock_db, "alice@example.com")
    mock_db.save.assert_called_once()  # Tests nothing about actual behavior
```

## When Mocking is Appropriate

Mock at **boundaries**, not internals:

| Mock These | Don't Mock These |
|------------|------------------|
| External APIs (Stripe, GitHub) | Your own database code |
| Email/SMS services | Your own business logic |
| Time/randomness (for determinism) | Internal function calls |
| File system (sometimes) | The class under test |

## Test Structure: Given-When-Then

Every test should have clear phases:

```python
def test_order_total_with_discount():
    # Given: Setup - what state exists before
    order = Order()
    order.add_item(Item("Widget", price=100))
    order.add_item(Item("Gadget", price=50))

    # When: Action - what operation is performed
    order.apply_discount(percent=10)

    # Then: Assertion - what should be true after
    assert order.total == 135  # 150 - 10%
```

## Coverage Priorities

1. **Happy path** - Normal successful operation
2. **Error cases** - What happens when things fail
3. **Edge cases** - Boundary conditions, empty inputs, large inputs
4. **Integration** - Components working together

Don't chase 100% coverage. Chase meaningful coverage.

## Anti-Patterns to Avoid

### Testing Implementation Details
```python
# Bad: Tests private state
assert user._password_hash.startswith("$2b$")

# Good: Tests behavior
assert user.check_password("secret123")
```

### Tests That Always Pass
```python
# Bad: No assertion
def test_something():
    result = do_thing()
    # Oops, forgot to assert

# Good: Explicit assertion
def test_something():
    result = do_thing()
    assert result == expected_value
```

### Skipping "Hard" Tests
```python
# Bad
@pytest.mark.skip("too hard to test")
def test_payment_flow():
    pass

# Good: Make it testable
def test_payment_flow():
    with mock_stripe():
        result = process_payment(amount=100)
        assert result.status == "succeeded"
```

## Tests Define Behavior

Reading the tests should tell you what the code does.

```python
def test_expired_tokens_are_rejected():
    token = create_token(expires_in=timedelta(hours=-1))
    with pytest.raises(TokenExpiredError):
        validate_token(token)

def test_tokens_can_be_refreshed_within_grace_period():
    token = create_token(expires_in=timedelta(minutes=-5))
    new_token = refresh_token(token, grace_period=timedelta(minutes=10))
    assert new_token.is_valid()
```

These tests document that:
- Expired tokens raise `TokenExpiredError`
- There's a refresh grace period of configurable duration

## Writing Tests is Thinking

Tests are not a chore to get done after implementation. Writing tests is:
- Thinking through behavior
- Questioning assumptions
- Finding edge cases
- Defining the contract

If writing tests reveals unclear requirements, **stop and ask** rather than guessing.

## It's OK for Tests to Fail

When you write tests and they fail:
1. **Don't immediately fix the code**
2. Save the failing test
3. Report it to the user
4. Let them decide if the code or the expectation is wrong

A failing test might mean:
- Bug in the code (fix the code)
- Wrong expectation (fix the test)
- Unclear requirement (ask the user)
