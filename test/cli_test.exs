defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_into_descending_order: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "foo"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["one", "two", "12"]) == { "one", "two", 12}
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 5}
  end

  test "sort descending orders the correct way" do
    result = sort_into_descending_order(fake_create_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{c b a}
  end

  defp fake_create_at_list(values) do
    for value <- values,
    do: %{"created_at" => value, "other_data" => "grrr comprend pas tout ;("}
  end
end
