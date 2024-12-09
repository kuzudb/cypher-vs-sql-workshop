// Return all the accounts owned by George
MATCH (p:Person)-[o:Owns]->(a:Account)
WHERE p.name = "George"
RETURN p.name, a.account_id, a.balance;