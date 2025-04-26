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

def search_in_gd_files(directory, search_pattern):
    """
    Searches for a given pattern in all .gd files within a directory (including subdirectories).
    Prints the filename and line numbers where matches are found.

    Args:
        directory (str): The root directory to search in.
        search_pattern (str): The regex pattern or string to search for.
    """
    # Compile the regex pattern for efficient reuse
    pattern = re.compile(search_pattern)
    
    # Walk through all files and subdirectories
    for root, dirs, files in os.walk(directory):
        for filename in files:
            # Only process .gd files
            if filename.endswith('.gd'):
                filepath = os.path.join(root, filename)
                
                try:
                    # Open the file and read lines
                    with open(filepath, 'r', encoding='utf-8') as file:
                        for line_num, line in enumerate(file, start=1):
                            # Search for the pattern in the current line
                            if pattern.search(line):
                                print(f"Found in '{filepath}', line {line_num}:")
                                print(f"  {line.strip()} \n")
                except (IOError, UnicodeDecodeError) as e:
                    print(f"Error reading {filepath}: {e}")
                    continue

def fix_assignment_spacing_in_gd_files(directory):
    """
    Processes all .gd files in the given directory (and subdirectories) to ensure:
    - Single '=' has a space after it (but not before).
    - Double '==' has a space after it (but not before).
    Skips cases where the spacing is already correct.
    """
    # Regex explanations:
    # r'(?<!\s)=(?!\s|=)'  → Matches '=' not surrounded by spaces or part of '=='
    # r'(?<!\s)==(?!\s)'   → Matches '==' not followed by a space
    pattern_single_eq = re.compile(r'(?<!\s)=(?!\s|=)')
    pattern_double_eq = re.compile(r'(?<!\s)==(?!\s)')
    
    modified_files = 0
    
    for root, dirs, files in os.walk(directory):
        for filename in files:
            if not filename.endswith('.gd'):
                continue
            
            filepath = os.path.join(root, filename)
            modified = False
            
            try:
                with open(filepath, 'r', encoding='utf-8') as file:
                    lines = file.readlines()
                
                new_lines = []
                for line in lines:
                    # Process single '=' first (important to avoid overlapping matches)
                    new_line = pattern_single_eq.sub('= ', line)
                    # Then process '=='
                    new_line = pattern_double_eq.sub('== ', new_line)
                    
                    if new_line != line:
                        modified = True
                    new_lines.append(new_line)
                
                if modified:
                    with open(filepath, 'w', encoding='utf-8') as file:
                        file.writelines(new_lines)
                    modified_files += 1
                    print(f"Fixed spacing in: {filepath}")
            
            except (IOError, UnicodeDecodeError) as e:
                print(f"Error processing {filepath}: {e}")
    
    print(f"\nDone. Modified {modified_files} files.")

if __name__ == "__main__":
    # Prompt the user to enter the directory path   

    # User input for directory and search pattern
    target_directory = "/home/jason/Workspaces/GameEngines/Godot/bridgerv3_godot/scripts" #input("Enter the directory to search in: ")
    replace_spaces_in_files(target_directory)  
    fix_assignment_spacing_in_gd_files(target_directory)


    search_query = input("Enter the text or regex pattern to search for: ")
    # Start the search
    print(f"\nSearching for '{search_query}' in .gd files under '{target_directory}'...\n")
    search_in_gd_files(target_directory, search_query)

