defmodule Issues.GithubIssues do
  @user_agent [ {"User-agent", "Elixir kevin.kds80@gmail.com"} ]
  @github_url Application.get_env :issues, :github_url

  import HTTPoison, only: [ get: 2 ]
  import Poison.Parser, only: [ parse!: 1 ]

  def fetch(user, project) do
    issues_url(user, project)
    |> get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error(),
      body |> parse!()
    }
  end

  def check_for_error(200), do: :ok
  def check_for_error(_), do: :error
end
