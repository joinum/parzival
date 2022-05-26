defmodule Parzival.Repo.Seeds.Missions do
  alias Parzival.Repo

  alias Parzival.Accounts.User

  def run do
    seed_missions()
    seed_tasks()
  end

  defp missions do
    [
      %{
        title: "Ser developer",
        description: "Sê um developer por um dia"
      },
      %{
        title: "Invocar Cthulu",
        description: "Invoca a criatura lendária"
      },
      %{
        title: "Passar a algoritmos",
        description: "Que Deus te ajude"
      },
      %{
        title: "Ser um utilizador de Linux",
        description: "Como ser melhor que todos os outros utilizando apenas FOSS"
      }
    ]
  end

  defp tasks do
    [
      %{
        title: "Acordar",
        description: "Levanta-te da cama, não sejas preguiçosos",
        mission: Enum.at(missions, 0),
        start_time: Ecto.DateTime.from_erl({{2022, 5, 13}, {0, 0, 0}}),
        end_time: Ecto.DateTime.from_erl({{2022, 6, 13}, {0, 0, 0}})
      },
      %{
        title: "Bater código",
        description: "Mas cuidado para não produzir esparguete",
        mission: Enum.at(missions, 0),
        start_time: Ecto.DateTime.from_erl({{2022, 5, 14}, {0, 0, 10}}),
        end_time: Ecto.DateTime.from_erl({{2022, 6, 13}, {30, 20, 19}})
      },
      %{
        title: "Chorar",
        description:
          "Porque perdeste as últimas 4h a fazer debugging quando te esqueceste de descomentar um if",
        mission: Enum.at(missions, 0),
        start_time: Ecto.DateTime.from_erl({{2022, 3, 14}, {0, 0, 10}}),
        end_time: Ecto.DateTime.from_erl({{2022, 6, 13}, {30, 20, 19}})
      },
      %{
        title: "Dormir",
        description: "Amanhã há mais",
        mission: Enum.at(missions, 0),
        start_time: Ecto.DateTime.from_erl({{2022, 3, 14}, {59, 59, 23}}),
        end_time: Ecto.DateTime.from_erl({{2022, 6, 13}, {30, 20, 19}})
      },
      %{
        title: "Abre o Google Maps",
        description: "Confio que saibas fazer isso",
        mission: Enum.at(missions, 1),
        start_time: Ecto.DateTime.from_erl({{2022, 02, 14}, {59, 59, 23}}),
        end_time: Ecto.DateTime.from_erl({{2022, 12, 13}, {30, 20, 19}})
      },
      %{
        title: "Encontra o manicómio mais perto de ti",
        description: "Não deve ser difícil de encontrar",
        mission: Enum.at(missions, 1),
        start_time: Ecto.DateTime.from_erl({{2022, 02, 14}, {52, 49, 21}}),
        end_time: Ecto.DateTime.from_erl({{2022, 12, 23}, {30, 20, 19}})
      },
      %{
        title: "Entra e fala com o primeiro tolo que te aparecer à frente",
        description: "Não esperes uma conversa intelectualmente estimulante",
        mission: Enum.at(missions, 1),
        start_time: Ecto.DateTime.from_erl({{2022, 02, 14}, {52, 49, 21}}),
        end_time: Ecto.DateTime.from_erl({{2022, 12, 23}, {30, 20, 19}})
      },
      %{
        title: "Aponta e diz: Que tolo",
        description: "(Plot twist, olhaste para o espelho)",
        mission: Enum.at(missions, 1),
        start_time: Ecto.DateTime.from_erl({{2022, 05, 24}, {52, 49, 21}}),
        end_time: Ecto.DateTime.from_erl({{2022, 05, 24}, {30, 20, 22}})
      },
      %{
        title: "Deus te ajude",
        description:
          "Se calhar este vídeo pode ajudar na oração: https://www.youtube.com/watch?v=iik25wqIuFo",
        mission: Enum.at(missions, 2),
        start_time: Ecto.DateTime.from_erl({{2022, 05, 24}, {52, 49, 21}}),
        end_time: Ecto.DateTime.from_erl({{2022, 05, 24}, {30, 20, 22}})
      },
      %{
        title: "Enche o PC de stickers",
        description: "Quantos mais melhor, quantidade > qualidade",
        mission: Enum.at(missions, 3),
        start_time: Ecto.DateTime.from_erl({{2022, 05, 23}, {49, 49, 21}}),
        end_time: Ecto.DateTime.from_erl({{2022, 07, 24}, {30, 20, 22}})
      },
      %{
        title: "BTW",
        description: "I use arch",
        mission: Enum.at(missions, 3),
        start_time: Ecto.DateTime.from_erl({{2022, 05, 23}, {49, 49, 21}}),
        end_time: Ecto.DateTime.from_erl({{2022, 07, 24}, {30, 20, 22}})
      },
      %{
        title: "TTY is life",
        description: "Usar algo que não terminal é crime.",
        mission: Enum.at(missions, 3),
        start_time: Ecto.DateTime.from_erl({{2022, 05, 23}, {49, 49, 21}}),
        end_time: Ecto.DateTime.from_erl({{2022, 07, 24}, {30, 20, 22}})
      },
      %{
        title: "Let me interject for a moment",
        description:
          "What you guys are referring to as Linux, is in fact, GNU/Linux, or as I've recently taken to calling it, GNU plus Linux. Linux is not an operating system unto itself, but rather another free component of a fully functioning GNU system made useful by the GNU corelibs, shell utilities and vital system components comprising a full OS as defined by POSIX. Many computer users run a modified version of the GNU system every day, without realizing it. Through a peculiar turn of events, the version of GNU which is widely used today is often called \"Linux\", and many of its users are not aware that it is basically the GNU system, developed by the GNU Project. There really is a Linux, and these people are using it, but it is just a part of the system they use. Linux is the kernel: the program in the system that allocates the machine's resources to the other programs that you run. The kernel is an essential part of an operating system, but useless by itself; it can only function in the context of a complete operating system. Linux is normally used in combination with the GNU operating system: the whole system is basically GNU with Linux added, or GNU/Linux. All the so-called \"Linux\" distributions are really distributions of GNU/Linux. Thank you for taking your time to cooperate with with me, your friendly GNU+Linux neighbor, Richard Stallman.",
        mission: Enum.at(missions, 3),
        start_time: Ecto.DateTime.from_erl({{2022, 05, 23}, {49, 49, 21}}),
        end_time: Ecto.DateTime.from_erl({{2022, 07, 24}, {30, 20, 22}})
      }
    ]
  end

  def seed_missions do
    case Repo.all(Mission) do
      [] ->
        missions
        |> Enum.each(&insert_mission/1)

      _ ->
        Mix.shell().error("Found missions, aborting seeding missions.")
    end
  end

  def seed_tasks do
    case Repo.all(Task) do
      [] ->
        tasks
        |> Enum.each(&insert_mission/1)

      _ ->
        Mix.shell().error("Found tasks, aborting seeding tasks.")
    end
  end

  defp insert_mission(data) do
    %Mission{}
    |> Mission.registration_changeset(data)
    |> Repo.insert!()
  end

  defp insert_task(data) do
    %Task{}
    |> Task.registration_changeset(data)
    |> Repo.insert!()
  end
end

Parzival.Repo.Seeds.Missions.run()
