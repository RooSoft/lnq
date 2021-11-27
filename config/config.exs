use Mix.Config

config :bolt_sips, Bolt,
  url: "bolt://localhost:7687",
  basic_auth: [username: "neo4j", password: "test"],
  ssl: false,
  timeout: 300_000
