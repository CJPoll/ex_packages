defmodule PackageExamples.Module2 do
  use Packages, package: Package1

  require PackageExamples.Module1

  def do_thing do
    PackageExamples.Module1.function1()
  end
end
