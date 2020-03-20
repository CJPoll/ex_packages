defmodule ReadmeExamplesTest do
  use ExUnit.Case
  doctest ReadmeExamples

  test "greets the world" do
    assert ReadmeExamples.hello() == :world
  end
end
