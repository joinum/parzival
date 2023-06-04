defmodule Parzival.Repo.Seeds.Tools do
  import Ecto.Query

  alias Parzival.Repo

  alias Parzival.Accounts.User

  alias Parzival.Tools.Announcement
  alias Parzival.Tools.Faq

  def run do
    seed_faqs()
    seed_announcements()
  end

  def seed_faqs do
    case Repo.all(Faq) do
      [] ->
        [
          %{
            question: "When and where does JOIN take place?",
            answer:
              "JOIN takes place from June 5th to June 7th, in the CP1 building at Universidade do Minho in Braga."
          },
          %{
            question: "Where will all the activities take place?",
            answer:
              "All the talks/pitches/workshops will take place at the auditorium A2/0.20 in the CP1 building."
          },
          %{
            question: "Is JOIN free?",
            answer: "Yes, it's free to all attendees!"
          },
          %{
            question: "Can I participate, even if I'm not a student?",
            answer:
              "Of course! JOIN is open to everyone, regardless if you're a student or not. Everyone is welcome to participate in our workshops and our talks."
          },
          %{
            question: "Where can I register to participate?",
            answer:
              "You can participate by registering in this year's edition through the link below."
          },
          %{
            question: "How can I contact JOIN's team?",
            answer:
              "You can email us at join.di.uminho@gmail.com or send us a message through our social media accounts."
          }
        ]
        |> Enum.each(&Repo.insert!(Faq.changeset(%Faq{}, &1)))

      _ ->
        Mix.shell().error("Found faqs, aborting seeding faqs.")
    end
  end

  def seed_announcements do
    admins = Repo.all(where(User, role: :admin))

    case Repo.all(Announcement) do
      [] ->
        for _n <- 1..40 do
          Announcement.changeset(
            %Announcement{},
            %{
              title: Faker.Lorem.sentence(3..5),
              text: Faker.Lorem.sentence(200..400),
              author_id: Enum.random(admins).id
            }
          )
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found announcements, aborting seeding announcements.")
    end
  end
end

Parzival.Repo.Seeds.Tools.run()
