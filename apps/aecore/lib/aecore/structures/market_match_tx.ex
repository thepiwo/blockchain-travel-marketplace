defmodule Aecore.Structures.MarketMatchTx do
  @moduledoc """
  Aecore structure of a travel market transaction.
  """

  alias Aecore.Structures.MarketMatchTx
  
  @type t :: %MarketMatchTx{
    from_acc: binary(),
    to_acc: binary(),

    offer_hash: binary(),
    demand_hash: binary()
  }

  @doc """
  Definition of Aecore MarketMatchTx structure
  """
  defstruct [:from_acc, :to_acc, :offer_hash, :demand_hash]
  use ExConstructor

  @spec create(binary(), binary(), binary(), binary()) :: {:ok, MarketMatchTx.t()}
  def create(from_acc, to_acc, offer_hash, demand_hash) do
    {:ok, %MarketMatchTx{
      from_acc: from_acc,
      to_acc: to_acc,
      offer_hash: offer_hash,
      demand_hash: demand_hash}}
  end

  @spec hash_tx(MarketMatchTx.t()) :: binary()
  def hash_tx(tx) do
    :crypto.hash(:sha256, :erlang.term_to_binary(tx))
  end

end
