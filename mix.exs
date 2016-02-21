defmodule Fitbit.Mixfile do
  use Mix.Project

  def project do
    [
      app: :fitbit,
      version: "0.1.0",
      elixir: "~> 1.2",
      description: "A Fitbit Library for Elixir",
      package: package,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(Mix.env),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test]
    ]
  end

  def application do
    [
      applications: [
        :httpoison,
        :tzdata
      ],
      mod: {Fitbit, []}
    ]
  end

  defp deps(:dev) do
    deps(:prod)
  end

  defp deps(:test) do
    deps(:dev)
  end

  defp deps(:prod) do
    [
      {:excoveralls, "~> 0.4", only: :test},
      {:httpoison, "~> 0.8.0" },
      {:hackney, "~> 1.4.8" }, # not included in hex version of httpoison :(
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:poison, "~> 1.5"},
      {:timex, "~> 1.0"}
    ]
  end

  def package do
    [
      maintainers: ["Tres Trantham"],
      licenses: ["New BSD"],
      links: %{"GitHub" => "https://github.com/trestrantham/fitbit"}
    ]
  end
end
