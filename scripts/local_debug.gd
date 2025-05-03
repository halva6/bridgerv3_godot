extends Node

# Counts how many times a specific number appears in a 2D matrix
# Parameters:
#   matrix: 2D array (Array) to search through
#   num: The number (int) to count occurrences of
# Returns: Total count (int) of the number in the matrix
func count_numbers_in_matrix(matrix: Array, num: int) -> int:
	var count_num: int = 0  # Initialize counter
	
	# Iterate through each row in the matrix
	for i in range(len(matrix)):
		# Add the count of 'num' in current row to total
		count_num += matrix[i].count(num)
	
	return count_num  # Return final count



# Prints counts for multiple numbers in a matrix
# Parameters:
#   matrix: 2D array (Array) to analyze
#   numbers: Array of numbers to count (defaults to [-1,0,1,2,3,4])
# Returns: Nothing (void) - only prints results
func print_count_numbers(matrix: Array, numbers: Array = [-1,0,1,2,3,4]) -> void:
	# Process each number in the numbers array
	for number in numbers:
		# Print formatted count result for current number
		print("Count of number " + str(number) + " in matrix: " + 
			  str(count_numbers_in_matrix(matrix, number)))


# Prints a 2D array (matrix) in a formatted way to the Godot console.
# Handles alignment, empty matrices, and dynamic sizing.
# Colors: 1 and 3 in green, 2 and 4 in red, others in white.
# Negative numbers are replaced with simple '-'.
#
# @param matrix: The 2D array to print (Array[Array]).
# @param header: Optional header text (String). Defaults to "".
func print_matrix(matrix: Array, header: String = "") -> void:
	# Print optional header if provided
	if header != "":
		print_rich(header)
	
	# Early return if the matrix is empty
	if matrix.is_empty():
		print_rich("[color=white][] (Empty matrix)[/color]")
		return
	
	# --- Calculate max element length for alignment ---
	var max_length := 1  # Minimum length is 1 (for '-')
	
	# Iterate through all elements to find the maximum length
	for row in matrix:
		for element in row:
			var element_str := "-" if _is_negative(element) else str(element)
			if element_str.length() > max_length:
				max_length = element_str.length()
	
	# --- Print the matrix dimensions ---
	print_rich("[color=white]Matrix [", matrix.size(), "x", matrix[0].size(), "]:[/color]")
	
	# --- Print each row with formatting ---
	for row in matrix:
		var row_str := "[color=white]| [/color]"  # Start row with a boundary
		
		# Add each element (right-padded for alignment)
		for element in row:
			var display_str := "-" if _is_negative(element) else str(element)
			var colored_element: String
			
			# Apply color based on element value (only check non-negative numbers)
			if not _is_negative(element):
				if element == 1 or element == 3:
					colored_element = "[color=green]" + display_str + "[/color]"
				elif element == 2 or element == 4:
					colored_element = "[color=red]" + display_str + "[/color]"
				else:
					colored_element = "[color=white]" + display_str + "[/color]"
			else:
				colored_element = "[color=white]" + display_str + "[/color]"
			
			# Add padding (using white spaces for alignment)
			row_str += colored_element.rpad(max_length) + " "
		
		row_str += "[color=white]|[/color]"  # Close row boundary
		print_rich(row_str)   # Print the formatted row

# Helper function to check if a value is negative
func _is_negative(value) -> bool:
	if typeof(value) == TYPE_INT or typeof(value) == TYPE_FLOAT:
		return value < 0
	return false
