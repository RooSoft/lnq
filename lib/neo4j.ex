defmodule LnImport.Neo4j do
  def get_connection do
    config = Application.get_env(:bolt_sips, Bolt)

    {:ok, _neo} = Bolt.Sips.start_link(config)

    Bolt.Sips.conn()
  end
end
