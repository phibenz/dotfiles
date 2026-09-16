# Annotations and Narrowing

## Nullable Values and Defaults

- Use a union for actual alternatives. A default value only permits omission.
- In this Python 3.10+ example, `name` is required but accepts `None`.
  Callers can omit `prefix`, but any supplied value must be a string.

```python
"""Distinguish a nullable value from an argument with a default."""


def display_name(name: str | None, prefix: str = "") -> str:
    """Return the supplied name or an anonymous label."""
    if name is None:
        return prefix + "anonymous"
    return prefix + name
```

## Unknown Input and Runtime Validation

- `object` accepts arbitrary input while requiring checks before type-specific operations.
- Prefer a runtime check when data comes from outside the typed contract.
- A cast would tell the checker to trust the value without checking it.
- This example deliberately rejects booleans, although `bool` is a subclass of `int`.

```python
"""Validate an external value before treating it as a retry count."""


def parse_retries(value: object) -> int:
    """Return a nonnegative integer, rejecting booleans and other values."""
    if isinstance(value, bool) or not isinstance(value, int):
        raise TypeError("The retry count must be an integer.")
    if value < 0:
        raise ValueError("The retry count must not be negative.")
    return value
```

## Reusable Predicates

- Use ordinary checks first. Add `TypeIs` or `TypeGuard` only when a reusable predicate needs to communicate narrowing.
- `TypeIs[T]` requires a compatible input type and narrows both branches.
  Its predicate must return true exactly for values of `T`.
- `TypeGuard[T]` can narrow to an incompatible type, but provides no narrowing in the false branch.
- Neither annotation proves the predicate correct. Check its runtime logic and relevant boundary cases.
- Mutation can invalidate a previous check, especially across callbacks or `await`.
- `TypeIs` requires Python 3.13+ or a suitable `typing_extensions` backport.

## Sources

- [Optional values](https://docs.python.org/3/library/typing.html#typing.Optional)
  and [casts](https://docs.python.org/3/library/typing.html#typing.cast).
- [Any versus object](https://typing.python.org/en/latest/spec/special-types.html#any).
- [Narrowing and predicate safety](https://typing.python.org/en/latest/guides/type_narrowing.html).
