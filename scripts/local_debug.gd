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
#
# @param matrix: The 2D array to print (Array[Array]).
# @param header: Optional header text (String). Defaults to "".
func print_matrix(matrix: Array, header: String = "") -> void:
	# Print optional header if provided
	if header != "":
		print(header)
	
	# Early return if the matrix is empty
	if matrix.is_empty():
		print("[] (Empty matrix)")
		return
	
	# --- Calculate max element length for alignment ---
	var max_length := 0  # Track the longest string representation
	
	# Iterate through all elements to find the maximum length
	for row in matrix:
		for element in row:
			var element_str := str(element)  # Convert any type to string
			if element_str.length() > max_length:
				max_length = element_str.length()
	
	# --- Print the matrix dimensions ---
	print("Matrix [", matrix.size(), "x", matrix[0].size(), "]:")
	
	# --- Print each row with formatting ---
	for row in matrix:
		var row_str := "| "  # Start row with a boundary
		
		# Add each element (right-padded for alignment)
		for element in row:
			row_str += str(element).rpad(max_length) + " "  # Align right
		
		row_str += "|"  # Close row boundary
		print(row_str)   # Print the formatted row
