// Return the name of the person who has the email "georodaw366@hotmail.com"
MATCH (p:Person)
WHERE p.email = "georodaw366@hotmail.com"
RETURN p.name AS name;