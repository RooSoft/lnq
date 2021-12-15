defmodule Lnq.Commands.CheapestRoutes do
  alias LightningGraph.Neo4j
  alias Lnq.Formatting

  @graph_name "myGraph"

  @spec get_definition :: [
          {:about, <<_::488>>} | {:args, [{any, any}, ...]} | {:name, <<_::152>>},
          ...
        ]
  def get_definition do
    [
      name: "get-cheapest-routes",
      about: "Display the cheapest routes in terms of ppm between two nodes",
      args: [
        route_count: [
          value_name: "ROUTE_COUNT",
          help: "Number of routes to return",
          required: true,
          parser: :integer
        ],
        node1_pub_key: [
          value_name: "NODE1_PUBKEY",
          help: "Node1's pub key",
          required: true,
          parser: :string
        ],
        node2_pub_key: [
          value_name: "NODE2_PUBKEY",
          help: "Node2's pub key",
          required: true,
          parser: :string
        ]
      ]
    ]
  end

  def execute route_count, node1_pub_key, node2_pub_key do
    Neo4j.get_connection()
    |> Neo4j.Query.get_cheapest_routes(@graph_name, route_count, node1_pub_key, node2_pub_key)
    |> Formatting.Query.cheapest_routes
  end
end
