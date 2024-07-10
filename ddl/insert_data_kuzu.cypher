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
    LOAD FROM '/data/person.csv' (
        header = true,
        delim = ",",
        escape = '"'
    )
    RETURN CAST(id, "INT64"), name, state, CAST(zipcode, "INT64"), email
);

COPY Account FROM
(
    LOAD FROM '/data/account.csv' (header = true)
    RETURN CAST(id, "INT64"), account_id, CAST(balance, "DOUBLE")
);

COPY Address FROM
(
    LOAD FROM '/data/person.csv' (
        header = true,
        delim = ",",
        escape = '"'
    )
    RETURN DISTINCT address
);

COPY Owns FROM
(
    LOAD FROM '/data/account.csv' (
        header = true,
        delim = ",",
        escape = '"'
    )
    RETURN CAST(owner, "INT64"), CAST(id, "INT64")
);

COPY LivesIn FROM
(
    LOAD FROM '/data/person.csv' (
        header = true,
        delim = ",",
        escape = '"'
    )
    RETURN CAST(id, "INT64"), address
);

COPY Transfer FROM (
    LOAD FROM '/data/transfer.csv' (header = true)
    RETURN CAST(source, "INT64"), CAST(target, "INT64"), CAST(amount, "DOUBLE")
);