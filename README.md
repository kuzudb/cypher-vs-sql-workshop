# Cypher vs. SQL workshop

[Kùzu](https://github.com/kuzudb/kuzu)
is an embedded graph database built for query speed and scalability. It implements the property graph
data model and is optimized for handling complex join-heavy analytical workloads on very large graphs.
At the end of this workshop, you'll take away some insights into how to use Kùzu and its query
language, Cypher, for graph analysis and also see how easy it is to use in combination with the rest
of your stack!

## Workshop Outline

This workshop will be divided into two parts.

### 1. An intro to graph analysis using Kùzu and Cypher

We will be working on a simple dataset of a financial network. The aim is to write Cypher queries to do
a graph analysis. To contrast it with a SQL-based analysis using a relational database, we will
also answer the same questions that are asked via Cypher with SQL queries in [DuckDB](https://duckdb.org/),
an embedded relational database. Along the way, it will become clear that some kinds of questions are actually
*really* hard (or borderline impossible) to answer in SQL, but are _natural_ and _easy_ in Cypher.

### 2. Analytics using graph algorithms

This section builds on the previous one. We will showcase the interoperability of Kùzu with the
Python data science ecosystem. We will use the existing financial network to run a graph algorithm,
`betweenness_centrality`, using NetworkX, a popular Python library for graph analysis.

## Kùzu Explorer


We will largely be interacting with Kùzu using its web-based UI, [Kùzu Explorer](https://docs.kuzudb.com/visualization/).
Here are the steps to run Kùzu Explorer.

1. You need to first ensure that Docker is installed on your machine:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

2. Once you have Docker installed, please start Docker. This is usually done by launching Docker Desktop application.
3. Next, you can download the specified image of Kùzu Explorer from DockerHub provided using the provided [`docker-compose.yml`](https://github.com/kuzudb/cypher-vs-sql-workshop/blob/main/docker-compose.yml) file.
To do that, you can run the following commands in the directory where the `docker-compose.yml` is:

```bash
docker compose up
```
The above command might take a while but at the end of it will run Kùzu Explorer on your http://localhost:8000/.

Alternatively, you can type in the following command in your terminal:

```bash
docker run -p 8000:8000 \
           -v ./ex_kuzu_db:/database \
           -v ./data:/data \
           -e MODE=READ_WRITE \
           --rm kuzudb/explorer:0.7.0
```

## Environment setup

We will be using the following tools:
- [Kùzu CLI](https://docs.kuzudb.com/installation/)
- [DuckDB CLI](https://duckdb.org/docs/installation/)
- [Python](https://www.python.org/downloads/)

---

## Problem statement

We will define the problem statement for this workshop as follows:

> Imagine you are an investigator at an organization that tracks financial crimes. Two email addresses
> have been flagged by law enforcement agencies, and both are now under suspicion for their potential
> involvement in fraudulent activities.
>
> Your task is to analyze some data that consists of money transfers between individuals to assist in
> the ongoing investigation. The findings from this analysis will be crucial for an upcoming court case.
> To achieve this, you will delve into the dataset to uncover hidden patterns, connections, and insights
> into the transactions between individuals.

## Dataset

A financial network dataset of persons, accounts, addresses and transfers between accounts is provided.
Its schema can be represented as shown below.

<img src="./assets/schema-viz.png" width="500">

A summary of the dataset is provided below:
- 21 nodes of type `Person`
- 21 nodes of type `Account` (each `Person` has exactly one account)
- 15 nodes of type `Address`
- 21 relationships of type `Transfer`, where the transfers are directed from a source account `s` that has transferred money
to a destination account `d`.

## Data modelling

The graph schema shown above is based on the following input files.
- `person.csv`
- `account.csv`
- `transfer.csv`

From a relational database perspective, we just have three tables. The person table has an address
column and the account table is connected to the person table via the person ID. The transfer table
contains the source and destination account IDs, and the amount transferred.

From the three tables we begin with, we are able to separate out the required columns for our node and
relationship tables in Kùzu, to give us the following six tables for our graph analysis:

- Node table: `Person`
- Node table: `Address`
- Node table: `Account`
- Relationship table: `Owns` (between `Person` and `Account`)
- Relationship table: `LivesIn` (between `Person` and `Address`)
- Relationship table: `Transfer` (between `Account` and `Account`)

## DDL

The DDL commands are provided in the `ddl` directory. Copy-paste them into their respective interfaces
to populate the data in the  required tables.

## Graph visualization

The resulting graph from this dataset has interesting structures, and is small enough to visualize all at once
in Kùzu explorer. You can get the below visualization in Kùzu Explorer with the following query:

```cypher
MATCH (a)-[b]->(c)
RETURN *
LIMIT 200
```
Write the above query in the shell panel of Kùzu Explorer and click the green play button to execute it.
Kùzu Explorer will then display the results as a graph visualization.

![](./assets/graph-viz.png)

## SQL queries

The SQL queries that are possible to write for each corresponding Cypher query are provided in the `sql` directory.
it is not required to run these queries for the workshop -- they are provided for reference.

## Cypher queries

The goal of this workshop is to write Cypher queries to answer the questions provided below. Along
the way, we will visualize all query results in Kùzu Explorer and gain a deeper understanding of the
data.

## Queries to answer

| Query | Description
| :---: | ---
| 1.1 | Find the name of the `Person`  node `p1` whose email property is `georodaw366@hotmail.com` <br>**Hint:** Specify an explicit pattern in your `MATCH` clause that respects the schema, use a `WHERE` predicate to filter the target person by their email, and then `RETURN` the name of the person. => Here, you can highlight how predicates can be put both in WHERE and inside the node pattern. The name of the person is George.
| 1.2 | Find the `Accounts` `a1` owned by George. <br>**Hint:** Extend the previous query with a longer MATCH pattern that connects/joins the `Person` node to its `Account` nodes that it `Owns`. 
| 1.3 | Find the names of all `Persons` who have made direct `Transfers` to the `Account` owned by George. <br>**Hint:** Extend the previous query to find all the `Account` nodes `a2` that made `Transfers` to George's accounts and the `Person` node that `Owns` `a2`. 
| 2 | Find all possible direct or indirect `Transfer` flows/paths **from** an account owned by George **to** to an account owned by `ezimmerman@yahoo.com` (Edward). For indirect transfers, only find those up to length 5.  <br>**Hint:** Specify variable-length or [recursive](https://docs.kuzudb.com/cypher/query-clauses/match/#match-variable-lengthrecursive-relationships) relationships in Cypher using the Kleene star operator `*` followed by the min and max length for the paths.
| 3.1 | Find a shortest `Transfer` path **from** George's account to Edward's account. <br>**Hint:** Kùzu's Cypher dialect has a native clause to match [a single shortest path](https://docs.kuzudb.com/cypher/query-clauses/match/#single-shortest-path).
| 3.2 | Find **all shortest** `Transfer` paths **from** George's account to Edward's account. <br>**Hint:** Kùzu's Cypher dialect has a native clause to match [all shortest paths](https://docs.kuzudb.com/cypher/query-clauses/match/#all-shortest-paths).
| 4 | Find **all** indirect connections of **any type** between the `Person` nodes representing George and Edward up to length 4. We are searching for any possible paths, i.e., the labels of the edges do not have to be only `Owns` or `Transfer`; they can also be `LivesIn` as well. That is, the path between the two people can consist of any sequence of _any_ labels. Further, we also do not need the connections to be in a particular direction. <br>**Hint:** Use Cypher's flexible relationship matching using [multiple labels](https://docs.kuzudb.com/cypher/query-clauses/match/#match-relationships-with-multi-labels) or [any labels](https://docs.kuzudb.com/cypher/query-clauses/match/#match-relationships-with-any-label). Also use the undirected relationship patterns.
| 5 | **a)** Find the account that has the highest number of incoming transactions. <br>**Hint:** Use [group by and aggregate](https://docs.kuzudb.com/cypher/query-clauses/return/#group-by-and-aggregations) to *count* of incoming edges. For reference, all possible aggregate functions are [here](https://docs.kuzudb.com/cypher/expressions/aggregate-functions/). <br> **b)** Find an important account that has received the most dollars. <br>**Hint:** Do a [group by and aggregate](https://docs.kuzudb.com/cypher/query-clauses/return/#group-by-and-aggregations) to *sum* of the amounts on the incoming edges.
| 6 | Find the accounts that are the "most central". We will use the notion of highest “betweenness centrality” (BC). <br> **Note:** This part will be done in Python via the NetworkX library.

> [!NOTE]
> Betweenness centrality is a measure of the number of shortest paths that pass through a node. It is calculated as the number of shortest paths that pass through a node divided by the total number of shortest paths between all pairs of nodes.
