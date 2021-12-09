defmodule LnImport.Neo4j.Aggregate do
  require Logger

  def add_channel_count conn do
    Logger.info("Adding channel count to all nodes")

    query = """
    MATCH (n:node)-[c:CHANNEL]-()
    WITH n, count(c) as channel_count
    SET n.channel_count = channel_count/2
    """

    %Bolt.Sips.Response{stats: %{"properties-set" => nb_nodes}} = Bolt.Sips.query!(conn, query)

    Logger.info("Updated channel count on #{nb_nodes} nodes")

    conn
  end

  def add_channel_capacity conn do
    Logger.info("Adding channel total capacities to all nodes")

    query = """
    MATCH (n:node)-[c:CHANNEL]-(:node)
    WITH n, sum(c.capacity) as node_capacity
    SET n.total_capacity = node_capacity/2
    """

    %Bolt.Sips.Response{stats: %{"properties-set" => nb_nodes}} = Bolt.Sips.query!(conn, query)

    Logger.info("Adding channel total capacities on #{nb_nodes} nodes")

    conn
  end
end
