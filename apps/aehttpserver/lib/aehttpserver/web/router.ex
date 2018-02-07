defmodule Aehttpserver.Web.Router do
  use Aehttpserver.Web, :router

  pipeline :api do
    plug CORSPlug, [origin: "*"]
    plug :accepts, ["json"]
    plug Aehttpserver.Plugs.SetHeader
  end

  pipeline :authorized do
    plug Aehttpserver.Plugs.Authorization
  end

  scope "/", Aehttpserver.Web do
    pipe_through :api

    get "/info", InfoController, :info

    post "/new_tx", NewTxController, :new_tx
    options "/new_tx", NewTxController, :options

    get "/peers", PeersController, :info

    resources "/tx", TxController, param: "account", only: [:show]
    options "/tx", TxController, :options

    post "/new_block", BlockController, :new_block
    options "/new_block", BlockController, :options

    get "/blocks", BlockController, :get_blocks
    get "/chainstate", ChainStateController, :chainstate

    post "/market/offer", MarketController, :offer
    options "/market/offer", MarketController, :options

    post "/market/demand", MarketController, :demand
    options "/market/demand", MarketController, :options

    get "/market", MarketController, :market
    get "/raw_blocks", BlockController, :get_raw_blocks
    get "/pool_txs", TxPoolController, :get_pool_txs

    resources "/block", BlockController, param: "hash", only: [:show]
    options "/block", BlockController, :options

    resources "/balance", BalanceController, param: "account", only: [:show]
    options "/balance", BalanceController, :options

    resources "/tx_pool", TxPoolController, param: "account", only: [:show]
    options "/tx_pool", TxPoolController, :options

  end

  scope "/node", Aehttpserver.Web do
    pipe_through :api
    pipe_through :authorized

    resources "/miner", MinerController, param: "operation", only: [:show]
    options "/miner", MinerController, :options
  end

end
