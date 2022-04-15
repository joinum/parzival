defmodule Parzival.Repo.Seeds.Announcements do
  def run do
    case Bokken.Repo.all(Parzival.Announcements.Announcement) do
      [] ->
        [
          {"Anúncio Importante", "But before that, a message from our sponsor, FakeVPN!"}
          {"JOIN 2022", "Bem-vindos às JOIN 2022!"}
        ]
        |> create_announcements()
      _ ->
        Mix.shell().error("Found announcements, aborting seeding announcements.")
    end
  end

  def create_announcements(tuples) do
    for { title, content } <- tuples do
      announcement = %{title: tile, content: content}
      Parzival.Announcements.create_announcement(announcement)
    end
  end
end

Parzival.Repo.Seeds.Announcements.run
