defmodule ReverserTest do
  use ExUnit.Case
  doctest Reverser

  describe "reverse/1" do
    test "reverses binary" do
      sample = Enum.map(0..100_000, fn _ -> Enum.random(97..122) end)
      rev_sample = Enum.reverse(sample)
      assert Reverser.reverse(to_string(sample)) == to_string(rev_sample)
    end
  end

  describe "parser/1" do
    test "parses the correct data" do
      samples = %{
        "" => "",
        "test" => "test",
        "()" => "",
        ")" => ")",
        "((bar))" => "bar",
        "(1(bar)2)" => "2bar1",
        "(123)456" => "321456",
        "foo(bar)" => "foorab",
        "(bar)" => "rab",
        "foo(bar)blim" => "foorabblim",
        "foo(foo(bar))blim" => "foobaroofblim"
      }

      for {sample, expect} <- samples do
        assert Reverser.parser(sample) == {:ok, expect}
      end
    end

    test "fails on unclosed parentheses" do
      samples = [
        "foo(",
        "foo((())",
        "(",
        "sdfdsf(dsf(dfs((fds)df)"
      ]

      for sample <- samples do
        assert Reverser.parser(sample) == {:error, :unclosed_parentheses}
      end
    end
  end
end
