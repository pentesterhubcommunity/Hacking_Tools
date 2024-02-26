# Cache Poisoning Program

## Overview
This program demonstrates a basic example of cache poisoning, a security vulnerability that can lead to various attacks by corrupting data stored in caches.

## Prerequisites
Before running this program, ensure you have the following installed:
- gcc (GNU Compiler Collection)
- libcurl (curl library for URL interactions)

## Compilation
To compile the program, run the following command:
```
gcc chache_poisoning.c -o chache_poisoning -lcurl

```

## Execution
After successful compilation, execute the program using the following command:
```
./chache_poisoning

```
## In my case I run:
```
gcc chache_poisoning.c -o chache_poisoning -lcurl && ./chache_poisoning

```
## Expected Output
Upon execution, the program may display output indicating its actions or any results of cache poisoning attempts. Analyze the output carefully for any signs of unexpected behavior or security vulnerabilities.

## Caution
- **Permission**: Ensure you have explicit permission to run this program, especially since it involves security-related concepts like cache poisoning.
- **Review**: Thoroughly review the code (`chache_poisoning.c`) before running it to understand its purpose and implications.
- **Security**: Run the program in a controlled environment to minimize any potential risks or impacts on your system or network.

## Disclaimer
This program is provided for educational or testing purposes only. The author(s) do not take responsibility for any misuse or unauthorized use of this software.
