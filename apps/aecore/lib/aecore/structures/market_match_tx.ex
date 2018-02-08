defmodule Aecore.Structures.MarketMatchTx do
  @moduledoc """
  Aecore structure of a travel market transaction.
  """

  alias Aecore.Structures.MarketMatchTx
  
  @type t :: %MarketMatchTx{
    from_acc: binary(),
    to_acc: binary(),

    offer_hash: binary(),
    demand_hash: binary(),

    capacity: non_neg_integer(),
    price: non_neg_integer()
  }

  @doc """
  Definition of Aecore MarketMatchTx structure
  """
  defstruct [:from_acc, :to_acc, :offer_hash, :demand_hash, :capacity, :price]
  use ExConstructor

  @spec create(binary(), binary(), binary(), binary(), non_neg_integer(), non_neg_integer()) :: {:ok, MarketMatchTx.t()}
  def create(from_acc, to_acc, offer_hash, demand_hash, capacity, price) do
    {:ok, %MarketMatchTx{
      from_acc: from_acc,
      to_acc: to_acc,
      offer_hash: offer_hash,
      demand_hash: demand_hash,
      capacity: capacity,
      price: price}}
  end

  @spec hash_tx(MarketMatchTx.t()) :: binary()
  def hash_tx(tx) do
    :crypto.hash(:sha256, :erlang.term_to_binary(tx))
  end

end
