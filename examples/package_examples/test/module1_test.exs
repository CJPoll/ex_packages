defmodule PackageExamples.Module1.Test do
  use ExUnit.Case
  use Packages, package: Package1

  @test_module PackageExamples.Module1

  require PackageExamples.Module1

  describe "function/0" do
    test "is compiled correctly when the function definition includes parens with no args" do
      assert @test_module.function0() == :ok
    end
  end

  describe "function1/0" do
    test "is compiled correctly when the function definition doesn't include parens" do
      assert @test_module.function1() == :stuff
    end
  end

  describe "function2/2" do
    test "works correctly with pattern-matching, including _underscored variables" do
      assert @test_module.function2(:hi, :ignored) == :with_hi
      assert @test_module.function2(:other, :ignored) == :without_hi
    end
  end

  describe "function3/2" do
    test "works with guard clauses, including _underscored variables" do
      assert @test_module.function3(1, :ignored) == :integer_arg
      assert @test_module.function3(nil, :ignored) == :nil_handled
      assert @test_module.function3(:other, :second_arg) == :second_arg
    end
  end

  describe "function4/2" do
    test "function-level rescue is correctly handled in function with arguments" do
      assert @test_module.function4(:ignored, :ignored) == :rescued
    end
  end

  describe "function5/2" do
    test "function-level rescue is correctly handled in function with no parens" do
      assert @test_module.function5() == :rescued
    end
  end

  describe "function6/2" do
    test "function-level rescue is correctly handled in function with parens but no args" do
      assert @test_module.function6() == :rescued
    end
  end

  describe "function7/2" do
    test "function-level rescue is correctly handled in function with guards" do
      assert @test_module.function7(:non_nil, :ignored) == :rescued
    end
  end

  describe "function8/2" do
    test "function-level catch is correctly handled in function with guards, _underscored vars, pattern-matched vars, and used variables" do
      assert @test_module.function8(:non_nil, :ignored, nil) == :caught1
      assert @test_module.function8(:ignored, :ignored, :non_nil) == :caught2
    end
  end

  describe "function9/2" do
    test "function-level catch is correctly handled in function with no parens and a function-level rescue clause" do
      assert @test_module.function9() == :caught
    end
  end

  describe "function10/2" do
    test "function-level rescue is correctly handled in function with no parens and a function-level catch clause" do
      assert @test_module.function10() == :rescued
    end
  end

  describe "function11/2" do
    test "works with default arguments in single-clause function" do
      assert @test_module.function11(:ignored, :patterned_value) == :default
      assert @test_module.function11(:ignored, :non_default, :patterned_value) == :non_default
    end
  end

  describe "function12/0" do
    test "works with single-line no parens" do
      assert @test_module.function12() == :stuff
    end
  end

  describe "function13/0" do
    test "works with single-line with parens" do
      assert @test_module.function13() == :stuff
    end
  end

  describe "function14/1" do
    test "works with single-line with argument" do
      assert @test_module.function14(:stuff) == :stuff
    end
  end

  describe "function15/2" do
    test "works with single-line with patterned argument" do
      assert @test_module.function15(:stuff, :patterned_value) == :stuff
    end
  end

  describe "function16/2" do
    test "works with single-line with guard" do
      assert @test_module.function16(:stuff) == :stuff
    end
  end

  describe "recursive_function1" do
    test "works when default argument is used in bodyless clause for multi-clause function" do
      assert @test_module.recursive_function1(3) == 6
      assert @test_module.recursive_function1(4) == 10
      assert @test_module.recursive_function1(4, 1) == 11
    end
  end
end
