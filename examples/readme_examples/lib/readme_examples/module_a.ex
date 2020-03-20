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
