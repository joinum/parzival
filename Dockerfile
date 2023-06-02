# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian instead of
# Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20221004 - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.13.4-erlang-25.1.2-debian-bullseye-20221004
ARG ELIXIR_VERSION=1.13.4
ARG OTP_VERSION=25.1.2
ARG DEBIAN_VERSION=bullseye-20221004

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder

ENV MIX_ENV="prod"

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git python3 \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

# copy necessary folders
COPY priv priv
COPY lib lib
COPY assets assets
COPY data data

# compile assets
RUN mix assets.deploy

# compile the release
RUN mix compile

# changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

ENV MIX_ENV="prod"

# install frontend dependencies
RUN apt-get update -y && apt-get install -y nodejs npm
RUN npm install -g npx

# install pdf generation dependencies
RUN apt-get update -y && apt-get install -y wkhtmltopdf

# install imagemagick dependencies
RUN apt-get update -y && apt-get install -y file imagemagick

# install final dependencies
RUN apt-get update -y && apt-get install -y locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/parzival ./

USER nobody

CMD ["/app/bin/server"]

# appended by flyctl
# ENV ECTO_IPV6 true
#ENV ERL_AFLAGS "-proto_dist inet6_tcp"

# Appended by flyctl
#ENV ECTO_IPV6 true
#ENV ERL_AFLAGS "-proto_dist inet6_tcp"
