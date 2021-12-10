defmodule Lnq.Commands.CommonPeers do
  alias LightningGraph.Neo4j
  alias Lnq.Formatting

  def get_definition do
    [
      name: "get-common-peers",
      about: "Display common peers between two nodes",
      args: [
        node1_alias: [
          value_name: "NODE1",
          help: "First node's alias",
          required: true,
          parser: :string
        ],
        node2_alias: [
          value_name: "NODE2",
          help: "Second node's alias",
          required: true,
          parser: :string
        ]
      ]
    ]
  end

  def execute node1_alias, node2_alias do
    Neo4j.get_connection()
    |> Neo4j.Query.get_common_peers(node1_alias, node2_alias)
    |> Formatting.Query.common_peers
  end
end
