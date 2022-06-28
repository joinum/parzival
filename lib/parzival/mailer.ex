defmodule Parzival.Mailer do
  @moduledoc """
  The Parzival application Mailer.
  """
  use Mailgun.Client,
    domain:  Application.get_env(:parzival, :mailgun_domain),
    key: Application.get_env(:parzival, :mailgun_key)

  def deliver(email) do
    send_email  to: email.recipient,
                from: "noreply@emailer.joinum.link",
                subject: email.subject,
                text: email.body
  end
end
