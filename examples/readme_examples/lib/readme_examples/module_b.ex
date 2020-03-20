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
