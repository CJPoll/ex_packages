defmodule PackagesTest do
  use ExUnit.Case
  doctest Packages

  test "greets the world" do
    assert Packages.hello() == :world
  end
end
