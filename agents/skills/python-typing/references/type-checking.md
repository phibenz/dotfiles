# Type Checking and Environment Diagnosis

## Establish the Existing Setup

- Read the project's checker configuration and its documented local or CI command.
- Check the supported Python version, package layout, dependencies, and stubs.
- Run the same checker locally before classifying an editor diagnostic as a false positive.
- Investigate disagreement before adding `Any`, casts, ignores, or broad import exclusions.
- A checker passing does not prove runtime validation or application behavior.

## Projects Using ty

- ty uses the project's Python environment to discover installed packages.
  Verify that the intended environment contains the required dependencies.
- When discovery selects the wrong environment, an explicit diagnostic command can isolate the cause:

```sh
ty check --python .venv
```

- Set the target version only when it matches the project's declared support.
  This example belongs in `pyproject.toml`:

```toml
[tool.ty.environment]
python-version = "3.12"
```

- Consult [ty's module discovery](https://docs.astral.sh/ty/modules/) and
  [environment settings](https://docs.astral.sh/ty/reference/configuration/#environment)
  before changing import paths or diagnostic rules.

## Existing mypy Projects

- Keep the existing checker unless the task includes a migration.
- A new project can enable strict checking explicitly:

```toml
[tool.mypy]
python_version = "3.12"
strict = true
```

- For incremental adoption, apply specific checks to an existing package.
  Replace `application.typed.*` with the actual module pattern:

```toml
[[tool.mypy.overrides]]
module = ["application.typed.*"]
disallow_untyped_defs = true
check_untyped_defs = true
```

- Use supported per-module options rather than assuming every global option can be overridden.
- See the [mypy configuration reference](https://mypy.readthedocs.io/en/stable/config_file.html#per-module-and-global-options).
