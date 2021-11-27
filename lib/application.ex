defmodule LnImport.Application do
  require Logger

  alias LnImport.Arguments

  def main(args) do
    Arguments.parse(args)
  end
end
