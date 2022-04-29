defmodule Parzival.Repo.Seeds.Tools do
  alias Parzival.Repo

  alias Parzival.Tools.Faq
  alias Parzival.Tools.Announcement

  def run do
    seed_faqs()
    seed_announcements()
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
    # admins = Repo.all(where(User, role: :admin))

    case Repo.all(Announcement) do
      [] ->
        [
          %{
            title: "Welcome to the JOIN Platform",
            text:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vel tincidunt massa. Nunc mi enim, blandit quis condimentum vel, tincidunt ac dolor. Curabitur placerat justo eros, sit amet vulputate nulla vulputate a. Interdum et malesuada fames ac ante ipsum primis in faucibus"
            # author_id: Enum.random(admins).id
          },
          %{
            title: "Hackathon registrations are closed",
            text:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vel tincidunt massa. Nunc mi enim, blandit quis condimentum vel, tincidunt ac dolor. Curabitur placerat justo eros, sit amet vulputate nulla vulputate a. Interdum et malesuada fames ac ante ipsum primis in faucibus"
            # author_id: Enum.random(admins).id
          }
        ]
        |> Enum.each(&Repo.insert!(Announcement.changeset(%Announcement{}, &1)))

      _ ->
        Mix.shell().error("Found announcements, aborting seeding announcements.")
    end
  end
end

Parzival.Repo.Seeds.Tools.run()
