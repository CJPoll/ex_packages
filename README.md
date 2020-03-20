# Packages

Adds support for package-scoped functions to Elixir-Lang.

1. Enables declaring which package a module belongs to
1. Raises a compile error if your module calls a restricted function that's not
   in the same package
1. IEx sessions can call any restricted function for convenience

Things to keep in mind:

1. Even if your module declares some restricted functions, any module can still
   call its public functions
1. If you want to call another module's restricted functions, the calling module
   must both:
   - Require that module
   - Belong to the same package as that module

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `packages` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:packages, git: "git@github.com:cjpoll/ex_packages.git"}
  ]
end
```

## Usage

### Define a restricted function
```elixir
defmodule MyApp.ModuleA do
  use Packages, package: Package1

  # Public Functions
  def public_function do
    "This is a public function"
  end

  # Internal Functions
  defr restricted_function do
    "This is a restricted function"
  end
end
```

### Calling a restricted function
```elixir
defmodule MyApp.ModuleB do
  # Package must match ModuleA's package to call any of ModuleA's restricted
  # functions
  use Packages, package: Package1

  # We need to require ModuleA in or der to call any of its restricted functions
  require MyApp.ModuleA

  alias MyApp.ModuleA

  def call_restricted do
    # This function call works just fine
    ModuleA.restricted_function()
  end
end
```

### Enforcing package boundaries
```elixir
defmodule MyApp.NoPackageExample do
  # Even if we require ModuleA, we won't be able to call its restricted
  # functions.
  # We can still call its public functions though.

  require MyApp.ModuleA

  alias MyApp.ModuleA

  def call_public do
    # This function call works just fine
    ModuleA.public_function()
  end

  def call_restricted do
    # Raises the following compile error:
    # Compiling 1 file (.ex)
    #
    # == Compilation error in file lib/readme_examples/module_c.ex ==
    # ** (RuntimeError)
    #
    #     MyApp.NoPackageExample is trying to call MyApp.ModuleA.restricted_function/0,
    #     which is a protected function. This function can be called from IEx, but
    #     not from outside package Package1
    #
    #   lib/packages.ex:175: Packages.__dispatch__/4
    #   expanding macro:
    #   lib/readme_examples/module_c.ex:16: MyApp.NoPackageExample.call_restricted/0
    ModuleA.restricted_function()
  end
end
```

### Tested Scenarios

This library has been tested to work correctly in the following scenarios:

```elixir
defmodule PackageExamples.Module1 do
  @moduledoc false
  use Packages, package: Package1

  # Public functions still work as expected
  def hello do
    :hello
  end

  # Works without parens
  defr function1 do
    :stuff
  end

  # Works with parens
  defr function() do
    :ok
  end

  # Supports pattern matching and underscores
  defr function2(:hi, _arg2) do
    :with_hi
  end

  # Supports functions with multiple clauses
  defr function2(_arg1, _arg2) do
    :without_hi
  end

  # Supports guard clauses
  defr function3(arg1, _arg2) when is_integer(arg1) do
    :integer_arg
  end

  defr function3(nil, _arg2) do
    :nil_handled
  end

  # Supports function-level rescue blocks (and catch too!)
  defr function4(_arg1, _arg2) do
    raise "Exception"
  rescue
    _e -> :ok
  end

  # Combination of no parens and rescue
  defr function5 do
    raise "Exception"
  rescue
    _e -> :ok
  end

  # Combination of parens and rescue
  defr function6() do
    raise "Exception"
  rescue
    _e -> :ok
  end

  # Combination of guards and rescue
  defr function7(arg1, _arg2) when not is_nil(arg1) do
    raise "Exception"
  rescue
    _e -> :ok
  end

  # Supports recursive function calls
  defr recursive_function1() do
    IO.inspect("Yes!")
    recursive_function1()
  end

  # Supports default value clauses
  defr(recursive_function2(n, sum \\ 0))

  # Supports 1-liner syntax (with rescue, catch, and finally support too)
  defr(recursive_function2(0, sum), do: sum)

  defr recursive_function2(n, sum) when is_integer(n) do
    recursive_function2(n - 1, sum + n)
  end
end
```
