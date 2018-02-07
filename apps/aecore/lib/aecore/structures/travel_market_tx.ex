defmodule Aecore.Structures.TravelMarketTx do
  @moduledoc """
  Aecore structure of a travel market transaction.
  """

  alias Aecore.Structures.TravelMarketTx

  @type market_type :: :offer | :demand

  @type t :: %TravelMarketTx{
    from_acc: binary(),
    nonce: non_neg_integer(),
    fee: non_neg_integer(),

    price: non_neg_integer(),
    type: market_type(),
    date: non_neg_integer(),
    capacity: non_neg_integer(),
    travel_time: non_neg_integer(),
    ttl: non_neg_integer(),

    from: String.t(),
    to: String.t()
  }

  @doc """
  Definition of Aecore TravelMarketTx structure
  """
  defstruct [:from_acc, :nonce, :fee, :price, :type, :date, :capacity, :travel_time, :ttl, :from, :to]
  use ExConstructor

  @spec create(binary(), non_neg_integer(), non_neg_integer(), non_neg_integer(), market_type(), non_neg_integer(), non_neg_integer(), non_neg_integer(), non_neg_integer(), String.t(), String.t()) :: {:ok, TravelMarketTx.t()}
  def create(from_acc, nonce, fee, price, type, date, capacity, travel_time, ttl, from, to) do
    {:ok, %TravelMarketTx{
      from_acc: from_acc,
      nonce: nonce,
      fee: fee,
      price: price,
      type: type,
      date: date,
      capacity: capacity,
      travel_time: travel_time,
      ttl: ttl,
      from: from,
      to: to}}
  end

  @spec hash_tx(TravelMarketTx.t()) :: binary()
  def hash_tx(tx) do
    :crypto.hash(:sha256, :erlang.term_to_binary(tx))
  end

end
