---
name: testgen
description: Generate unit tests following testing best practices
---

Generate comprehensive unit tests: $ARGUMENTS (or for modified files)

## Principles:
- **Test one thing** per method
- **Clear names** (e.g., `test_getBar_wo_baz`)
- **No module imports** at top level (import within test methods)
- **Simple fixtures** (helper methods over setUp)

## Pattern:
```python
class FooClassTests(unittest.TestCase):
    def _getTargetClass(self):
        from package.foo import FooClass
        return FooClass
    
    def _makeOne(self, *args, **kw):
        return self._getTargetClass()(*args, **kw)
```

## Implementation:
1. **Test structure**: Preconditions → Call once → Assert
2. **Mock externals**: File I/O, external libraries
3. **Test scenarios**: Happy path, edge cases, errors
4. **Run**: `uv run pytest tests/` with coverage