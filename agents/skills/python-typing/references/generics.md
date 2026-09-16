# Generic Type Relationships

## Preserve the Caller’s Type

- Use a generic to relate types, not merely to accept many types.
- This Python 3.12+ function preserves the element type in its result.
- `Sequence` permits indexing without requiring a mutable list.

```python
"""Preserve an element type while accepting read-only sequence operations."""

from collections.abc import Sequence


def require_first[T](items: Sequence[T]) -> T:
    """Return the first item, or raise ValueError for an empty sequence."""
    if not items:
        raise ValueError("At least one item is required.")
    return items[0]
```

## Preserve Stored Types

- Use a generic class when several operations share a stored type.
- Keep absence explicit instead of returning `Any` or suppressing return-type errors.
- This Python 3.12+ example illustrates storage typing, not a required repository architecture.

```python
"""Keep stored values and lookup results related by one type parameter."""


class Registry[T]:
    """Store values of one type under string keys."""

    def __init__(self) -> None:
        """Create an empty registry."""
        self._values: dict[str, T] = {}

    def put(self, key: str, value: T) -> None:
        """Store a value under its key."""
        self._values[key] = value

    def get(self, key: str) -> T | None:
        """Return the stored value, or None when the key is absent."""
        return self._values.get(key)
```

## Bounds and Constraints

- A bound sets required capabilities while preserving a more specific subtype.
- Constraints require one of the listed alternatives; a subtype can be promoted to its matching constraint.
- The Python 3.12+ signatures below express different contracts.

```python
"""Contrast subtype-preserving bounds with fixed type alternatives."""


def retain_text[T: str](value: T) -> T:
    """Return a string while preserving its specific subtype."""
    return value


def concatenate[T: (str, bytes)](left: T, right: T) -> T:
    """Join two values that use the same string representation."""
    return left + right
```

## Protocol Bounds

- Use a protocol bound when an operation needs specific members and must preserve the caller's type.
- A plain protocol parameter suffices when that type relationship is unnecessary.
- This Python 3.12+ example selects a job without losing its concrete type.

```python
"""Select an item by priority while preserving its concrete type."""

from collections.abc import Iterable
from dataclasses import dataclass
from typing import Protocol, assert_type


class HasPriority(Protocol):
    """Expose a priority for selection."""

    @property
    def priority(self) -> int:
        """Return the item's priority."""
        ...


def highest_priority[T: HasPriority](items: Iterable[T]) -> T:
    """Return the highest-priority item, or raise ValueError for empty input."""
    return max(items, key=lambda item: item.priority)


@dataclass
class Job:
    """Identify work and its priority."""

    name: str
    priority: int


assert_type(highest_priority([Job("build", 2), Job("deploy", 1)]), Job)
```

## Preserve the Receiver's Subtype

- Use `Self` for results tied to the receiver's subtype, not merely the class where the method is defined.
- A method that always creates a specific base class should return that class, not `Self`.
- This Python 3.11+ example preserves the subclass through an inherited fluent method.

```python
"""Preserve a subclass through a fluent configuration method."""

from typing import Self, assert_type


class Options:
    """Configure whether an operation emits detailed output."""

    verbose: bool = False

    def with_verbose(self) -> Self:
        """Enable detailed output and return this instance."""
        self.verbose = True
        return self


class BuildOptions(Options):
    """Configure a build operation."""


assert_type(BuildOptions().with_verbose(), BuildOptions)
```

## Compatibility and Mutation

- For Python before 3.12, express these relationships with `TypeVar` and `Generic`.
- Mutable containers such as `list` are invariant: `list[Derived]` is not generally usable as `list[Base]`.
  Otherwise, a consumer could insert an incompatible base value.
- Choose a read-only interface when the implementation only reads values; do not force variance through a cast.

## Sources

- [Generic syntax, bounds, constraints, and variance](https://typing.python.org/en/latest/spec/generics.html).
- [Self types](https://typing.python.org/en/latest/spec/generics.html#self).
- [Protocol bounds](https://typing.python.org/en/latest/spec/protocol.html#protocols-can-be-used-as-upper-bounds-for-type-variables).
- [Argument and return interfaces](https://typing.python.org/en/latest/reference/best_practices.html#arguments-and-return-types).
