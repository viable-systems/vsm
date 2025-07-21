defmodule VSM.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      # Shared dependencies with version overrides
      {:jason, "~> 1.4", override: true},
      {:telemetry, "~> 1.2", override: true},
      {:telemetry_metrics, "~> 1.0", override: true},
      {:telemetry_poller, "~> 1.1", override: true},
      {:phoenix, "~> 1.7", override: true},
      {:phoenix_html, "~> 4.0", override: true},
      {:plug_cowboy, "~> 2.6", override: true},
      {:stream_data, "~> 1.1", override: true, only: [:dev, :test]}
    ]
  end
end
