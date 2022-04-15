# ![JOIN Banner](.github/brand/join-logo.svg)

JOIN wich stands for "Jornadas de Informática" is a Job Shop aimed at students in the field of computing.

It's an annual event that aims to promote interaction between students from the three study cycles of this university with a strong IT component and the business world, regional or national, which has been its major employer.

## 🚀 Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes. Start by creating an
environment file and fill them with valid values.

```
bin/setup (--docker | --local) [ENVIRONMENT]
```

### 📥 Prerequisites

There are two options when it comes to setting up your development environment.
The Docker based one boils down to running a single command and is most likely
what you want, especially when getting started. The following software is
required if you want to follow a Docker base approach.

- [Docker 20+](https://docs.docker.com/desktop/)
- [Docker Compose 2+](https://docs.docker.com/compose/)


If you prefer a local setup (to have more control) the following software is
required to be installed on your system.

- [Erlang 24+](https://www.erlang.org/downloads)
- [Elixir 1.13+](https://elixir-lang.org/install.html)
- [PostgreSQL 13+](https://www.postgresql.org/download/)

We recommend using [asdf version
manager](https://asdf-vm.com/) to install and
manage all the programming languages' requirements if you want to run locally.

### 🐳 Docker

To start all the services (database and webapp) run:

```
docker-compose -f docker-compose.dev.yml -f {linux,darwin}.yml up
```

If you only want to start the database run:

```
docker-compose -f docker-compose.dev.yml -f {linux,darwin}.yml up db
```

### ⚙️  Local Setup

You need to setup the database beforehand and then run:

```
mix setup
```

### 🔨 Development

Start the development server and then you can visit
[`localhost:4000`](http://localhost:4000) from your browser.

```
mix phx.server
```

### 🔗 References

You can use these resources to learn more about the technologies this project
uses.

- [Getting Started with Elixir](https://elixir-lang.org/getting-started/introduction.html)
- [Erlang/Elixir Syntax: A Crash Course](https://elixir-lang.org/crash-course.html)
- [Elixir School Course](https://elixirschool.com/en/)
- [Phoenix Guides Overview](https://hexdocs.pm/phoenix/overview.html)
- [Phoenix Documentation](https://hexdocs.pm/phoenix)
- [Get started with Tailwind CSS](https://tailwindcss.com/docs)
- [Alpine.js Documentation](https://alpinejs.dev/start-here)