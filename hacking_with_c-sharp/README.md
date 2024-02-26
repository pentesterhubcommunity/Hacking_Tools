# Hacking with C# Tools

This repository showcases various hacking techniques implemented using the C# programming language. These tools cover network reconnaissance, system manipulation, and other aspects of cybersecurity, demonstrating the power of C# in ethical hacking experiments.

## Running the Tools

### Debian Linux

1. **Install Mono**: Mono is required to run .NET applications on Linux. You can install it using the following command:
   
   ```
   sudo apt-get install mono-complete
   ```

2. **Compile and Run**:
   - Navigate to the directory containing the C# source files.
   - Compile the C# code into executable binaries using the `mcs` compiler:
   
     ```
     mcs YourCSharpTool.cs
     ```
   
   - Run the compiled executable with Mono:
   
     ```
     mono YourCSharpTool.exe
     ```

### Windows

1. **Install .NET Runtime**: If not already installed, you'll need to install the .NET Runtime for Windows. You can download it from the official Microsoft website.

2. **Compile and Run**:
   - Open Command Prompt or PowerShell.
   - Navigate to the directory containing the C# source files.
   - Compile the C# code into executable binaries using the `csc` compiler:
   
     ```
     csc YourCSharpTool.cs
     ```
   
   - Run the compiled executable:
   
     ```
     YourCSharpTool.exe
     ```

### macOS

1. **Install Mono**: Similar to Debian Linux, you'll need to install Mono on macOS. You can download it from the Mono Project website or use package managers like Homebrew.

2. **Compile and Run**:
   - Open Terminal.
   - Navigate to the directory containing the C# source files.
   - Compile the C# code into executable binaries using the `mcs` compiler:
   
     ```
     mcs YourCSharpTool.cs
     ```
   
   - Run the compiled executable with Mono:
   
     ```
     mono YourCSharpTool.exe
     ```

## Legal and Ethical Considerations

Ensure that you have proper authorization before using these tools on any system. Unauthorized use may lead to legal consequences. Always prioritize ethical use and adhere to applicable laws and regulations.
