defmodule Aehttpserver.Web.Notify do
  alias Aeutil.Serialization
  alias Aecore.Structures.SpendTx

  def broadcast_new_transaction_in_the_pool(tx) do
    if Map.has_key?(tx.data, :from_acc) && tx.data.from_acc != nil do
      Aehttpserver.Web.Endpoint.broadcast!("room:notifications","new_tx:" <> Base.encode16(tx.data.from_acc), %{"body" => Serialization.tx(tx, :serialize)})
    end
    if Map.has_key?(tx.data, :to_acc) && tx.data.to_acc != nil do
      Aehttpserver.Web.Endpoint.broadcast!("room:notifications","new_tx:" <> Base.encode16(tx.data.to_acc), %{"body" => Serialization.tx(tx, :serialize)})
    end
    Aehttpserver.Web.Endpoint.broadcast!("room:notifications", "new_transaction_in_the_pool", %{"body" => Serialization.tx(tx, :serialize)})
  end

  def broadcast_new_block_added_to_chain_and_new_mined_tx(block) do
    Enum.each(block.txs, fn(tx) ->
      Aehttpserver.Web.Endpoint.broadcast!("room:notifications", "new_mined_tx_everyone", %{"body" => Serialization.tx(tx, :serialize)})
      if Map.has_key?(tx.data, :from_acc) && tx.data.from_acc != nil do
        Aehttpserver.Web.Endpoint.broadcast!("room:notifications", "new_mined_tx:" <> Base.encode16(tx.data.from_acc), %{"body" => Serialization.tx(tx, :serialize)})
      end
      if Map.has_key?(tx.data, :to_acc) &&  tx.data.to_acc != nil do
        Aehttpserver.Web.Endpoint.broadcast!("room:notifications","new_mined_tx:" <> Base.encode16(tx.data.to_acc), %{"body" => Serialization.tx(tx, :serialize)})
      end
    end)
    Aehttpserver.Web.Endpoint.broadcast!("room:notifications", "new_block_added_to_chain", %{"body" => Serialization.block(block, :serialize)})
  end
end