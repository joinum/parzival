defmodule Parzival.Repo.Seeds.Curriculums do
  import Ecto.Query

  alias Parzival.Repo
  alias Parzival.Accounts.User
  alias Parzival.Gamification.Curriculum

  @education_titles File.read!("priv/repo/seeds/data/uminho_courses.txt") |> String.split("\n")
  @languages File.read!("priv/repo/seeds/data/languages.txt") |> String.split("\n")

  def run do
    seed_curriculums()
  end

  def seed_curriculums do
    case Repo.all(Curriculum) do
      [] ->
        attendees =
          User
          |> where(role: :attendee)
          |> Repo.all()

        education_titles = Enum.shuffle(@education_titles)
        laguanges = Enum.shuffle(@languages)

        for attendee <- attendees do
          Curriculum.changeset(%Curriculum{}, %{
            summary: Faker.Lorem.sentence(20..40),
            user_id: attendee.id,
            experiences:
              Enum.reduce(
                List.duplicate(:experience, Enum.random(1..3)),
                [],
                fn _n, acc ->
                  [
                    %{
                      company_name: Faker.Company.name(),
                      job:
                        Enum.reduce(
                          List.duplicate(:job, Enum.random(1..4)),
                          [],
                          fn _next, acc ->
                            [
                              %{
                                job_title: Faker.Person.title(),
                                start_date:
                                  Faker.DateTime.between(~D[2018-04-11], ~D[2021-04-11]),
                                end_date:
                                  Faker.DateTime.between(
                                    ~D[2021-04-11],
                                    Date.utc_today()
                                  ),
                                present: Enum.random([true, false, false, false])
                              }
                              | acc
                            ]
                          end
                        )
                    }
                    | acc
                  ]
                end
              ),
            educations:
              Enum.reduce(
                List.duplicate(:education, Enum.random(1..2)),
                [],
                fn _n, acc ->
                  [
                    %{
                      education_title: Enum.random(education_titles),
                      date: Faker.DateTime.between(~D[2016-09-18], Date.utc_today()),
                      description: Faker.Lorem.sentence(10..20)
                    }
                    | acc
                  ]
                end
              ),
            voluntaries:
              Enum.reduce(
                List.duplicate(:voluntary, Enum.random(1..2)),
                [],
                fn _n, acc ->
                  [
                    %{
                      voluntary_title: Faker.Company.name(),
                      date: Faker.DateTime.between(~D[2016-09-18], Date.utc_today())
                    }
                    | acc
                  ]
                end
              ),
            skills:
              Enum.reduce(
                List.duplicate(:skill, Enum.random(6..12)),
                [],
                fn _n, acc ->
                  [
                    %{
                      name: Faker.Beer.En.brand()
                    }
                    | acc
                  ]
                end
              ),
            languages:
              Enum.reduce(
                List.duplicate(:skill, Enum.random(2..4)),
                [],
                fn _n, acc ->
                  [
                    %{
                      idiom: Enum.random(laguanges),
                      proficiency: Enum.random([:Native, :Fluent, :Intermediary, :Basic])
                    }
                    | acc
                  ]
                end
              )
          })
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found Curriculums, aborting seeding curriculums.")
    end
  end

  # defp insert_curriculum(data) do
  #   %Curriculum{}
  #   |> Curriculum.changeset(data)
  #   |> Repo.insert!()
  # end
end

Parzival.Repo.Seeds.Curriculums.run()
