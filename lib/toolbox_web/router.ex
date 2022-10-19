defmodule ToolboxWeb.Router do
  use ToolboxWeb, :router

  import ToolboxWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ToolboxWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  live_session :default, on_mount: [ToolboxWeb.InitAssigns, ToolboxWeb.Nav] do
    scope "/", ToolboxWeb do
      pipe_through [:browser, :require_authenticated_user]

      live "/", EfrontLive.Cash, :index

      # unit
      live "/unit", UnitLive.Index, :index
      live "/unit/new", UnitLive.Index, :new
      live "/unit/:id/edit", UnitLive.Index, :edit

      live "/unit/:id", UnitLive.Show, :show
      live "/unit/:id/show/edit", UnitLive.Show, :edit

      # series
      live "/series", SerieLive.Series, :index
      live "/series/new", SerieLive.Index, :new
      live "/series/:id/edit", SerieLive.Index, :edit
      live "/series/:id", SerieLive.Show, :show
      live "/series/:id/show/edit", SerieLive.Show, :edit

      live "/secteurs", SecteurLive.Index, :index
      live "/secteurs/new", SecteurLive.Index, :new
      live "/secteurs/:id/edit", SecteurLive.Index, :edit
      live "/secteurs/:id", SecteurLive.Show, :show
      live "/secteurs/:id/show/edit", SecteurLive.Show, :edit

      live "/rubriques/:secteur_id", RubriqueLive.Index, :index
      live "/rubriques/new", RubriqueLive.Index, :new
      live "/rubriques/:id/edit", RubriqueLive.Index, :edit
      live "/rubriques/:id", RubriqueLive.Show, :show
      live "/rubriques/:id/show/edit", RubriqueLive.Show, :edit

      # eFront
      live "/eFront/accruals", EfrontLive.Accruals, :index
      live "/eFront/cash", EfrontLive.Cash, :index
      live "/eFront/lock", EfrontLive.Lock, :index

      # docuware
      live "/docuware/rss", DocuwareLive.Rss, :index
    end
  end

  scope "/auth", Toolbox do
    pipe_through :browser

    get "/:provider", OauthController, :request
    get "/:provider/callback", OauthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", ToolboxWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ToolboxWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ToolboxWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ToolboxWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", ToolboxWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
