CREATE OR REPLACE TABLE Person AS
SELECT *
FROM read_csv(
    'data/person.csv',
    header = true,
    delim = ',',
    escape = '"'
);

CREATE OR REPLACE TABLE Account AS
SELECT id, account_id, owner, balance
FROM read_csv(
    'data/account.csv',
    header = true
);

CREATE OR REPLACE TABLE Transfer AS
SELECT source, target, amount
FROM read_csv('data/transfer.csv', header = true);