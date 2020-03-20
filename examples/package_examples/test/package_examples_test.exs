defmodule PackageExamplesTest do
  use ExUnit.Case
  doctest PackageExamples

  test "greets the world" do
    assert PackageExamples.hello() == :world
  end
end
