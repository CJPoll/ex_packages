defmodule MyApp.ModuleD do
  use Packages, package: Package1

  @thing :a

  defr thing(true) do
    @thing
  end

  @thing :b

  defr thing(false) do
    @thing
  end
end
