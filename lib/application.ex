defmodule LnImport.Application do
  require Logger

  alias LnImport.Arguments

  @dialyzer {:nowarn_function, main: 1}
  def main(args) do
    Arguments.parse(args)
  end
end
