SELECT p.name, a.account_id, a.balance
FROM Person p
JOIN Account a ON p.id = a.id
WHERE p.name = 'George';