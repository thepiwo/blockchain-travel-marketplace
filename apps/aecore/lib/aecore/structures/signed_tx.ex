defmodule Aecore.Structures.SignedTx do
  @moduledoc """
  Aecore structure of a signed transaction.
  """

  alias Aecore.Keys.Worker, as: Keys
  alias Aecore.Structures.SpendTx
  alias Aecore.Structures.SignedTx
  alias Aecore.Structures.TravelMarketTx

  @type data_types :: SpendTx.t() | TravelMarketTx.t()

  @type t :: %SignedTx{
    data: data_types(),
    signature: binary()
  }

  @doc """
    Definition of Aecore SignedTx structure

  ## Parameters
     - data: Aecore %SpendTx{} structure
     - signature: Signed %SpendTx{} with the private key of the sender
  """
  defstruct [:data, :signature]
  use ExConstructor

  @spec is_coinbase?(SignedTx.t()) :: boolean()
  def is_coinbase?(tx) do
    tx.data.from_acc == nil && tx.signature == nil
  end

  @spec is_valid?(SignedTx.t()) :: boolean()
  def is_valid?(tx) do
    case tx.data do
      %SpendTx{} ->
        tx.data.fee >= 0
        && Keys.verify_tx(tx)
        && tx.data.value > 0
      %TravelMarketTx{} ->
        tx.data.fee >= 0
        && Keys.verify_tx(tx)
        && tx.data.capacity > 0
    end
  end

end
