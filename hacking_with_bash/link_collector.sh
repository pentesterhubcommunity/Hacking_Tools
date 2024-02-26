#!/bin/bash

echo "==========================================="

echo "all urls"

echo "==========================================="


# Function to extract parameters from a given input
extract_parameters() {
    grep -oE 'name="[^"]*"' | sed 's/name="//;s/"//'
}

# Function to extract links from JavaScript code
extract_links_from_js() {
    grep -oE '"(http|https)://[^"]+"' | sed 's/"//g'
}

# Function to extract input fields from JavaScript code
extract_inputs_from_js() {
    grep -oE 'document\.getElements(ByTagName|ByName|ByID)\((\"|\047)[^"\047]*' | extract_parameters
}

# Prompt user to enter the target website link
read -rp "Enter your target website link (include http/https): " URL

# Check if a URL is provided as an argument
if [ -z "$URL" ]; then
    echo "Error: No URL provided."
    exit 1
fi

# Temporary directory
temp_dir=$(mktemp -d)

# Download the entire website recursively
wget -q -r -l 1 -np -nd -P "$temp_dir" "$URL"

# Extract all the links using grep
echo "Links found on the website:"
grep -Eo '"(http|https)://[^"]+"' "$temp_dir"/* | \
# Filter out certain file extensions
grep -v -E '\.(js|css|png|jpg|jpeg|gif|svg|mp4|mp3|ico|pdf|zip|tar|gz|rar|exe|woff|woff2|ttf|otf|eot)$' | \
# Remove quotes from links
sed 's/"//g' >> urls-collection.txt

# Extract input fields and parameters from HTML files
echo "Input fields and parameters found on the website (HTML files):"
grep -H -Eo '<input[^>]*>|<textarea[^>]*>|<select[^>]*>' "$temp_dir"/* | \
while IFS= read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    input=$(echo "$line" | cut -d: -f2-)
    parameters=$(echo "$input" | extract_parameters)
    if [ -n "$parameters" ]; then
        # Construct parameterized URL
        parameterized_url="${URL}"
        for param in $parameters; do
            parameterized_url+="&${param}=<value>"
        done

        echo "File: $file"
        echo "Parameters: $parameters"
        echo "Parameterized URL: $parameterized_url"
        echo "$parameterized_url" >> urls-collection.txt
    fi
done

# Extract links from JavaScript files
echo "Links found in JavaScript files:"
find "$temp_dir" -type f -name "*.js" -print0 | while IFS= read -r -d '' file; do
    echo "File: $file"
    # shellcheck disable=SC2002
    cat "$file" | extract_links_from_js >> urls-collection.txt
done

# Extract input fields and parameters from JavaScript files
echo "Input fields and parameters found in JavaScript files:"
find "$temp_dir" -type f -name "*.js" -print0 | while IFS= read -r -d '' file; do
    echo "File: $file"
    # shellcheck disable=SC2002
    cat "$file" | extract_inputs_from_js | sed 's/^/Parameters: /' >> urls-collection.txt
    echo "URL: $URL" >> urls-collection.txt
done

# Remove all files except urls-collection.txt
# shellcheck disable=SC2115
rm -rf "$temp_dir"/*

echo "==========================================="

echo "only urls"

echo "==========================================="

#!/bin/bash

# Define the input file containing URLs
input_file="urls-collection.txt"

# Define the output file for filtered URLs
output_file="only-urls.txt"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file $input_file not found."
    exit 1
fi

# Clear the output file
# shellcheck disable=SC2188
> "$output_file"

# Read each line from the input file
while IFS= read -r line; do
    # Extract URLs from lines starting with "http://" or "https://"
    if [[ $line == http://* || $line == https://* ]]; then
        echo "$line" >> "$output_file"
    else
        # Extract URLs from lines containing "http://" or "https://"
        urls=$(echo "$line" | grep -oE '(http|https)://[^ ]+')
        if [ -n "$urls" ]; then
            echo "$urls" >> "$output_file"
        fi
    fi
done < "$input_file"

echo "Filtered URLs have been written to $output_file"

rm urls-collection.txt



cat only-urls.txt

echo "==========================================="

echo "check the only-urls.txt file in the same directory for all urls stored there"

echo "You can use these urls to your purpose"

echo "==========================================="