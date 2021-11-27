defmodule LnImport.Formatting.Query do
  alias TableRex.Table

  @peer_headers ["alias", "channel count", "total capacity", "community", "betweenness"]
  @farthest_node_headers ["cost", "alias", "pub key", "community", "betweenness"]

  def common_peers [] do
    IO.puts "No data"
  end

  def common_peers peers do
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

  def format_common_peers peers do
    peers
    |> Enum.map(fn peer ->
      [peer["alias"], peer["channel_count"], peer["total_capacity"], peer["community"], peer["betweenness"]]
    end)
  end

  def format_farthest_nodes nodes do
    nodes
    |> Enum.map(fn node ->
      [node["totalCost"], node["targetNodeName"], node["targetNodePubKey"], node["targetNodeCommunity"], node["targetNodeBetweenness"]]
    end)
  end
end
