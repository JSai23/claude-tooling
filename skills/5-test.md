---
name: 5-test
description: Write thorough tests
disable-model-invocation: true
---
Write comprehensive tests for the implemented code.

## Testing Philosophy

### Test Real Behavior
- Test actual code paths, not mocked abstractions
- Minimize mocking - mock only external services
- If you must mock, mock at the boundary

### Coverage Priorities
1. **Happy path** - Normal successful operation
2. **Error cases** - What happens when things fail
3. **Edge cases** - Boundary conditions, empty inputs, large inputs
4. **Integration** - Components working together

### Test Structure
```
Given: Setup - what state exists before
When: Action - what operation is performed
Then: Assertion - what should be true after
```

## Anti-Patterns to Avoid
- Don't test implementation details (private methods, internal state)
- Don't write tests that always pass
- Don't skip tests because they're "hard"
- Don't mock away the code you're trying to test

## Process
1. Identify untested code paths
2. Write tests for each path
3. Run tests, ensure they fail first (if new code)
4. Fix any issues found
5. Verify coverage improved

## Testing Surface
1. Reading the tests should define the behavior
2. Tests should not test if the "language" works
3. Every test represents something that can and will happen - you shouldn't handle an error that can't happen or isn't meant to happen

When you are writing tests you should be questioning behavior and asking the user about the expected behavior. Writing tests is meant to think through the behavior of the code. Tests are not a chore or something to get done they are equivalent to planning but after you write the code you ask questions you write tests. Also its ok to write tests and find out they fail - don't fix the problem save and list these to the user.
