defmodule Issues.CLI do
  import Issues.GithubIssues, only: [fetch: 2]
  @default_count 4

  def run(argv) do
    parse_args argv
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
    |> process()
  end

  def args_to_internal_representation([user, project, count]) do
    { user, project, String.to_integer(count) }
  end
  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end
  def args_to_internal_representation(_), do: :help

  def process(:help) do
    IO.puts """
      usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt
  end
  def process({user, project, count}) do
    fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> format_output()
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, error}) do
    IO.puts "Error fetching from github #{error["message"]}"
    System.halt 2
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def last(list, count) do
    list |> Enum.take(count) |> Enum.reverse()
  end

  def format_output(issues) do
    amount_chars_format = get_char_amount_format issues
    spaces = String.duplicate(" ", amount_chars_format-1)
    dashes = String.duplicate("-", amount_chars_format-1)

    IO.puts " ##{spaces}| created_at           | title"
    IO.puts "--#{dashes}+----------------------+-----------------------------------------"
    Enum.map(issues, fn issue ->
      IO.puts "#{issue["number"]} | #{issue["created_at"]} | #{issue["title"]} "
    end)
  end

  def get_char_amount_format(issues) do
    List.last(issues)["number"]
    |> to_string()
    |> String.length()
  end
end
