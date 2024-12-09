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
    balance INT64,
    PRIMARY KEY (id)
);

CREATE REL TABLE IF NOT EXISTS Owns (FROM Person TO Account);
CREATE REL TABLE IF NOT EXISTS LivesIn (FROM Person TO Address);
CREATE REL TABLE IF NOT EXISTS Transfer (FROM Account TO Account, amount INT64);

COPY Person FROM
(
    LOAD FROM '/data/person.csv'
    RETURN id, name, state, zipcode, email
);

COPY Account FROM
(
    LOAD FROM '/data/account.csv'
    RETURN id, account_id, balance
);

COPY Address FROM
(
    LOAD FROM '/data/person.csv'
    RETURN DISTINCT address
);

COPY Owns FROM
(
    LOAD FROM '/data/account.csv'
    RETURN owner, id
);

COPY LivesIn FROM
(
    LOAD FROM '/data/person.csv'
    RETURN id, address
);

COPY Transfer FROM (
    LOAD FROM '/data/transfer.csv'
    RETURN source, target, amount
);