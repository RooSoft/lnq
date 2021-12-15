defmodule Lnq.Arguments do
  alias Lnq.Commands

  @dialyzer {:nowarn_function, parse: 1}
  def parse argv do
    get_definition()
    |> parse(argv)
    |> execute()
  end

  @dialyzer {:nowarn_function, execute: 1}
  defp execute {
    [:common_peers], %Optimus.ParseResult{
      args: %{
        node1_alias: node1_alias,
        node2_alias: node2_alias
      }
    }
  } do
    Commands.CommonPeers.execute(node1_alias, node2_alias)
  end

  defp execute {
    [:community_members], %Optimus.ParseResult{ args: %{ community_id: community_id } }
  } do
    Commands.CommunityMembers.execute(community_id)
  end

  defp execute {
    [:analyze],
    %Optimus.ParseResult{}
  } do
    Commands.Analyze.execute()
  end

  defp execute {
    [:convert],
    %Optimus.ParseResult{ args: args, options: options }
  } do
    Commands.Convert.execute(args, options)
  end

  defp execute {
    [:farthest_nodes],
    %Optimus.ParseResult{ args: %{ node_pub_key: node_pub_key } }
  } do
    Commands.FarthestNodes.execute(node_pub_key)
  end

  defp execute {
    [:cheapest_routes],
    %Optimus.ParseResult{args: %{
      route_count: route_count,
      node1_pub_key: node1_pub_key,
      node2_pub_key: node2_pub_key
    } }
  } do
    Commands.CheapestRoutes.execute(route_count, node1_pub_key, node2_pub_key)
  end

  defp execute {
    [:import],
    %Optimus.ParseResult{ options: options }
  } do
    Commands.Import.execute(options)
  end

  defp execute {
    [command],
    _
  } do
    IO.puts "Unknown command: #{command}"
  end

  defp execute %Optimus.ParseResult{} do
    get_definition()
    |> Optimus.Help.help([], 80)
    |> Enum.each(fn line ->
      IO.puts line
    end)
  end

  @dialyzer {:nowarn_function, get_definition: 0}
  defp get_definition do
    {:ok, vsn} = :application.get_key(:lnq, :vsn)

    case Optimus.new(
      name: "lnq",
      description: "Lightning Node Graph Query Tool",
      version: List.to_string(vsn),
      allow_unknown_args: false,
      parse_double_dash: true,
      subcommands: [
        convert: Commands.Convert.get_definition(),
        import: Commands.Import.get_definition(),
        analyze: Commands.Analyze.get_definition(),

        common_peers: Commands.CommonPeers.get_definition(),
        community_members: Commands.CommunityMembers.get_definition(),
        farthest_nodes: Commands.FarthestNodes.get_definition(),
        cheapest_routes: Commands.CheapestRoutes.get_definition()
      ]
    ) do
     { :ok, definition } -> definition
     { :error, e } -> raise e
    end
  end

  @dialyzer {:nowarn_function, parse: 2}
  defp parse definition, argv do
    Optimus.parse!(definition, argv)
  end
end
