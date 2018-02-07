defmodule Aehttpserver.Web.MarketController do
  use Aehttpserver.Web, :controller

  alias Aecore.Chain.Worker, as: Chain
  alias Aeutil.Serialization
  alias Aecore.Structures.TravelMarketTx

  def market(conn, params) do
    chain = Chain.longest_blocks_chain()
    chain_txs = chain |> Enum.flat_map(fn block -> block.txs end)
    market_txs = chain_txs |> Enum.filter(fn tx ->
      case tx.data do
        %TravelMarketTx{} ->
         true
        _ ->
          false
      end
    end)
    market_txs_json = market_txs |> Enum.map(fn tx -> Serialization.tx(tx, :serialize) end)
    json conn, market_txs_json
  end

end
