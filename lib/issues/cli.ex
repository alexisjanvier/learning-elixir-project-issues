defmodule Issues.CLI do
  import Issues.TableFormatter, only: [ print_table_for_colums: 2]
  @default_count 5

  @moduledoc """
  Handle the command line parsing and the dispatch do
  the various functions that end up generating a
  table of the last _n_ issues in a github reporitory
  """

  def main(argv) do
    argv
    |>parse_args
    |>process
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is a github username, repository slug and (optionally)
  the number of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  # bad arg or --help
  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts """
    usage: Issues <user> <project> [ count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({ user, project, count }) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> print_table_for_colums(["number", "created_at", "title"])
  end

  defp decode_response({:ok, body}) do
    body
  end

  defp decode_response({:error, error}) do
    IO.puts "Error fetching from Github: #{error["message"]}"
    System.halt(2)
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def last(list_of_issues, count) do
    list_of_issues
    |>Enum.take(count)
    |>Enum.reverse()
  end

end
