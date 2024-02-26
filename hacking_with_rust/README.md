# Hacking with Rust

Welcome to the "Hacking with Rust" repository! This repository showcases diverse hacking techniques built using the Rust programming language. From network reconnaissance to system manipulation, explore the power of Rust in cybersecurity. This project is ideal for security professionals and enthusiasts interested in ethical hacking experiments.

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Contributing](#contributing)
6. [License](#license)

## Introduction

"Hacking with Rust" demonstrates various hacking techniques implemented in Rust. The tools provided cover a range of cybersecurity tasks, including network reconnaissance, system manipulation, cryptography, web exploitation, forensics, and exploit development.

## Prerequisites

Before running the hacking tools, ensure you have the following prerequisites installed:

- **Rust**: Make sure you have Rust installed on your system. You can download it from [here](https://www.rust-lang.org/tools/install).

## Installation

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/saidehossain/hacking_with_rust.git
    ```

2. Navigate to the project directory:

    ```bash
    cd hacking-with-rust
    ```

3. Build the project using Cargo, Rust's package manager:

    ```bash
    cargo build --release
    ```

## Usage

### Network Reconnaissance

- **Tool 1: Network Scanner**
  
  Description: This tool scans the network for active hosts and open ports.
  
  Usage:
  
  ```bash
  cargo run --release --bin network-scanner
  ```

### System Manipulation

- **Tool 2: File Manipulator**
  
  Description: This tool manipulates files on the system.
  
  Usage:
  
  ```bash
  cargo run --release --bin file-manipulator
  ```

### Cryptography

- **Tool 3: Encryption Tool**
  
  Description: This tool performs encryption using AES algorithm.
  
  Usage:
  
  ```bash
  cargo run --release --bin encryption-tool
  ```

### Web Exploitation

- **Tool 4: Web Scanner**
  
  Description: This tool scans web applications for vulnerabilities.
  
  Usage:
  
  ```bash
  cargo run --release --bin web-scanner
  ```

### Forensics

- **Tool 5: Disk Analyzer**
  
  Description: This tool analyzes disk images for forensic purposes.
  
  Usage:
  
  ```bash
  cargo run --release --bin disk-analyzer
  ```

### Exploit Development

- **Tool 6: Exploit Generator**
  
  Description: This tool generates exploits for security vulnerabilities.
  
  Usage:
  
  ```bash
  cargo run --release --bin exploit-generator
  ```

## Contributing

Contributions to the "Hacking with Rust" repository are welcome! If you have ideas for new hacking tools or improvements to existing ones, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
