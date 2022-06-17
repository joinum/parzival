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
        live "/", DashboardLive.Index, :index

        scope "/curriculum" do
          pipe_through [:require_curriculum_attendee]
          live "/:id/edit", DashboardLive.Edit, :edit
        end

        live "/leaderboard/", LeaderboardLive.Index, :index

        live "/profile/:id", ProfileLive.Show, :show
        live "/profile/:id/edit", ProfileLive.Edit, :edit

        live "/announcements", AnnouncementLive.Index, :index
        live "/announcements/:id", AnnouncementLive.Show, :show

        live "/missions", MissionLive.Index, :index

        scope "/vault" do
          live "/", OrderLive.Index, :index

          pipe_through [:require_order_attendee]
          live "/:id", OrderLive.Show, :show
        end

        scope "/cv" do
          get "/preview", PdfController, :cv_preview
          get "/:attendee_id", PdfController, :cv
        end

        scope "/offers" do
          live "/", OfferLive.Index, :index

          scope "/new" do
            pipe_through [:require_admin_or_recruiter]
            live "/", OfferLive.New, :new
          end

          live "/:id", OfferLive.Show, :show

          pipe_through [:require_admin_or_company_recruiter]
          live "/:id/edit", OfferLive.Edit, :edit
        end

        scope "/companies" do
          pipe_through [:require_not_recruiter]
          live "/", CompanyLive.Index, :index
          live "/:id", CompanyLive.Show, :show
        end

        scope "/store" do
          pipe_through [:require_not_recruiter]
          live "/", ProductLive.Index, :index
          live "/store/:id", ProductLive.Show, :show
        end

        scope "/missions", MissionLive do
          pipe_through [:require_level]
          live "/:id", Show, :show

          live "/:id/tasks/:task_id", TaskLive.Show, :show
          live "/:id/tasks/:task_id/redeem", TaskLive.Show, :redeem
        end
      end

      scope "/admin", Backoffice, as: :admin do
        pipe_through [:require_admin_or_staff]

        scope "/accounts" do
          live "/", UserLive.Index, :index

          pipe_through [:require_admin]
          live "/new", UserLive.New, :new
        end

        scope "/companies" do
          pipe_through [:require_admin]
          live "/new", CompanyLive.New, :new
          live "/:id/edit", CompanyLive.Edit, :edit
        end

        scope "/jobs" do
          pipe_through [:require_admin]
          live "/types/", OfferTypeLive.Index, :index
          live "/types/new", OfferTypeLive.Index, :new
          live "/types/:id/edit", OfferTypeLive.Index, :edit

          live "/times/", OfferTimeLive.Index, :index
          live "/times/new", OfferTimeLive.Index, :new
          live "/times/:id/edit", OfferTimeLive.Index, :edit
        end

        scope "/companies" do
          pipe_through [:require_admin]
          live "/levels/", LevelLive.Index, :index
          live "/levels/new", LevelLive.Index, :new
          live "/levels/:id/edit", LevelLive.Index, :edit
        end

        scope "/store" do
          pipe_through [:require_admin]
          live "/new", ProductLive.New, :new
          live "/:id/edit", ProductLive.Edit, :edit
        end

        scope "/missions" do
          pipe_through [:require_admin]
          live "/new", MissionLive.New, :new
          live "/:id/edit", MissionLive.Edit, :edit

          live "/dificulty/", DificultyLive.Index, :index
          live "/dificulty/new", DificultyLive.Index, :new
          live "/dificulty/:id/edit", DificultyLive.Index, :edit
        end

        scope "/tools" do
          pipe_through [:require_admin]
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
