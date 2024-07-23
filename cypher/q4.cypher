MATCH (p1:Person)-[r* ALL SHORTEST]-(p2:Person) 
WHERE p1.email = "georodaw366@hotmail.com" AND p2.email = "ezimmerman@yahoo.com" 
RETURN *, size(rels(r)) AS depth
ORDER BY depth;