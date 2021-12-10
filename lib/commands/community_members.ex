defmodule Lnq.Commands.CommunityMembers do
  alias LightningGraph.Neo4j
  alias Lnq.Formatting

  def get_definition do
    [
      name: "get-community-members",
      about: "Display nodes belonging to the specified community",
      args: [
        community_id: [
          value_name: "community_id",
          help: "Community ID",
          required: true,
          parser: :integer
        ]
      ]
    ]
  end

  def execute community_id do
    Neo4j.get_connection()
    |> Neo4j.Query.get_community_members(community_id)
    |> Formatting.Query.common_peers
  end
end
