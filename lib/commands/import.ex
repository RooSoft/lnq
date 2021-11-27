defmodule LnImport.Commands.Import do
  @nodes_csv_filename "nodes.csv"
  @channels_csv_filename "channels.csv"

  alias LnImport.Neo4j

  def get_definition do
    [
      name: "import",
      about: "Bulk import Lightning Network nodes and channels to Neo4j",
      options: [
        nodes: [
          value_name: "NODES_CSV_FILENAME",
          help: "Nodes CSV file for Neo4j bulk import",
          short: "-n",
          long: "--nodes",
          parser: :string,
          required: false,
          default: @nodes_csv_filename
        ],
        channels: [
          value_name: "CHANNELS_CSV_FILENAME",
          help: "Channels CSV file for Neo4j bulk import",
          short: "-c",
          long: "--channels",
          parser: :string,
          required: false,
          default: @channels_csv_filename
        ]
      ]
    ]
  end

  def execute( %{ nodes: nodes_csv_filename, channels: channels_csv_filename } )do
    Neo4j.get_connection()
    |> Neo4j.BulkImporter.cleanup()
    |> Neo4j.BulkImporter.import_graph(nodes_csv_filename, channels_csv_filename)
  end
end
