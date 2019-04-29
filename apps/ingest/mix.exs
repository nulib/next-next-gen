defmodule Ingest.MixProject do
  use Mix.Project

  def project do
    [
      app: :ingest,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      env: [storage_bucket: :undefined],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.0.0"},
      {:ex_aws_s3, "~> 2.0.0"},
      {:httpoison, "~> 1.5"},
      {:nimble_csv, "~> 0.6.0"},
      {:poison, "~> 4.0.1"},
      {:sweet_xml, "~> 0.6"},
      {:meadow_data, in_umbrella: true}
    ]
  end
end
