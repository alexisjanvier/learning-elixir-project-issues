defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues,
      escript: escript_config(),
      version: "0.1.0",
      name: "Github Issues",
      source_url: "https://github.com/alexisjanvier/learning-elixir-project-issues",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:httpoison, "~> 1.7"},
      {:poison, "~> 4.0"},
      {:ex_doc, "~> 0.24.2"},
      {:earmark, "~> 1.4"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  # Compile application as an precompiled program from the cli
  defp escript_config do
    [
      main_module: Issues.CLI
    ]
  end
end
