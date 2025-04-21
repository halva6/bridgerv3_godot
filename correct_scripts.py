import os
import re

def replace_spaces_in_files(directory):
    # Iterate through all files in the specified directory
    for root, dirs, files in os.walk(directory):
        for filename in files:
            if not filename.endswith('.gd'):
                continue  # Skip non-.gd files
            
            filepath = os.path.join(root, filename)
            
            try:
                # Open the file in read mode and read its content
                with open(filepath, 'r', encoding='utf-8') as file:
                    content = file.read()
                
                # Replace every occurrence of four consecutive spaces with %09
                modified_content = re.sub(r' {4}', '%09', content)
                
                # If changes were made, write the modified content back to the file
                if modified_content != content:
                    with open(filepath, 'w', encoding='utf-8') as file:
                        file.write(modified_content)
                    print(f'Replacements made in {filepath}.')
                else:
                    print(f'No replacements needed in {filepath}.')
            
            except (IOError, UnicodeDecodeError) as e:
                print(f'Error processing {filepath}: {e}')

# Prompt the user to enter the directory path
directory = input('Enter the directory path: ')
replace_spaces_in_files(directory)