# SSRF (Server-Side Request Forgery) Exploit Demonstration

This repository contains a simple demonstration of a Server-Side Request Forgery (SSRF) exploit using C and libcurl.

## Prerequisites

Before running the program, ensure you have the following prerequisites installed on your system:

- GCC (GNU Compiler Collection)
- libcurl library

## Installation

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/saidehossain/hacking_with_c.git
    ```

2. Navigate to the repository directory:

    ```bash
    cd ssrf
    ```

## Compilation

Compile the `ssrf.c` program using GCC:

```bash
gcc ssrf.c -o ssrf -lcurl
```

## Usage

After compilation, execute the `ssrf` binary:

```bash
./ssrf
```

The program will demonstrate a simple SSRF attack by sending a request to a specified URL.

## Example

```bash
./ssrf
```

Output:

```
Successfully sent SSRF request to https://example.com
```

## For me I run:
```
cd "/home/kali/Desktop/C/" && gcc ssrf.c -o ssrf -lcurl && "/home/kali/Desktop/C/"ssrf

```
## Notes

- This is a basic demonstration intended for educational purposes only. Do not use this code for malicious purposes.
- Ensure that you have permission to test SSRF on the target URL. Unauthorized testing could lead to legal consequences.

## Disclaimer

The author of this code is not responsible for any misuse or damage caused by the exploitation of SSRF vulnerabilities. Use at your own risk.
