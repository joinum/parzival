defmodule ParzivalWeb.Router do
  use ParzivalWeb, :router

  import ParzivalWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ParzivalWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ParzivalWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/schedule", ScheduleController, :index
    get "/hackathon", HackathonController, :index
    get "/missions", MissionsController, :index
    get "/speakers", SpeakersController, :index
    get "/faqs", FaqsController, :index
    get "/team", TeamController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ParzivalWeb do
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

      live_dashboard "/dashboard", metrics: ParzivalWeb.Telemetry
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

  scope "/", ParzivalWeb do
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

  scope "/", ParzivalWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :logged_in, on_mount: [{ParzivalWeb.Hooks, :current_user}] do
      live "/home/", HomeLive.Index, :index

      scope "/tools" do
        live "/faqs/", FaqsLive.Index, :index
        live "/faqs/new", FaqsLive.New, :new
        live "/faqs/:id", FaqsLive.Show, :show
        live "/faqs/:id/edit", FaqsLive.Edit, :edit

        live "/announcements", AnnouncementLive.Index, :index
        live "/announcements/new", AnnouncementLive.Index, :new
        live "/announcements/:id/edit", AnnouncementLive.Index, :edit

        live "/announcements/:id", AnnouncementLive.Show, :show
        live "/announcements/:id/show/edit", AnnouncementLive.Show, :edit
      end

      live "/store/", ProductLive.Index, :index
      live "/store/new", ProductLive.New, :new
      live "/store/:id", ProductLive.Show, :show
      live "/store/:id/edit", ProductLive.Edit, :edit

      scope "/vault" do
        live "/earned", EarnedLive.Index, :index

        live "/purchased", PurchasedLive.Index, :index
      end

    end

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", ParzivalWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
