// Return the names of all persons who made a direct transfer to George
MATCH (p1:Person)-[o1:Owns]->(a1:Account)<-[t:Transfer]-(a2:Account)-[o2:Owns]-(p2:Person)
WHERE p1.name = "George"
RETURN p2.name AS persons;