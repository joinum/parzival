defmodule ParzivalWeb.ViewUtils do
  @moduledoc """
  Utility functions to be used on all views.
  """

  use Timex

  alias Parzival.Gamification

  alias Timex.Format.DateTime.Formatters.Relative

  def extract_initials(nil), do: ""

  def extract_initials(name) do
    initials = name |> String.upcase() |> String.split(" ") |> Enum.map(&String.slice(&1, 0, 1))

    case length(initials) do
      1 -> hd(initials)
      _ -> List.first(initials) <> List.last(initials)
    end
  end

  def extract_first_last_name(nil), do: ""

  def extract_first_last_name(name) do
    initials = name |> String.split(" ")

    case length(initials) do
      1 -> hd(initials)
      _ -> List.first(initials) <> " " <> List.last(initials)
    end
  end

  def relative_datetime(nil), do: ""

  def relative_datetime(""), do: ""

  def relative_datetime(datetime) do
    Relative.lformat!(datetime, "{relative}", Gettext.get_locale())
  end

  def display_date(nil), do: ""

  def display_date(""), do: ""

  def display_date(date) when is_binary(date) do
    date
    |> Timex.parse!("%FT%H:%M", :strftime)
    |> Timex.format!("{0D}-{0M}-{YYYY}")
  end

  def display_date(date) do
    Timex.format!(date, "{0D}-{0M}-{YYYY}")
  end

  def display_time(nil), do: ""

  def display_time(""), do: ""

  def display_time(date) when is_binary(date) do
    date
    |> Timex.parse!("%FT%H:%M", :strftime)
    |> Timex.format!("{0D}-{0M}-{YYYY}")
  end

  def display_time(date) do
    date
    |> Timex.format!("{h24}:{m}")
  end

  def get_next_activity(schedule, day) do
    now = NaiveDateTime.utc_now()

    schedule
    |> Map.get(day)
    |> Enum.reduce([], fn x, acc ->
      if NaiveDateTime.compare(now, x["hours"]) == :lt do
        acc ++ [x["hours"]]
      else
        acc
      end
    end)
    |> Enum.min_by(&abs(NaiveDateTime.diff(&1, now)))
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  def text_800(color) do
    case color do
      :gray -> "text-gray-800"
      :red -> "text-red-800"
      :orange -> "text-orange-800"
      :amber -> "text-amber-800"
      :yellow -> "text-yellow-800"
      :lime -> "text-lime-800"
      :green -> "text-green-800"
      :emerald -> "text-emerald-800"
      :teal -> "text-teal-800"
      :cyan -> "text-cyan-800"
      :sky -> "text-sky-800"
      :blue -> "text-blue-800"
      :indigo -> "text-indigo-800"
      :violet -> "text-violet-800"
      :purple -> "text-purple-800"
      :fuchsia -> "text-fuchsia-800"
      :pink -> "text-pink-800"
      :rose -> "text-rose-800"
    end
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  def border_200(color) do
    case color do
      :gray -> "border-gray-200"
      :red -> "border-red-200"
      :orange -> "border-orange-200"
      :amber -> "border-amber-200"
      :yellow -> "border-yellow-200"
      :lime -> "border-lime-200"
      :green -> "border-green-200"
      :emerald -> "border-emerald-200"
      :teal -> "border-teal-200"
      :cyan -> "border-cyan-200"
      :sky -> "border-sky-200"
      :blue -> "border-blue-200"
      :indigo -> "border-indigo-200"
      :violet -> "border-violet-200"
      :purple -> "border-purple-200"
      :fuchsia -> "border-fuchsia-200"
      :pink -> "border-pink-200"
      :rose -> "border-rose-200"
    end
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  def bg_100(color) do
    case color do
      :gray -> "bg-gray-100"
      :red -> "bg-red-100"
      :orange -> "bg-orange-100"
      :amber -> "bg-amber-100"
      :yellow -> "bg-yellow-100"
      :lime -> "bg-lime-100"
      :green -> "bg-green-100"
      :emerald -> "bg-emerald-100"
      :teal -> "bg-teal-100"
      :cyan -> "bg-cyan-100"
      :sky -> "bg-sky-100"
      :blue -> "bg-blue-100"
      :indigo -> "bg-indigo-100"
      :violet -> "bg-violet-100"
      :purple -> "bg-purple-100"
      :fuchsia -> "bg-fuchsia-100"
      :pink -> "bg-pink-100"
      :rose -> "bg-rose-100"
    end
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  def bg_500(color) do
    case color do
      :gray -> "bg-gray-500"
      :red -> "bg-red-500"
      :orange -> "bg-orange-500"
      :amber -> "bg-amber-500"
      :yellow -> "bg-yellow-500"
      :lime -> "bg-lime-500"
      :green -> "bg-green-500"
      :emerald -> "bg-emerald-500"
      :teal -> "bg-teal-500"
      :cyan -> "bg-cyan-500"
      :sky -> "bg-sky-500"
      :blue -> "bg-blue-500"
      :indigo -> "bg-indigo-500"
      :violet -> "bg-violet-500"
      :purple -> "bg-purple-500"
      :fuchsia -> "bg-fuchsia-500"
      :pink -> "bg-pink-500"
      :rose -> "bg-rose-500"
    end
  end

  def calc_level(user) do
    Gamification.calc_level(user.exp)
  end
end
