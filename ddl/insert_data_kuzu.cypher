CREATE NODE TABLE IF NOT EXISTS Person (
    id INT64,
    name STRING,
    state STRING,
    zip INT64,
    email STRING,
    PRIMARY KEY (id)
);

CREATE NODE TABLE IF NOT EXISTS Address (
    address STRING,
    PRIMARY KEY (address)
);

CREATE NODE TABLE IF NOT EXISTS Account (
    id INT64,
    account_id STRING,
    balance DOUBLE,
    PRIMARY KEY (id)
);

CREATE REL TABLE IF NOT EXISTS Owns (FROM Person TO Account);
CREATE REL TABLE IF NOT EXISTS LivesIn (FROM Person TO Address);
CREATE REL TABLE IF NOT EXISTS Transfer (FROM Account TO Account, amount DOUBLE);

COPY Person FROM
(
    LOAD FROM 'data/person.csv' (
        header = true,
        delim = ",",
        escape = '"'
    )
    RETURN CAST(id AS INT64), name, state, CAST(zipcode AS INT64), email
);

COPY Account FROM
(
    LOAD FROM 'data/account.csv' (header = true)
    RETURN CAST(id AS INT64), account_id, CAST(balance AS DOUBLE)
);

COPY Address FROM
(
    LOAD FROM 'data/person.csv' (
        header = true,
        delim = ",",
        escape = '"'
    )
    RETURN DISTINCT address
);

COPY Owns FROM
(
    LOAD FROM 'data/account.csv' (
        header = true,
        delim = ",",
        escape = '"'
    )
    RETURN CAST(owner AS INT64), CAST(id AS INT64)
);

COPY LivesIn FROM
(
    LOAD FROM 'data/person.csv' (
        header = true,
        delim = ",",
        escape = '"'
    )
    RETURN CAST(id AS INT64), address
);

COPY Transfer FROM (
    LOAD FROM 'data/transfer.csv' (header = true)
    RETURN CAST(source AS INT64), CAST(target AS INT64), CAST(amount AS DOUBLE)
);