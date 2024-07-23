MATCH (p1:Person)-[o1:Owns]->(a1:Account)-[t:Transfer* SHORTEST]-(a2:Account)<-[o2:Owns]-(p2:Person) 
WHERE p1.email = "georodaw366@hotmail.com" AND p2.email = "ezimmerman@yahoo.com" 
RETURN *, size(rels(t)) AS depth;