defmodule Lnq.Commands.Analyze do
  alias LightningGraph.Neo4j

  def get_definition do
    [
      name: "analyze",
      about: "Execute data analysis on Neo4j Lightning Network database"
    ]
  end

  def execute()do
    Neo4j.get_connection()
    |> Neo4j.DataAnalyzer.delete_graph()
    |> Neo4j.DataAnalyzer.create_graph()
    |> Neo4j.DataAnalyzer.add_community_ids()
    |> Neo4j.DataAnalyzer.add_betweenness_score()
    |> Neo4j.Aggregate.add_channel_count()
    |> Neo4j.Aggregate.add_channel_capacity()
  end
end
