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
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create
    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
    get "/reset_password", UserResetPasswordController, :new
    post "/reset_password", UserResetPasswordController, :create
    get "/reset_password/:token", UserResetPasswordController, :edit
    put "/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ParzivalWeb do
    pipe_through [:browser]

    live_session :user, on_mount: [{ParzivalWeb.Hooks, :current_user}] do
      scope "/", Landing, as: :landing do
        live "/", HomeLive.Index, :index

        live "/schedule", ScheduleLive.Index, :index
        live "/missions", MissionsLive.Index, :index
        live "/speakers", SpeakersLive.Index, :index
        live "/faqs", FaqsLive.Index, :index
        live "/team", TeamLive.Index, :index
      end
    end
  end

  scope "/", ParzivalWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :logged_in, on_mount: [{ParzivalWeb.Hooks, :current_user}] do
      scope "/app", App do
        live "/", HomeLive.Index, :index

        live "/store/", ProductLive.Index, :index
        live "/store/:id", ProductLive.Show, :show

        live "/vault", OrderLive.Index, :index

        live "/announcements", AnnouncementLive.Index, :index
        live "/announcements/:id", AnnouncementLive.Show, :show
      end

      scope "/admin", Backoffice, as: :admin do
        live "/store/new", ProductLive.New, :new
        live "/store/:id/edit", ProductLive.Edit, :edit

        scope "/tools" do
          live "/faqs/", FaqsLive.Index, :index
          live "/faqs/new", FaqsLive.New, :new
          live "/faqs/:id", FaqsLive.Show, :show
          live "/faqs/:id/edit", FaqsLive.Edit, :edit

          live "/announcements/new", AnnouncementLive.New, :new
          live "/announcements/:id/edit", AnnouncementLive.Edit, :edit
        end
      end
    end

    get "/settings", UserSettingsController, :edit
    put "/settings", UserSettingsController, :update
    get "/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", ParzivalWeb do
    pipe_through [:browser]

    delete "/log_out", UserSessionController, :delete
    get "/confirm", UserConfirmationController, :new
    post "/confirm", UserConfirmationController, :create
    get "/confirm/:token", UserConfirmationController, :edit
    post "/confirm/:token", UserConfirmationController, :update
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
end
