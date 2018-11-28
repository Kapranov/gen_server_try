defmodule GenServerTry.MixProject do
  use Mix.Project

  def project do
    [
      app: :gen_server_try,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: applications(Mix.env),
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10.1", only: :test},
      {:ex_unit_notifier, "~> 0.1.4", only: :test},
      {:mix_test_watch, "~> 0.9.0", only: :dev, runtime: false},
      {:remix, "~> 0.0.2", only: :dev},
      {:ex_doc, "~> 0.19.1"}
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger]
end
