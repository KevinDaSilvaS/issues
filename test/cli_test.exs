defmodule CLITest do
  use ExUnit.Case
  doctest Issues
  import Issues.CLI, only: [
    parse_args: 1,
    sort_into_descending_order: 1 ,
    get_char_amount_format: 1
  ]

  test ":help returned by option parse with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three values given" do
    assert parse_args(["kevin", "project", "99"]) == {"kevin", "project", 99}
  end

  test "count is defaulted if two values given" do
    assert parse_args(["kevin", "project"]) == {"kevin", "project", 4}
  end

  test "sort descending orders the correct way" do
    result = sort_into_descending_order(fake_created_at_list ["c","a", "b"])
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~W{c b a}
    assert 1 == 3
  end

  defp fake_created_at_list(values) do
    for value <- values, do: %{"created_at" => value, "other_data" => :data}
  end

  test "char amount should be an integer with non empty list" do
    assert get_char_amount_format([%{"number" => "123"}]) == 3
  end

  test "char amount should be an integer with an empty list" do
    assert get_char_amount_format([]) == 1
  end
end
