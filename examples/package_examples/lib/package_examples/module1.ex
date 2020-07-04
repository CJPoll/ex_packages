defmodule PackageExamples.Module1 do
  @moduledoc false
  use Packages, package: Package1

  def hello do
    :hello
  end

  defr function0() do
    :ok
  end

  defr function1 do
    :stuff
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

  defr function3(_other, arg2) do
    arg2
  end

  defr function4(_arg1, _arg2) do
    raise "Exception"
  rescue
    _e -> :rescued
  end

  defr function5 do
    raise "Exception"
  rescue
    _e -> :rescued
  end

  defr function6() do
    raise "Exception"
  rescue
    _e -> :rescued
  end

  defr function7(arg1, _arg2) when not is_nil(arg1) do
    raise "Exception"
  rescue
    _e -> :rescued
  end

  defr function8(arg1, _arg2, nil) when not is_nil(arg1) do
    throw("Exception")
  catch
    _e -> :caught1
  end

  defr function8(_arg1, _arg2, _arg3) do
    throw("Exception")
  catch
    _e -> :caught2
  end

  defr function9 do
    throw("Exception")
  rescue
    _e -> :rescued
  catch
    _e -> :caught
  end

  defr function10 do
    raise("Exception")
  rescue
    _e -> :rescued
  catch
    _e -> :caught
  end

  defr function11(_arg, default \\ :default, :patterned_value) do
    default
  end

  defr(function12, do: :stuff)
  defr(function13(), do: :stuff)
  defr(function14(stuff), do: stuff)
  defr(function15(stuff, :patterned_value), do: stuff)
  defr(function16(stuff) when is_atom(stuff), do: stuff)

  defr infinite_recursive_function() do
    IO.inspect("Just 1 more level...")
    infinite_recursive_function()
  end

  defr(recursive_function1(n, sum \\ 0))

  defr(recursive_function1(0, sum), do: sum)

  defr recursive_function1(n, sum) when is_integer(n) and n > 0 do
    recursive_function1(n - 1, sum + n)
  end
end
