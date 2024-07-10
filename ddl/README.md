# Ingest data

This directory contains DDL statements for creating the required tables in the respective databases.

## Kùzu

You can run the Kùzu DDL commands from either the [Kùzu CLI](https://docs.kuzudb.com/installation/#command-line-shell),
or the web-based UI, Kùzu Explorer.

Copy-paste the DDL statements from the `insert_data_kuzu.cypher` file and run the query to insert
the data into the Kùzu database. Once the data is ingested, you can query and visualize the graph in Kùzu Explorer.

## DuckDB (Optional)

This section is not required to complete the workshop, but you are welcome
to run these commands and ingest your data into DuckDB tables if you want to compare SQL vs. Cypher for your
queries.

Install the DuckDB CLI on your operating system. The installation instructions are [here](https://duckdb.org/docs/installation/).

Then, open a DuckDB CLI session in your terminal and point it to a local empty database file.

```bash
duckdb ./ex_duckdb`
```

Within the DuckDB CLI, you can copy-paste the DDL statements from the `insert_data_duckdb.sql`
file to create the required tables. Once the data is ingested, you can run SQL queries to analyze the data.

