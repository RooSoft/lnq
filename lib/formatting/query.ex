defmodule Lnq.Formatting.Query do
  alias TableRex.Table

  @peer_headers ["alias", "channel count", "total capacity", "community", "betweenness"]
  @peer_rates_headers ["alias", "peer pub key", "start channel id", "base fee", "fee rate"]
  @farthest_node_headers ["cost", "alias", "pub key", "community", "betweenness"]
  @cheapest_routes_headers ["index", "total cost", "costs", "pub keys"]

  def get_node_by_alias(node) do
    node
    |> display_node
  end

  def common_peers([]) do
    IO.puts("No data")
  end

  def common_peers(peers) do
    IO.puts("Found #{Enum.count(peers)} nodes")

    peers
    |> format_common_peers
    |> Table.new(@peer_headers)
    |> Table.put_column_meta(1..4, align: :right)
    |> Table.render!()
    |> IO.puts()
  end

  def common_peers_rates(peers) do
    IO.puts("Found #{Enum.count(peers)} channels")

    peers
    |> format_common_peers_rates
    |> Table.new(@peer_rates_headers)
    |> Table.put_column_meta(3..4, align: :right)
    |> Table.render!()
    |> IO.puts()
  end

  def farthest_nodes([]) do
    IO.puts("No data")
  end

  def farthest_nodes(nodes) do
    IO.puts("Found #{Enum.count(nodes)} nodes")

    nodes
    |> format_farthest_nodes
    |> Table.new(@farthest_node_headers)
    |> Table.put_column_meta(0, align: :right)
    |> Table.put_column_meta(3..4, align: :right)
    |> Table.render!()
    |> IO.puts()
  end

  def cheapest_routes(routes) do
    IO.puts("Found #{Enum.count(routes)} routes")

    routes
    |> format_cheapest_routes()
    |> Table.new(@cheapest_routes_headers)
    |> Table.render!()
    |> IO.puts()
  end

  defp display_node(node) do
    betweenness = Number.SI.number_to_si(node["betweenness"], unit: "", precision: 1)
    capacity = Number.SI.number_to_si(node["total_capacity"], unit: "", precision: 1)

    IO.puts("alias: #{node["alias"]}")
    IO.puts("pub_key: #{node["pub_key"]}")
    IO.puts("color: #{node["color"]}")
    IO.puts("channel_count: #{node["channel_count"]}")
    IO.puts("community: #{node["community"]}")
    IO.puts("betweenness: #{betweenness}")
    IO.puts("is_local: #{node["is_local"]}")
    IO.puts("capacity: #{capacity}")
  end

  defp format_common_peers(peers) do
    peers
    |> Enum.map(fn peer ->
      [
        peer["alias"],
        peer["channel_count"],
        peer["total_capacity"],
        peer["community"],
        peer["betweenness"]
      ]
    end)
  end

  defp format_common_peers_rates(peers) do
    peers
    |> Enum.map(fn peer ->
      [
        peer[:peer_alias],
        peer[:peer_pub_key],
        peer[:start_channel_id],
        peer[:base_fee],
        peer[:fee_rate]
      ]
    end)
  end

  defp format_farthest_nodes(nodes) do
    nodes
    |> Enum.map(fn node ->
      [
        node["totalCost"],
        node["targetNodeName"],
        node["targetNodePubKey"],
        node["targetNodeCommunity"],
        node["targetNodeBetweenness"]
      ]
    end)
  end

  defp format_cheapest_routes(routes) do
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
