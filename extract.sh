#!/bin/bash

# extract.sh - Collects all files in the /lib folder into one minified text file
# Usage: ./extract.sh

# Set variables
SOURCE_DIR="./lib"
OUTPUT_FILE="app_content.txt"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' not found!"
    exit 1
fi

# Create or overwrite the output file with header
echo "# Flutter Project Knowledge Base" > "$OUTPUT_FILE"
echo "# Created on $(date)" >> "$OUTPUT_FILE"
echo "# Contents from $SOURCE_DIR directory" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Find all files in the source directory and append them to the output file
find "$SOURCE_DIR" -type f | sort | while read -r file; do
    # Add file header
    echo "## File: ${file#./}" >> "$OUTPUT_FILE"
    
    # Get file extension for code block
    extension="${file##*.}"
    echo "\`\`\`$extension" >> "$OUTPUT_FILE"
    
    # Minify content based on file type
    if [[ "$extension" == "dart" ]]; then
        # For Dart files: Remove comments and unnecessary whitespace
        cat "$file" | grep -v "^\s*\/\/" | grep -v "^\s*\/\*" | grep -v "^\s*\*" | grep -v "^\s*\*\/" | sed '/^\s*$/d' | tr -s ' ' >> "$OUTPUT_FILE" 2>/dev/null || echo "WARNING: Could not read file content" >> "$OUTPUT_FILE"
    elif [[ "$extension" == "json" ]]; then
        # For JSON files: Remove all whitespace
        cat "$file" | tr -d '\n\r\t ' >> "$OUTPUT_FILE" 2>/dev/null || echo "WARNING: Could not read file content" >> "$OUTPUT_FILE"
    elif [[ "$extension" == "yaml" || "$extension" == "yml" ]]; then
        # For YAML files: Preserve structure but remove comments
        cat "$file" | grep -v "^\s*#" | sed '/^\s*$/d' >> "$OUTPUT_FILE" 2>/dev/null || echo "WARNING: Could not read file content" >> "$OUTPUT_FILE"
    else
        # For all other files: Remove empty lines and trim whitespace
        cat "$file" | sed '/^\s*$/d' | sed 's/^[ \t]*//;s/[ \t]*$//' >> "$OUTPUT_FILE" 2>/dev/null || echo "WARNING: Could not read file content" >> "$OUTPUT_FILE"
    fi
    
    # Add file footer
    echo "\`\`\`" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

# Output summary
FILE_COUNT=$(find "$SOURCE_DIR" -type f | wc -l)
ORIGINAL_SIZE=$(find "$SOURCE_DIR" -type f -exec cat {} \; | wc -c)
MINIFIED_SIZE=$(cat "$OUTPUT_FILE" | wc -c)
REDUCTION=$((100 - (MINIFIED_SIZE * 100 / ORIGINAL_SIZE)))

echo "Done! $FILE_COUNT files collected into $OUTPUT_FILE"
echo "Original size: $ORIGINAL_SIZE bytes"
echo "Minified size: $MINIFIED_SIZE bytes"
echo "Size reduction: $REDUCTION%"

# Print the first few lines of the output file
echo "Preview of $OUTPUT_FILE:"
head -n 20 "$OUTPUT_FILE"