defmodule PackageExamples.Module1 do
  @moduledoc false
  use Packages, package: Package1

  def hello do
    :hello
  end

  defr function1 do
    :stuff
  end

  defr function() do
    :ok
  end

  defr function2(:hi, _arg2) do
    :with_hi
  end

  defr function2(_arg1, _arg2) do
    :without_hi
  end

  defr function3(arg1, _arg2) when is_integer(arg1) do
    :integer_arg
  end

  defr function3(nil, _arg2) do
    :nil_handled
  end

  defr function4(_arg1, _arg2) do
    raise "Exception"
  rescue
    _e -> :ok
  end

  defr function5 do
    raise "Exception"
  rescue
    _e -> :ok
  end

  defr function6() do
    raise "Exception"
  rescue
    _e -> :ok
  end

  defr function7(arg1, _arg2) when not is_nil(arg1) do
    raise "Exception"
  rescue
    _e -> :ok
  end

  defr recursive_function1() do
    IO.inspect("Yes!")
    recursive_function1()
  end

  defr(recursive_function2(n, sum \\ 0))

  defr(recursive_function2(0, sum), do: sum)

  defr recursive_function2(n, sum) when is_integer(n) do
    recursive_function2(n - 1, sum + n)
  end
end
