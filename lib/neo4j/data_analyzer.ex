defmodule LnImport.Neo4j.DataAnalyzer do
  require Logger

  @graph_name "myGraph"

  def delete_graph conn do
    Logger.info("Destroying previous Data Analysis graph")

    query = """
      CALL gds.graph.drop('#{@graph_name}')
    """

    %Bolt.Sips.Response{} = Bolt.Sips.query!(conn, query)

    conn
  end

  def create_graph conn do
    Logger.info("Creating Data Analysis graph")

    query = """
    CALL gds.graph.create('#{@graph_name}', 'node',
      { CHANNEL: {orientation: 'UNDIRECTED'} },
      { relationshipProperties: ['capacity'] }
    )
    """

    %Bolt.Sips.Response{} = Bolt.Sips.query!(conn, query)

    conn
  end

  def add_community_ids conn do
    Logger.info("Adding community ids to nodes")

    query = """
    CALL gds.louvain.write('#{@graph_name}', {
      writeProperty: 'community',
      relationshipWeightProperty: 'capacity'
    })
    """

    %Bolt.Sips.Response{} = Bolt.Sips.query!(conn, query)

    conn
  end

  def add_betweenness_score conn do
    Logger.info("Adding betweenness scores to nodes")

    query = """
    CALL gds.betweenness.write('#{@graph_name}', { writeProperty: 'betweenness' })
    YIELD centralityDistribution, nodePropertiesWritten
    RETURN
      centralityDistribution.min AS minimumScore,
      centralityDistribution.mean AS meanScore,
      nodePropertiesWritten
    """

    %Bolt.Sips.Response{} = Bolt.Sips.query!(conn, query)

    conn
  end
end
