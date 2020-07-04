defmodule MyApp.ModuleA do
  use Packages, package: Package1

  # Public Functions
  def public_function do
    "This is a public function"
  end

  # Internal Functions

  @doc "This documentation and spec should show up in the docs for `restricted_function`"
  @spec restricted_function() :: String.t()
  defr restricted_function do
    "This is a restricted function"
  end
end
