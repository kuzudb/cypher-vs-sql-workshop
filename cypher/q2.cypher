// Find all possible direct or indirect transfer path from George's account to Edward's account.
MATCH (p1:Person)-[o1:Owns]->(a1:Account)-[t:Transfer* 1..5]->(a2:Account)<-[o2:Owns]-(p2:Person)
WHERE p1.name = "George" AND p2.name = "Edward"
RETURN *, size(rels(t)) AS depth
ORDER BY depth;