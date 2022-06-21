defmodule ParzivalWeb.Components.Curriculum do
  @moduledoc false
  use ParzivalWeb, :component

  def curriculum(assigns) do
    ~H"""
    <div x-bind:class="option =='curriculum' ? 'block' : 'hidden'" class="px-4 pb-8 mx-auto mt-6 max-w-5xl border-b border-gray-200 sm:px-6 lg:px-8">
      <dl class="flex flex-col space-y-8">
        <div>
          <dt class="text-sm font-medium text-gray-500">About</dt>
          <dd class="mt-1 text-sm text-gray-900">
            <p>
              <%= assigns.curriculum.summary %>
            </p>
          </dd>
        </div>

        <div>
          <dt class="text-sm font-medium text-gray-500">Experience</dt>
          <dd class="mt-1 space-y-1 text-sm text-gray-900">
            <%= for experience <- assigns.curriculum.experiences do %>
              <% n_total_months =
                Enum.reduce(experience.positions, 0, fn position, acc ->
                  if position.finish do
                    Timex.diff(position.finish, position.start, :months) + acc
                  else
                    Timex.diff(Date.utc_today(), position.start, :months) + acc
                  end
                end) %>
              <div>
                <p class="text-sm font-bold">
                  <%= experience.organization %>
                  <span style="color: rgb(156,163,175)" class="ml-1 text-sm font-normal">
                    <%= if Integer.floor_div(n_total_months, 12) > 0 do %>
                      <%= Integer.floor_div(n_total_months, 12) %>yrs
                    <% end %>

                    <%= if rem(n_total_months, 12) != 0 do %>
                      <%= rem(n_total_months, 12) %>mos
                    <% end %>
                  </span>
                </p>
                <div class="flow-root ml-2 border-l border-gray-200">
                  <ul role="list" class="mt-0.5">
                    <%= for position <- experience.positions do %>
                      <li>
                        <% n_months =
                          if position.finish do
                            Timex.diff(position.finish, position.start, :months)
                          else
                            Timex.diff(Date.utc_today(), position.start, :months)
                          end %>
                        <p class="ml-5">
                          <%= position.title %>
                          <span style="color: rgb(156,163,175)" class="ml-2 text-sm">
                            <%= Calendar.strftime(position.start, "%b %Y") %> -
                            <%= if is_nil(position.finish) do %>
                              Current ·
                            <% else %>
                              <%= Calendar.strftime(position.finish, "%b %Y") %> ·
                            <% end %>
                            <%= if Integer.floor_div(n_months, 12) > 0 do %>
                              <%= Integer.floor_div(n_months, 12) %>yrs
                            <% end %>
                            <%= if rem(n_months,12) != 0 do %>
                              <%= rem(n_months, 12) %>mos
                            <% end %>
                          </span>
                        </p>
                      </li>
                    <% end %>
                  </ul>
                </div>
              </div>
            <% end %>
          </dd>
        </div>

        <div>
          <dt class="text-sm font-medium text-gray-500">
            Education
          </dt>
          <dd class="mt-1 space-y-1 text-sm text-gray-900">
            <%= for education <- assigns.curriculum.educations do %>
              <div>
                <p class="text-sm font-bold">
                  <%= education.institution %>
                </p>
                <p class="text-gray-700">
                  <%= education.course %>
                </p>
                <p class="text-xs text-gray-400">
                  <%= Calendar.strftime(education.start, "%Y") %> - <%= Calendar.strftime(education.finish, "%Y") %>
                </p>
              </div>
            <% end %>
          </dd>
        </div>

        <div>
          <dt class="text-sm font-medium text-gray-500">
            Volunteering
          </dt>
          <dd class="mt-1 space-y-1 text-sm text-gray-900">
            <%= for volunteering <- assigns.curriculum.volunteerings do %>
              <div>
                <p class="text-sm font-bold">
                  <%= volunteering.position %>
                </p>
                <p class="text-gray-700">
                  <%= volunteering.institution %>
                </p>
                <p class="text-xs text-gray-400">
                  <%= Calendar.strftime(volunteering.start, "%b %Y") %> - <%= Calendar.strftime(volunteering.finish, "%b %Y") %> ·
                  <%= if Timex.diff(volunteering.finish, volunteering.start, :years) > 0 do %>
                    <%= Timex.diff(volunteering.finish, volunteering.start, :years) %>yrs
                  <% end %>

                  <%= if rem(Timex.diff(volunteering.finish, volunteering.start, :months), 12) != 0 do %>
                    <%= rem(Timex.diff(volunteering.finish, volunteering.start, :months), 12) %>mos
                  <% end %>
                </p>
              </div>
            <% end %>
          </dd>
        </div>

        <div>
          <dt class="text-sm font-medium text-gray-500">
            Skills
          </dt>
          <dd class="grid grid-cols-2 mt-1 text-sm text-gray-900 sm:grid-cols-3 lg:grid-cols-4">
            <%= for skill <- assigns.curriculum.skills do %>
              <div>
                <p class="text-sm font-bold">
                  <%= skill.name %>
                </p>
              </div>
            <% end %>
          </dd>
        </div>

        <div>
          <dt class="text-sm font-medium text-gray-500">
            Languages
          </dt>
          <dd class="grid grid-cols-2 mt-1 space-y-1 text-sm text-gray-900 md:grid-cols-4">
            <%= for language <- assigns.curriculum.languages do %>
              <div>
                <p class="text-sm font-bold">
                  <%= language.idiom %>
                </p>
                <p class="text-xs text-gray-400">
                  <%= language.proficiency %>
                </p>
              </div>
            <% end %>
          </dd>
        </div>
      </dl>
    </div>
    """
  end
end
