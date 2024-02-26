# Hacking with Haskell

Welcome to the "Hacking with Haskell" repository! This repository showcases diverse hacking techniques built using the Haskell programming language. From network reconnaissance to system manipulation, explore the power of Haskell in cybersecurity. This project is ideal for security professionals and enthusiasts interested in ethical hacking experiments.

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Contributing](#contributing)
6. [License](#license)

## Introduction

"Hacking with Haskell" demonstrates various hacking techniques implemented in Haskell. The tools provided cover a range of cybersecurity tasks, including network reconnaissance, system manipulation, cryptography, web exploitation, forensics, and exploit development.

## Prerequisites

Before running the hacking tools, ensure you have the following prerequisites installed:

- **Haskell Platform**: Make sure you have Haskell Platform installed on your system. You can download it from [here](https://www.haskell.org/platform/).

## Installation

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/saidehossain/hacking_with_haskell.git
    ```

2. Navigate to the project directory:

    ```bash
    cd hacking-with-haskell
    ```

3. Install the dependencies using Cabal:

    ```bash
    cabal update
    cabal install --only-dependencies
    ```

## Usage

### Network Reconnaissance

- **Tool 1: Network Scanner**
  
  Description: This tool scans the network for active hosts and open ports.
  
  Usage:
  
  ```bash
  cd network-recon
  cabal run network-scanner
  ```

### System Manipulation

- **Tool 2: File Manipulator**
  
  Description: This tool manipulates files on the system.
  
  Usage:
  
  ```bash
  cd system-manipulation
  cabal run file-manipulator
  ```

### Cryptography

- **Tool 3: Encryption Tool**
  
  Description: This tool performs encryption using AES algorithm.
  
  Usage:
  
  ```bash
  cd cryptography
  cabal run encryption-tool
  ```

### Web Exploitation

- **Tool 4: Web Scanner**
  
  Description: This tool scans web applications for vulnerabilities.
  
  Usage:
  
  ```bash
  cd web-exploitation
  cabal run web-scanner
  ```

### Forensics

- **Tool 5: Disk Analyzer**
  
  Description: This tool analyzes disk images for forensic purposes.
  
  Usage:
  
  ```bash
  cd forensics
  cabal run disk-analyzer
  ```

### Exploit Development

- **Tool 6: Exploit Generator**
  
  Description: This tool generates exploits for security vulnerabilities.
  
  Usage:
  
  ```bash
  cd exploit-development
  cabal run exploit-generator
  ```

## Contributing

Contributions to the "Hacking with Haskell" repository are welcome! If you have ideas for new hacking tools or improvements to existing ones, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
