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
    # When uncommented, Raises the following compile error:
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

    # ModuleA.restricted_function()
  end
end
