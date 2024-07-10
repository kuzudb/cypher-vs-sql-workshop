MATCH (p1:Person)-o1[:Owns]->(a1:Account)
       <-[t:Transfer]-(a2:Account)<-o2[:Owns]-(p2:Person)
WHERE p1.email = "georodaw366@hotmail.com"
RETURN p2.name AS person, p2.email AS email, t.amount AS amount;