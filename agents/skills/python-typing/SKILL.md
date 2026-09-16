---
name: python-typing
description: Design and review Python type annotations and contracts. Use when choosing unions, generics, protocols, typed data shapes, or callback types, or investigating type-checker diagnostics.
---

# Python Typing

Express the real contract with the simplest type that preserves it.

## Establish the Contract

- Check the project's Python version, type checker, configuration, and nearby conventions before changing annotations.
- Annotate public boundaries. Let inference handle clear local values.
- Distinguish static guarantees from runtime checks. Annotations and casts do not validate external data.
- Keep input types broad enough for supported callers and return types precise enough for their needs.
- Use built-in collections and `collections.abc` interfaces instead of deprecated `typing` aliases.
- Match syntax to the supported Python version. New generic syntax and `type` aliases require Python 3.12+.
- Use `typing_extensions` only when a required typing feature needs a supported backport; it cannot backport syntax.

These rules draw on the [typing documentation](https://docs.python.org/3/library/typing.html)
and [typing best practices](https://typing.python.org/en/latest/reference/best_practices.html).

## Choose the Construct

- **Alternatives:** use a union for multiple possible types; include `None` only when it is a valid value.
  An argument with a default is not necessarily nullable.
- **Unknown values:** use `object` when callers can supply anything but operations need narrowing.
  Use `Any` deliberately where static checking must be relaxed.
- **Narrowing:** prefer explicit checks such as `is None` or `isinstance`.
  Read [annotations.md](references/annotations.md) for nullable values, validation, or custom narrowing predicates.
- **Collections:** use `Iterable`, `Sequence`, or `Mapping` when only those operations are required.
  Require a mutable interface or concrete collection when mutation or concrete behavior is part of the contract.
- **Type relationships:** use a generic when types must stay related across arguments, results, or stored values.
  Bounds preserve subtypes; constraints select from specific alternatives.
  A protocol bound combines required behavior with preservation of the caller's type.
- **Receiver types:** use `Self` when a method preserves the receiver's subtype, including inherited fluent methods and classmethod constructors.
  Read [generics.md](references/generics.md) for generic relationships and `Self`.
- **Interfaces:** use a protocol when compatible behavior matters rather than inheritance.
  Use `Callable` for simple callbacks and a callable protocol for richer signatures.
- **Wrappers:** use `ParamSpec` to preserve callable parameters and a type parameter to relate return types.
- **Input-dependent results:** use `@overload` when unions lose the relationship between inputs and outputs and a generic cannot express it simply.
  Read [interfaces.md](references/interfaces.md) for callbacks, decorators, and overloads.
- **Names and identity:** use an alias for readability and `NewType` for a distinct static identity.
  Neither adds runtime validation.
- **Structured mappings:** use `TypedDict` for known dictionary keys and value types, not for runtime parsing.
  Read [interfaces.md](references/interfaces.md) for interfaces, aliases, identities, and dictionary shapes.
- **Escape hatches:** use casts or targeted suppressions only with a justified invariant or known checker limitation.
  Do not use them to hide a mismatched contract.

## Local Conventions

- These are repository preferences, not requirements of Python's type system.
- Prefer an `Enum` for a fixed set of named domain values.
  Use `Literal` only when an exact constant belongs to the type contract.
- Write unions with `|`. For example, write `int | str`, not `Union[int, str]`.

## Validate the Change

- Run the project's configured checker against the affected code and callers.
- Before suppressing unexpected diagnostics, check the selected environment, dependencies, stubs, and Python version.
- Tighten checking incrementally for existing code. Do not replace tooling or broaden CI checks without task authorization.
- Read [type-checking.md](references/type-checking.md) for environment diagnosis and checker-specific configuration.
- Check version-sensitive or disputed semantics against the
  [canonical typing specification](https://typing.python.org/en/latest/spec/index.html).
