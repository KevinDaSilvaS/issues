defmodule CLITest do
  use ExUnit.Case
  doctest Issues
  import Issues.CLI, only: [ parse_args: 1 ]

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
end
