defmodule Issues.CLI do
  @default_count 4
#158
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
    IO.puts "U -> #{user}, P -> #{project}, C -> #{count}"
  end
end
