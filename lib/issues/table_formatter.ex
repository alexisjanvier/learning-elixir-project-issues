defmodule Issues.TableFormatter do
  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  def print_table_for_colums(rows, headers) do
    with data_by_colums = split_into_columns(rows, headers),
         column_widths  = widths_of(data_by_colums),
         format         = format_for(column_widths)
    do
      puts_one_line_in_columns(headers, format)
      IO.puts(separator(column_widths))
      puts_in_columns(data_by_colums, format)
    end
  end

  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows do
        printable(row[header])
      end
    end
  end

  @doc """
  Return a binary (sring) version of a parameter.
  ## Examples
    iex> Issues.TableFormatter.printable("a")
    "a"
    iex> Issues.TableFormatter.printable('b')
    "b"
    iex> Issues.TableFormatter.printable(3)
    "3"
  """
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_colums, format) do
    data_by_colums
    |>List.zip
    |>map(&Tuple.to_list/1)
    |>each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end
