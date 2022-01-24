defmodule Lnq.Commands.NodeInfo do
  alias LightningGraph.Neo4j
  alias Lnq.Formatting

  def get_definition do
    [
      name: "get-node-info",
      about: "Display basic node info",
      args: [
        node_alias: [
          value_name: "ALIAS",
          help: "Node's alias",
          required: true,
          parser: :string
        ]
      ]
    ]
  end

  def execute(node_alias) do
    Neo4j.get_connection()
    |> Neo4j.Query.get_node_by_alias(node_alias)
    |> Formatting.Query.get_node_by_alias()
  end
end
