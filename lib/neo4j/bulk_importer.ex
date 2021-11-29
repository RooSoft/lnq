defmodule LnImport.Neo4j.BulkImporter do
  require Logger

  def cleanup conn do
    query = "MATCH (n) DETACH DELETE n"

    %Bolt.Sips.Response{} = Bolt.Sips.query!(conn, query)

    Logger.info("database cleanup done")

    conn
  end

  def import_graph conn, nodes_csv_filename, channels_csv_filename do
    conn
    |> bulk_import_nodes(nodes_csv_filename)
    |> bulk_import_channels(channels_csv_filename)
  end

  defp bulk_import_nodes conn, nodes_csv_filename do
    Logger.info("Bulk importing nodes in neo4j")

    insert_query = """
      LOAD CSV WITH HEADERS FROM 'file:///#{nodes_csv_filename}' AS node FIELDTERMINATOR ','
      CREATE (:node {
        pub_key: node.pub_key,
        alias: node.alias,
        color: node.color
      });
    """

    %Bolt.Sips.Response{stats: %{
      "nodes-created" => nb_nodes
    } } = Bolt.Sips.query!(conn, insert_query)

    Logger.info("#{nb_nodes} nodes added")

    conn
  end

  defp bulk_import_channels conn, channels_csv_filename do
    Logger.info("Bulk importing channels in neo4j")

    insert_query = """
      LOAD CSV WITH HEADERS FROM 'file:///#{channels_csv_filename}' AS edge FIELDTERMINATOR ','
      MATCH (n1:node {pub_key: edge.node1_pub})
      MATCH (n2:node {pub_key: edge.node2_pub})
      MERGE (n1)-[:CHANNEL {lnd_id: edge.channel_id, capacity: toInteger(edge.capacity), fee_rate: toInteger(edge.fee_rate)}]-(n2)
      RETURN count(n1);
    """

    %Bolt.Sips.Response{stats: %{
      "relationships-created" => nb_channels
    } } = Bolt.Sips.query!(conn, insert_query)

    Logger.info("#{nb_channels} channels created")

    conn
  end
end
