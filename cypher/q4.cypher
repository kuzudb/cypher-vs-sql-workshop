// Find all indirect connections of any type between the Person nodes representing George and
// Edward up to a specified path length
MATCH (p1:Person)-[r* 1..5]-(p2:Person) 
WHERE p1.name = "George" and p2.name = "Edward"
RETURN *;