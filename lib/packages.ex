defmodule Packages do
  @package_variable_name :__package_name__

  @type package :: atom

  defmacro __using__(opts) do
    package_name =
      opts
      |> Keyword.get(:package, nil)
      # We need to expand the package AST since `Package1` gets passed in like this:
      # {:__aliases__, [counter: {PackageExamples.Module1, 2}, line: 3], [:Package1]}
      |> Macro.expand(__CALLER__)

    # We don't want the package to be nil
    # We want the package to be an atom
    if is_nil(package_name) or not is_atom(package_name) do
      raise """


      \t#{inspect(__CALLER__.module)} has an invalid package name. This happens when:
      \t  1. The package is `nil` (probably wasn't defined)
      \t  2. The package is not an atom

      \tUsage:

      \t  defmodule #{inspect(__CALLER__.module)} do
      \t    use Packages, package: MyPackage
      \t  end
      """
    end

    Module.register_attribute(__CALLER__.module, :protecteds, accumulate: true)
    Module.put_attribute(__CALLER__.module, @package_variable_name, package_name)

    quote do
      import unquote(__MODULE__)
      def __package__, do: unquote(package_name)
    end
  end

  defmacro defr({macro_name, context, args}) do
    ast = {protected_name(macro_name), context, args}

    ast =
      quote do
        @doc false
        def(unquote(ast))
      end

    arity = length(args)

    if macro_name == :function8 do
      IO.inspect(arity, label: "Function 8 Arity")
      IO.inspect(args, label: "Function 8 Args")
    end

    macro_ast =
      if Module.get_attribute(__CALLER__.module, macro_attribute_key(macro_name, arity)) do
        nil
      else
        Module.put_attribute(__CALLER__.module, macro_attribute_key(macro_name, arity), true)
        macro_ast(macro_name, arity)
      end

    quote do
      unquote(macro_ast)
      unquote(ast)
    end
  end

  defmacro defr({:when, meta, [{macro_name, meta2, args}, guards]}, blocks) do
    ast = {:when, meta, [{protected_name(macro_name), meta2, args}, guards]}

    args =
      Enum.map(args, fn
        {name, meta, context} ->
          name =
            name
            |> Atom.to_string()
            |> String.replace_leading("_", "")
            # This atom creation is safe, as it's taking a finite number of
            # programmer-defined inputs.
            |> String.to_atom()

          {name, meta, context}

        other ->
          other
      end)

    ast =
      quote do
        @doc false
        def(unquote(ast), unquote(blocks))
      end

    arity = length(args)

    if macro_name == :function8 do
      IO.inspect(arity, label: "Function 8 Arity")
      IO.inspect(args, label: "Function 8 Args")
    end

    macro_ast =
      if Module.get_attribute(__CALLER__.module, macro_attribute_key(macro_name, arity)) do
        []
      else
        Module.put_attribute(__CALLER__.module, macro_attribute_key(macro_name, arity), true)
        macro_ast(macro_name, arity)
      end

    quote do
      unquote(macro_ast)
      unquote(ast)
    end
  end

  defmacro defr({macro_name, meta, args}, blocks) do
    args =
      if args do
        args
      else
        []
      end

    ast = {protected_name(macro_name), meta, args}

    args =
      Enum.map(args, fn
        {name, meta, context} ->
          name =
            name
            |> Atom.to_string()
            |> String.replace_leading("_", "")
            # This atom creation is safe, as it's taking a finite number of
            # programmer-defined inputs.
            |> String.to_atom()

          {name, meta, context}

        literal ->
          literal
      end)

    ast =
      quote do
        @doc false
        def(unquote(ast), unquote(blocks))
      end

    arity = length(args)

    macro_ast =
      if Module.get_attribute(__CALLER__.module, macro_attribute_key(macro_name, arity)) do
        []
      else
        Module.put_attribute(__CALLER__.module, macro_attribute_key(macro_name, arity), true)
        macro_ast(macro_name, arity)
      end

    quote do
      unquote(macro_ast)
      unquote(ast)
    end
  end

  @spec package_for(module) :: package | nil
  def package_for(module) do
    if function_exported?(module, :__package__, 0) do
      module.__package__()
    end
  end

  # Private Functions

  defp args_ast(0) do
    []
  end

  defp args_ast(arity) do
    for n <- 1..arity do
      {:"arg#{n}", [], nil}
    end
  end

  # Not technically private, but not part of the public API either
  @doc false
  def __dispatch__(calling_module, destination_module, function_name, args) do
    cond do
      is_nil(calling_module) ->
        # We're running this in IEx, and it's not during `recompile`
        :ok

      calling_module == destination_module ->
        # A module always has permission to call its own functions
        :ok

      true ->
        # Only called during compilation.
        unless same_package?(calling_module, destination_module) do
          raise error_message(
                  calling_module,
                  destination_module,
                  function_name,
                  args
                )
        end
    end

    quote do
      unquote(destination_module).unquote(protected_name(function_name))(unquote_splicing(args))
    end
  end

  defp error_message(calling_module, destination_module, function_name, args) do
    # The empty lines are deliberate - please don't remove
    """


    \t#{inspect(calling_module)} is trying to call #{inspect(destination_module)}.#{function_name}/#{
      length(args)
    },
    \twhich is a protected function. This function can be called from IEx, but
    \tnot from outside package #{inspect(destination_module.__package__())}
    """
  end

  defp macro_ast(macro_name, 0) do
    quote do
      defmacro unquote(macro_name)() do
        unquote(__MODULE__).__dispatch__(
          __CALLER__.module,
          __MODULE__,
          unquote(macro_name),
          []
        )
      end
    end
  end

  defp macro_ast(macro_name, arity) do
    args_ast = args_ast(arity)

    quote do
      defmacro unquote(macro_name)(unquote_splicing(args_ast)) do
        unquote(__MODULE__).__dispatch__(
          __CALLER__.module,
          __MODULE__,
          unquote(macro_name),
          unquote(args_ast)
        )
      end
    end
  end

  defp protected_name(name) do
    :"__#{name}_protected__"
  end

  defp macro_attribute_key(function, arity) do
    :"protected_#{function}_#{arity}"
  end

  defp same_package?(calling_module, destination_module) do
    # Only called during compilation
    #
    # destination_module will have been compiled already, so we can just call
    # the __package__() function on it.
    #
    # calling_module is currently being compiled, so its __package__() function
    # is undefined. We need to get its package name from Module storage and
    # expand it.
    calling_package =
      if Module.has_attribute?(calling_module, @package_variable_name) do
        calling_module
        |> Module.get_attribute(@package_variable_name)
        |> Macro.expand(__ENV__)
      end

    destination_package = destination_module.__package__()

    calling_package == destination_package
  end
end
