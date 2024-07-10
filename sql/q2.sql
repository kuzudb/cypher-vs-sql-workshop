WITH RECURSIVE TransferPaths AS (
    -- Base case: Start with the person with one of the emails as the source
    SELECT p1.id AS start_id, p2.id AS end_id, [(a1.owner, a2.owner, t.amount)] AS path, 
            1 AS depth
    FROM Person p1
    JOIN Account a1 ON p1.id = a1.owner
    JOIN Transfer t ON a1.owner = t.source OR a1.owner = t.target
    JOIN Account a2 ON (t.source = a2.owner OR t.target = a2.owner) AND a2.owner != a1.owner
    JOIN Person p2 ON a2.owner = p2.id
    WHERE p1.email = 'georodaw366@hotmail.com'

    UNION ALL

    -- Recursive case: Traverse up to N relationships deep
    SELECT tp.start_id, p2.id AS end_id, list_append(tp.path, (a1.owner, a2.owner, t.amount)), tp.depth + 1 AS depth
    FROM TransferPaths tp
    JOIN Account a1 ON tp.end_id = a1.owner
    JOIN Transfer t ON a1.owner = t.source OR a1.owner = t.target
    JOIN Account a2 ON (t.source = a2.owner OR t.target = a2.owner) AND a2.owner != a1.owner
    JOIN Person p2 ON a2.owner = p2.id
    WHERE tp.depth < 5
)
-- Select the paths where the end person has the target email
SELECT start_id, end_id, path, depth
FROM TransferPaths, Person p
WHERE end_id = p.id and p.email = 'ezimmerman@yahoo.com'
ORDER BY depth;