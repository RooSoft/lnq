defmodule LnImport.FileConverter do
  require Logger

  def convert lightning_network_graph_filename, nodes_csv_file_path, channels_csv_file_path do
    lightning_network_graph_filename
    |> extract_nodes(nodes_csv_file_path)
    |> extract_channels(channels_csv_file_path)

    Logger.info("done")
  end

  defp extract_nodes json_filename, output_filename do
    Logger.info("Creating #{output_filename}")

    select = "[\"pub_key\", \"alias\", \"color\"]"
    filter = "(.nodes[] | select(.last_update > 0) | [.pub_key, .alias, .color])"
    jq_query = "#{select}, #{filter} | @csv"

    {_output, _code} = execute_command jq_query, json_filename, output_filename

    json_filename
  end

  defp extract_channels json_filename, output_filename do
    Logger.info("Creating #{output_filename}")

    select = "[\"channel_id\", \"node1_pub\", \"node2_pub\", \"capacity\", \"fee_rate\"]"
    filter1 = "(.edges[] | select(.last_update > 0) | [.channel_id, .node1_pub, .node2_pub, (.capacity|tonumber), (.node1_policy.fee_rate_milli_msat // '0'|tonumber)])"
    filter2 = "(.edges[] | select(.last_update > 0) | [.channel_id, .node2_pub, .node1_pub, (.capacity|tonumber), (.node2_policy.fee_rate_milli_msat // '0'|tonumber)])"
    filter = "#{filter1}, #{filter2}"
    jq_query = "#{select}, #{filter} | @csv"

    {_output, _code} = execute_command jq_query, json_filename, output_filename

    json_filename
  end

  defp execute_command jq_query, input_file, output_filename do
    jq_command = "jq -r '#{jq_query}' #{input_file} > #{output_filename}"

    System.cmd("bash", ["-c", jq_command])
  end
end
