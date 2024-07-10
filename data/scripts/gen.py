"""
Methods that loosely generate synthetic data for demo purposes.

The generated data is customized by hand to get the necessary patterns to demonstrate
via graph queries.
"""
from __future__ import annotations
import random
from typing import Any
from faker import Faker

SEED = 372435
random.seed(SEED)
Faker.seed(SEED)
fake = Faker()

NUM_RECORDS = 20
JsonBlob = dict[str, Any]

def generate_person_profiles(num: int) -> list[JsonBlob]:
    profiles = []
    for i in range(1, num + 1):
        if fake.first_name() not in profiles:
            profile = dict()
            profile["id"] = i
            profile["name"] = fake.first_name()
            profile["email"] = f"{fake.domain_word()}@{fake.free_email_domain()}"
            profiles.append(profile)
        if len(profiles) == num:
            break
    print(f"---\nGenerated {num} synthetic person profiles.\n")
    for p in profiles:
        print(f"{p['id']},{p['name']},{p['email']}")
    return profiles


def generate_bank_accounts(num: int) -> list[JsonBlob]:
    accounts = []
    for i in range(1, num + 1):
        account = dict()
        account["id"] = i
        account["account_id"] = fake.aba()
        account["owner"] = i
        account["balance"] = fake.random_int(min=5034, max=15864)
        accounts.append(account)
    print(f"---\nGenerated {num} synthetic bank accounts.\n")
    for a in accounts:
        print(f"{a['id']},{a['account_id']},{a['owner']},{a['balance']}")
    return accounts


def generate_transfers(accounts: list[JsonBlob]) -> list[JsonBlob]:
    account_ids = [a["account_id"] for a in accounts]
    mapping = {a["account_id"]: a["id"] for a in accounts}
    transfers = []
    for _ in range(100):
        transfer = {}
        sources = list(transfer.keys())
        src = mapping.get(random.choice(account_ids))
        transfer["src"] = src
        dest = mapping.get(random.choice(account_ids))
        if src not in sources and src != dest:
            transfer["dest"] = dest
            transfer["amount"] = fake.random_int(min=39, max=892)
            transfer["transaction_id"] = fake.ean8(prefixes=("45", "47", "49"))
            transfers.append(transfer)
        if len(transfers) == 20:
            break
    print(f"---\nGenerated {len(transfers)} synthetic transfers.\n")
    for t in transfers:
        print(f"{t['src']},{t['dest']},{t['amount']},{t['transaction_id']}")
    return transfers

# # Use the below to generate fake street addresses (zip codes need to still be manually cleaned up)
# def generate_street_addresses(num: int) -> list[str]:
#     addresses = []
#     for _ in range(num):
#         address = fake.address().replace("\n", ", ")
#         addresses.append(address)
#     print(f"---\nGenerated {len(addresses)} synthetic street addresses.\n")
#     for a in addresses:
#         print(a)
#     return addresses


if __name__ == "__main__":
    _ = generate_person_profiles(NUM_RECORDS)
    accounts = generate_bank_accounts(NUM_RECORDS)
    transfers = generate_transfers(accounts)
    # _ = generate_street_addresses(20)