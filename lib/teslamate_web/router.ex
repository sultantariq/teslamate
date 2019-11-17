defmodule TeslaMateWeb.Router do
  use TeslaMateWeb, :router

  alias TeslaMate.Settings

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_settings
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TeslaMateWeb do
    pipe_through :browser

    get "/", CarController, :index
    live "/sign_in", SignInLive.Index
    live "/settings", SettingsLive.Index
    live "/geo-fences", GeoFenceLive.Index
    live "/geo-fences/new", GeoFenceLive.New
    live "/geo-fences/:id/edit", GeoFenceLive.Edit
  end

  scope "/api", TeslaMateWeb do
    pipe_through :api

    put "/car/:id/logging/resume", CarController, :resume_logging
    put "/car/:id/logging/suspend", CarController, :suspend_logging
  end

  defp fetch_settings(conn, _opts), do: assign(conn, :settings, Settings.get_settings!())
end
