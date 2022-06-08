defmodule Parzival.Repo.Seeds.Tools do
  import Ecto.Query

  alias Parzival.Repo

  alias Parzival.Accounts.User

  alias Parzival.Tools.Announcement
  alias Parzival.Tools.Faq
  alias Parzival.Tools.Post

  def run do
    seed_faqs()
    seed_announcements()
    seed_posts()
  end

  def seed_faqs do
    case Repo.all(Faq) do
      [] ->
        [
          %{
            question: "How do you make holy water?",
            answer:
              "You boil the hell out of it. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quas cupiditate laboriosam fugiat. "
          },
          %{
            question: "What's the best thing about Switzerland?",
            answer:
              "I don't know, but the flag is a big plus. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quas cupiditate laboriosam fugiat."
          },
          %{
            question: "What do you call someone with no body and no nose?",
            answer:
              "Nobody knows. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quas cupiditate laboriosam fugiat."
          },
          %{
            question: "Why do you never see elephants hiding in trees?",
            answer:
              "Because they're so good at it. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quas cupiditate laboriosam fugiat."
          },
          %{
            question: "Why can't you hear a pterodactyl go to the bathroom?",
            answer:
              "Because the pee is silent. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ipsam, quas voluptatibus ex culpa ipsum, aspernatur blanditiis fugiat ullam magnam suscipit deserunt illum natus facilis atque vero consequatur! Quisquam, debitis error."
          },
          %{
            question: "Why did the invisible man turn down the job offer?",
            answer:
              "He couldn't see himself doing it. Lorem ipsum dolor sit, amet consectetur adipisicing elit. Eveniet perspiciatis officiis corrupti tenetur. Temporibus ut voluptatibus, perferendis sed unde rerum deserunt eius."
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

  def seed_posts do
    attendees = Repo.all(where(User, role: :attendee))
    recruiters = Repo.all(where(User, role: :recruiter))
    offers = Repo.all(where(User, role: :attendee))

    case Repo.all(Post) do
      [] ->
        for _n <- 1..40 do
          Post.changeset(
            %Post{},
            %{
              text: Faker.Lorem.sentence(25..50),
              author_id: Enum.random(attendees).id
            }
          )
          |> Repo.insert!()
        end

      # for recruiter <- recruiters do
      #   offers = Repo.all(where(Offer, company_id: ^recruiter.company_id))

      #   Post.changeset(
      #     %Post{},
      #     %{
      #       text: Enum.random(offers).description,
      #       author_id: recruiter.id,
      #       offer_id: Enum.random(offers).id
      #     }
      #   )
      #   |> Repo.insert!()
      # end

      _ ->
        Mix.shell().error("Found posts, aborting seeding posts.")
    end
  end
end

Parzival.Repo.Seeds.Tools.run()
