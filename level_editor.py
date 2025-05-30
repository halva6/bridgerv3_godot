import tkinter as tk
from tkinter import simpledialog, messagebox, filedialog
import json

class MatrixApp:
    def __init__(self, root):
        """
        Initialize the Matrix Editor application.
        
        Args:
            root: The root Tkinter window.
        """
        self.root = root
        root.title("Matrix Editor")
        
        # Meta data as a list of dictionaries (key, value)
        self.meta = [{"key": "name", "value": "unknown"}, {"key": "description", "value": ""}, {"key" : "simulation_time", "value": ""}, {"key" : "is_multiplayer", "value": "false"}, {"key": "start_player", "value": ""}] 
        self.meta_rows = 2  # Initial rows: name and description
        
        # Matrix data
        self.matrix = []
        self.buttons = []  # To store the matrix buttons
        
        # Set up the user interface
        self.setup_ui()
    
    def setup_ui(self):
        """
        Set up the main user interface with buttons and frames.
        """
        # Button to edit meta data
        tk.Button(self.root, text="Edit Meta Data", command=self.edit_meta).pack(pady=5)
        
        # Button to set matrix size
        tk.Button(self.root, text="Set Matrix Size", command=self.set_matrix_size).pack(pady=5)
        
        # Frame to display the matrix
        self.matrix_frame = tk.Frame(self.root)
        self.matrix_frame.pack(pady=10)
        
        # Button to load JSON file
        tk.Button(self.root, text="Load JSON", command=self.load_json).pack(pady=5)
        
        # Button to export JSON file
        tk.Button(self.root, text="Export JSON", command=self.export_json).pack(pady=5)
    
    def edit_meta(self):
        """
        Open a window to edit meta data.
        Each meta data entry is displayed as a key-value pair.
        """
        meta_window = tk.Toplevel(self.root)
        meta_window.title("Edit Meta Data")
        
        self.meta_entries = []
        for i, item in enumerate(self.meta):
            # Label and entry for key
            tk.Label(meta_window, text="Key:").grid(row=i, column=0, padx=5, pady=2)
            key_entry = tk.Entry(meta_window)
            key_entry.insert(0, item["key"])
            key_entry.grid(row=i, column=1, padx=5, pady=2)
            
            # Label and entry for value
            tk.Label(meta_window, text="Value:").grid(row=i, column=2, padx=5, pady=2)
            value_entry = tk.Entry(meta_window)
            value_entry.insert(0, item["value"])
            value_entry.grid(row=i, column=3, padx=5, pady=2)
            
            self.meta_entries.append((key_entry, value_entry))
        
        # Button to add a new meta data row
        tk.Button(meta_window, text="+ Add Meta Data", command=lambda: self.add_meta_row(meta_window)).grid(row=len(self.meta), column=0, columnspan=2, pady=5)
        # Button to remove a meta data row
        tk.Button(meta_window, text="Remove Row", command=lambda: self.remove_meta_row(meta_window)).grid(row=len(self.meta), column=2, columnspan=2, pady=5)
        # Button to save meta data
        tk.Button(meta_window, text="Save", command=lambda: self.save_meta(meta_window)).grid(row=len(self.meta)+1, column=0, columnspan=4, pady=5)
    
    def add_meta_row(self, window):
        """
        Add a new row for editing a new meta data key-value pair.
        
        Args:
            window: The window where the meta data is edited.
        """
        i = len(self.meta_entries)
        tk.Label(window, text="Key:").grid(row=i, column=0, padx=5, pady=2)
        key_entry = tk.Entry(window)
        key_entry.grid(row=i, column=1, padx=5, pady=2)
        
        tk.Label(window, text="Value:").grid(row=i, column=2, padx=5, pady=2)
        value_entry = tk.Entry(window)
        value_entry.grid(row=i, column=3, padx=5, pady=2)
        
        self.meta_entries.append((key_entry, value_entry))
    
    def remove_meta_row(self, window):
        """
        Remove the last meta data row from the editing window.
        
        Args:
            window: The window where the meta data is edited.
        """
        if len(self.meta_entries) > 0:
            for widget in window.grid_slaves(row=len(self.meta_entries)-1):
                widget.destroy()
            self.meta_entries.pop()
    
    def save_meta(self, window):
        """
        Save the edited meta data and close the window.
        
        Args:
            window: The window where the meta data is edited.
        """
        self.meta = []
        for key_entry, value_entry in self.meta_entries:
            key = key_entry.get()
            value = value_entry.get()
            if key:
                self.meta.append({"key": key, "value": value})
        window.destroy()
    
    def set_matrix_size(self):
        """
        Set the size of the matrix (number of rows and columns).
        Prompts the user for input and updates the matrix.
        """
        rows = simpledialog.askinteger("Matrix Size", "Number of rows:", parent=self.root, minvalue=5, maxvalue=17)
        if rows is None: return
        cols = simpledialog.askinteger("Matrix Size", "Number of columns:", parent=self.root, minvalue=5, maxvalue=17)
        if cols is None: return
        
        self.update_meta_size(rows, cols)
        self.matrix = [[0 for _ in range(cols)] for _ in range(rows)]
        self.update_matrix_display()
    
    def update_meta_size(self, rows, cols):
        """
        Update the meta data with the current matrix size.
        
        Args:
            rows: Number of rows in the matrix.
            cols: Number of columns in the matrix.
        """
        size_keys = ["rows", "columns"]
        for key in size_keys:
            found = False
            for item in self.meta:
                if item["key"] == key:
                    item["value"] = str(rows if key == "rows" else cols)
                    found = True
                    break
            if not found:
                self.meta.append({"key": key, "value": str(rows if key == "rows" else cols)})
    
    def update_matrix_display(self):
        """
        Update the display of the matrix in the GUI.
        Each matrix cell is represented by a button.
        """
        for widget in self.matrix_frame.winfo_children():
            widget.destroy()
        self.buttons = []
        
        for i in range(len(self.matrix)):
            row_buttons = []
            for j in range(len(self.matrix[0])):
                btn = tk.Button(
                    self.matrix_frame,
                    text=str(self.matrix[i][j]),
                    width=5,
                    height=2,
                    relief="solid"
                )
                # Left click: increase value by 1
                btn.bind("<Button-1>", lambda e, i=i, j=j: self.on_click(e, i, j, 1))
                # Right click: decrease value by 1
                btn.bind("<Button-3>", lambda e, i=i, j=j: self.on_click(e, i, j, -1))
                btn.grid(row=i, column=j, padx=2, pady=2)
                row_buttons.append(btn)
                self.update_button_color(btn, self.matrix[i][j])
            self.buttons.append(row_buttons)
    
    def update_button_color(self, btn, value):
        """
        Update the background color of a button based on its value.
        
        Args:
            btn: The button to update.
            value: The value of the matrix cell.
        """
        if value in (-2, -1):
            btn.config(bg="gray70")
        elif value == 1:
            btn.config(bg="green")
        elif value == 2:
            btn.config(bg="red")
        elif value == 3:
            btn.config(bg="dark green")
        elif value == 4:
            btn.config(bg="dark red")
        else:
            btn.config(bg="lightgray")
    
    def on_click(self, event, i, j, delta):
        """
        Handle a click on a matrix cell (button).
        Update the value and the button display.
        
        Args:
            event: The event object (not used).
            i: Row index of the cell.
            j: Column index of the cell.
            delta: Amount to change the value (+1 or -1).
        """
        self.matrix[i][j] += delta
        self.buttons[i][j].config(text=str(self.matrix[i][j]))
        self.update_button_color(self.buttons[i][j], self.matrix[i][j])
    
    def export_json(self):
        """
        Export the current matrix and meta data to a JSON file.
        """
        set_matrix_to_int(self.matrix)
        
        meta_dict = {item["key"]: item["value"] for item in self.meta}
        data = {
            "meta": meta_dict,
            "matrix": self.matrix
        }
        json_data = json.dumps(data, indent=2)
        
        file_path = filedialog.asksaveasfilename(
            defaultextension=".json",
            filetypes=[("JSON files", "*.json")]
        )
        if file_path:
            with open(file_path, "w") as f:
                f.write(json_data)
            messagebox.showinfo("Success", "Matrix successfully exported!")
    
    def load_json(self):
        """
        Load a matrix and meta data from a JSON file.
        Update the GUI with the loaded data.
        """
        file_path = filedialog.askopenfilename(
            filetypes=[("JSON files", "*.json")]
        )
        if file_path:
            try:
                with open(file_path, "r") as f:
                    data = json.load(f)
                
                # Load meta data
                self.meta = []
                for key, value in data["meta"].items():
                    self.meta.append({"key": key, "value": str(value)})
                
                # Load matrix
                self.matrix = data["matrix"]
                set_matrix_to_int(self.matrix)
                
                # Update display
                self.update_matrix_display()
                messagebox.showinfo("Success", "JSON successfully loaded!")
            except Exception as e:
                messagebox.showerror("Error", f"Error loading file:\n{e}")

def set_matrix_to_int(matrix):
    for i in range(len(matrix)):
        for j in range(len(matrix)):
            matrix[i][j] = int(matrix[i][j])

if __name__ == "__main__":
    root = tk.Tk()
    app = MatrixApp(root)
    root.mainloop()
