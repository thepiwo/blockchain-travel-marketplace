defmodule Aehttpserver.Web.ChainStateController do
  use Aehttpserver.Web, :controller

  alias Aecore.Chain.Worker, as: Chain
  alias Aeutil.Serialization
  alias Aecore.Chain.BlockValidation
  alias Aecore.Structures.Block
  alias Aecore.Peers.Sync

  def chainstate(conn, params) do
    chain_state_json = Chain.chain_state() |> Serialization.chain_state(:serialize)
    json conn, chain_state_json
  end

end
