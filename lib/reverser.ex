defmodule Reverser do
  @moduledoc """
  Documentation for Reverser.
  """

  @doc """
    Reverses binary.

    ## Examples

        iex> Reverser.reverse("abcdefg")
        "gfedcba"

  """
  def reverse(bin) when is_binary(bin) do
    # String.reverse(bin)
    size = bit_size(bin)
    <<data::little-integer-size(size)>> = bin
    <<data::big-integer-size(size)>>
  end

  @doc """
    The entry point of a binary parser. It parses a binary,
    removes the parentheses and reverses the word inside.
  """
  def parser(str) when is_binary(str) do
    parsed =
      str
      |> find_open()
      |> find_close_and_recombine()

    case parsed do
      {:ok, str_parts} ->
        {:ok, to_string(str_parts)}

      {:error, _} = err ->
        err
    end
  end

  defp find_open(str) do
    str
    |> :string.split("(", :leading)
  end

  defp find_close_and_recombine([str]), do: {:ok, str}

  defp find_close_and_recombine([head, tail]) do
    tail
    |> :string.split(")", :trailing)
    |> recombine_str(head)
  end

  defp recombine_str([inside, outside], head) do
    case parser(inside) do
      {:ok, str} ->
        {:ok, [head, reverse(str), outside]}

      {:error, _} = err ->
        err
    end
  end

  defp recombine_str(_, _), do: {:error, :unclosed_parentheses}

  @doc """
    The entry point for the escript.
  """
  def main(args) do
    str = get_str_to_parse!(args)
    {:ok, parsed} = parser(str)

    IO.puts("Source string: #{str}")
    IO.puts("Parsed string: #{parsed}")
  end

  defp get_str_to_parse!(args) do
    case args do
      [arg1 | _] ->
        arg1

      _ ->
        IO.puts("Please, give me a string as an argument\n")
        raise ArgumentError, message: "The argument value is invalid"
    end
  end
end
