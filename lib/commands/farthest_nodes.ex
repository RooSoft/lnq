defmodule Lnq.Commands.FarthestNodes do
  alias LnImport.Neo4j
  alias Lnq.Formatting

  def get_definition do
    [
      name: "get-farthest-nodes",
      about: "Display nodes that must do the most hops to reach a given node",
      args: [
        node_pub_key: [
          value_name: "PUBKEY",
          help: "Node's pub key",
          required: true,
          parser: :string
        ]
      ]
    ]
  end

  def execute node_pub_key do
    Neo4j.get_connection()
    |> Neo4j.Query.get_longest_paths(node_pub_key)
    |> Formatting.Query.farthest_nodes
  end
end
