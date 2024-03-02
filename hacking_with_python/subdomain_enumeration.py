import asyncio
import requests
import aiohttp
import dns.asyncresolver
import concurrent.futures
import sublist3r
from colorama import Fore, Style

async def sublist3r_enum(domain):
    print(Fore.BLUE + "Running Sublist3r..." + Style.RESET_ALL)
    try:
        subdomains = await sublist3r.main(domain, 40, None, engines=None, ports=None, silent=True, verbose=False, enable_bruteforce=False)
        print(Fore.GREEN + "Subdomains found via Sublist3r:" + Style.RESET_ALL)
        for subdomain in subdomains:
            print(subdomain)
    except Exception as e:
        print(Fore.RED + f"An error occurred: {e}" + Style.RESET_ALL)

async def crt_sh_enum(domain):
    print(Fore.BLUE + "Running crt.sh enumeration..." + Style.RESET_ALL)
    url = f"https://crt.sh/?q=%25.{domain}&output=json"
    try:
        async with aiohttp.ClientSession() as session:
            async with session.get(url) as response:
                if response.status == 200:
                    data = await response.json()
                    subdomains = set()
                    for entry in data:
                        name_value = entry['name_value']
                        subdomains.add(name_value)
                    print(Fore.GREEN + "Subdomains found via crt.sh:" + Style.RESET_ALL)
                    for subdomain in subdomains:
                        print(subdomain)
                else:
                    print(Fore.RED + "Failed to retrieve data from crt.sh" + Style.RESET_ALL)
    except aiohttp.ClientError as e:
        print(Fore.RED + f"An error occurred: {e}" + Style.RESET_ALL)

async def dns_enum(domain):
    print(Fore.BLUE + "Running DNS enumeration..." + Style.RESET_ALL)
    resolver = dns.asyncresolver.Resolver()
    try:
        answers = await resolver.resolve(domain, 'A')
        print(Fore.GREEN + "Subdomains found via DNS resolution:" + Style.RESET_ALL)
        for rdata in answers:
            print(rdata)
    except Exception as e:
        print(Fore.RED + f"An error occurred during DNS resolution: {e}" + Style.RESET_ALL)

async def main():
    domain = input("Enter your target domain: ")
    print("\nPerforming subdomain enumeration...\n")

    tasks = []
    tasks.append(sublist3r_enum(domain))
    tasks.append(crt_sh_enum(domain))
    tasks.append(dns_enum(domain))

    await asyncio.gather(*tasks)

if __name__ == "__main__":
    asyncio.run(main())
