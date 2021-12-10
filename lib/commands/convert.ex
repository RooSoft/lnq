defmodule Lnq.Commands.Convert do
  @neo4j_import_folder "~/neo4j/import/"

  @nodes_csv_filename "nodes.csv"
  @channels_csv_filename "channels.csv"

  @nodes_csv_file_path "#{@neo4j_import_folder}#{@nodes_csv_filename}"
  @channels_csv_file_path "#{@neo4j_import_folder}#{@channels_csv_filename}"

  alias LightningGraph.Lnd.FileConverter

  def get_definition do
    [
      name: "convert",
      about: "Converts LND DescribeGraph's JSON to CSV",
      options: [
        nodes: [
          value_name: "NODES_CSV_FILENAME",
          help: "Nodes CSV file for Neo4j bulk import",
          short: "-n",
          long: "--nodes",
          parser: :string,
          required: false,
          default: @nodes_csv_file_path
        ],
        channels: [
          value_name: "CHANNELS_CSV_FILENAME",
          help: "Channels CSV file for Neo4j bulk import",
          short: "-c",
          long: "--channels",
          parser: :string,
          required: false,
          default: @channels_csv_file_path
        ]
      ],
      args: [
        json_filename: [
          value_name: "JSON_FILENAME",
          help: "LND DescribeGraph's JSON filename",
          required: true,
          parser: :string
        ]
      ]
    ]
  end

  def execute(
    %{ json_filename: json_filename },
    %{ nodes: nodes_csv_filename, channels: channels_csv_filename }
  )do
    json_filename
    |> FileConverter.convert(nodes_csv_filename, channels_csv_filename)
  end
end
