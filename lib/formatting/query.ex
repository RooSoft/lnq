defmodule LnImport.Formatting.Query do
  alias TableRex.Table

  @peer_headers ["alias", "channel count", "total capacity", "community", "betweenness"]
  @farthest_node_headers ["cost", "alias", "pub key", "community", "betweenness"]
  @cheapest_routes_headers ["index", "total cost", "costs", "pub keys"]

  def common_peers [] do
    IO.puts "No data"
  end

  def common_peers peers do
    IO.puts "Found #{Enum.count(peers)} nodes"

    peers
    |> format_common_peers
    |> Table.new(@peer_headers)
    |> Table.put_column_meta(1..4, align: :right)
    |> Table.render!
    |> IO.puts
  end

  def farthest_nodes [] do
    IO.puts "No data"
  end

  def farthest_nodes nodes do
    IO.puts "Found #{Enum.count(nodes)} nodes"

    nodes
    |> format_farthest_nodes
    |> Table.new(@farthest_node_headers)
    |> Table.put_column_meta(0, align: :right)
    |> Table.put_column_meta(3..4, align: :right)
    |> Table.render!
    |> IO.puts
  end

  def cheapest_routes routes do
    IO.puts "Found #{Enum.count(routes)} routes"

    routes
    |> format_cheapest_routes()
    |> Table.new(@cheapest_routes_headers)
    |> Table.render!
    |> IO.puts
  end

  defp format_common_peers peers do
    peers
    |> Enum.map(fn peer ->
      [peer["alias"], peer["channel_count"], peer["total_capacity"], peer["community"], peer["betweenness"]]
    end)
  end

  defp format_farthest_nodes nodes do
    nodes
    |> Enum.map(fn node ->
      [node["totalCost"], node["targetNodeName"], node["targetNodePubKey"], node["targetNodeCommunity"], node["targetNodeBetweenness"]]
    end)
  end

  defp format_cheapest_routes routes do
    routes
    |> Enum.map(fn node ->
      [
        node.index,
        node.total_cost,
        node.costs |> Enum.join(", "),
        node.pub_keys |> Enum.join(", ")
      ]
    end)
  end
end
