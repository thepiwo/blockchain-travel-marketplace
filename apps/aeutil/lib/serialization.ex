defmodule Aeutil.Serialization do
  @moduledoc """
  Utility module for serialization
  """

  alias Aecore.Structures.Block
  alias Aecore.Structures.Header
  alias Aecore.Structures.SpendTx
  alias Aecore.Structures.SignedTx
  alias Aecore.Structures.TravelMarketTx
  alias Aecore.Structures.MarketMatchTx


  def chain_state(chain_state, direction) do
   for {acc, state} <- chain_state do
    %{hex_binary(acc, direction) => state}
   end
  end

  @spec block(Block.t(), :serialize | :deserialize) :: Block.t()
  def block(block, direction) do
    new_header = %{block.header |
      chain_state_hash: hex_binary(block.header.chain_state_hash, direction),
      prev_hash: hex_binary(block.header.prev_hash, direction),
      txs_hash: hex_binary(block.header.txs_hash, direction)}
    new_txs = Enum.map(block.txs, fn(tx) -> tx(tx, direction) end)
    Block.new(%{block | header: Header.new(new_header), txs: new_txs})
  end

  @spec tx(SignedTx.t(), :serialize | :deserialize) :: SignedTx.t()
  def tx(tx, direction) do
    data = case tx.data do
      %SpendTx{} ->
        new_data = %{tx.data |
          from_acc: hex_binary(tx.data.from_acc, direction),
          to_acc: hex_binary(tx.data.to_acc, direction)}
        SpendTx.new(new_data)
      %MarketMatchTx{} ->
        new_data = %{tx.data |
          from_acc: hex_binary(tx.data.from_acc, direction),
          to_acc: hex_binary(tx.data.to_acc, direction),
          offer_hash: hex_binary(tx.data.offer_hash, direction),
          demand_hash: hex_binary(tx.data.demand_hash, direction)}
        MarketMatchTx.new(new_data)
      %TravelMarketTx{} ->
        new_data = %{tx.data |
          from_acc: hex_binary(tx.data.from_acc, direction)
        }
        TravelMarketTx.new(new_data)
    end

    new_signature = hex_binary(tx.signature, direction)
    %SignedTx{data: data, signature: new_signature}
  end

  @spec hex_binary(binary(), :serialize | :deserialize) :: binary()
  def hex_binary(data, direction) do
    if data != nil do
      case(direction) do
        :serialize ->
          Base.encode16(data)
        :deserialize ->
          Base.decode16!(data)
      end
    else
      nil
    end
  end

  def merkle_proof(proof, acc) when is_tuple(proof) do
    proof
    |> Tuple.to_list()
    |> merkle_proof(acc)
  end

  def merkle_proof([], acc), do: acc

  def merkle_proof([head | tail], acc) do
    if is_tuple(head) do
      merkle_proof(Tuple.to_list(head), acc)
    else
      acc = [hex_binary(head, :serialize)| acc]
      merkle_proof(tail, acc)
    end
  end
end
