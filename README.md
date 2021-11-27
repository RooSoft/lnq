# Lightning Network Graph Query Tool

Query the network graph for nodes based on proximity

## Install

Prerequisites

* [Elixir](https://elixir-lang.org/install.html)
* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [jq](https://stedolan.github.io/jq/)

Then, clone this repository and execute these commands

```bash
mix deps.get
mix escript.build
```

## Create a neo4j container

```bash
mkdir -s ~/neo4j/data
mkdir -s ~/neo4j/import
docker-compose up -d
```

## Import network graph from LND

On a Lightning Node running LND, execute

```bash
lncli describegraph > lightning-graph.json
```

Get the `lightning-graph.json` file on the computer running LNQ, and then run these commands in that same exact sequence

```bash
lnq convert lightning-graph.json
lnq import
lnq analyze
```

## Do some queries

Get a help screen listing possible queries by running

```bash
./lnq
```