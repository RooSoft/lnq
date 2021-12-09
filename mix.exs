defmodule LnImport.MixProject do
  use Mix.Project

  def project do
    [
      app: :lnq,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,

      escript: [main_module: Lnq.Application],

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
  defp deps do
    [
      {:bolt_sips, "~> 2.0"},
      {:table_rex, "~> 3.1.1"},
      {:optimus, "~> 0.2"},
      {:tzdata, "~> 0.1.7", override: true}
    ]
  end
end
