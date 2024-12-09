WITH RECURSIVE TransferPaths AS (
    -- Base case: Start with transfers FROM George
    SELECT p1.id AS start_id, p2.id AS end_id, [(a1.owner, a2.owner, t.amount)] AS path, 
            1 AS depth
    FROM Person p1
    JOIN Account a1 ON p1.id = a1.owner
    JOIN Transfer t ON a1.owner = t.source  -- Only FROM source
    JOIN Account a2 ON t.target = a2.owner  -- Only TO target
    JOIN Person p2 ON a2.owner = p2.id
    WHERE p1.name = 'George'

    UNION ALL

    -- Recursive case: Follow only outgoing transfers
    SELECT tp.start_id, p2.id AS end_id, list_append(tp.path, (a1.owner, a2.owner, t.amount)), tp.depth + 1 AS depth
    FROM TransferPaths tp
    JOIN Account a1 ON tp.end_id = a1.owner
    JOIN Transfer t ON a1.owner = t.source  -- Only FROM source
    JOIN Account a2 ON t.target = a2.owner  -- Only TO target
    JOIN Person p2 ON a2.owner = p2.id
    WHERE tp.depth < 5
)
SELECT start_id, end_id, path, depth
FROM TransferPaths, Person p
WHERE end_id = p.id AND p.name = 'Edward'
ORDER BY depth
LIMIT 1;