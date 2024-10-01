import numpy as np
import sys
import os

# Check if the script is run with an argument
if len(sys.argv) != 2:
    print("Usage: python halo-pos-mass.py <input_file>")
    sys.exit(1)

# Get the input file from the command-line argument
input_file = sys.argv[1]

# Extract the directory name and the identifier (which will be used as the suffix)
output_dir = os.path.dirname(input_file)
output_suffix = os.path.basename(output_dir).split('_')[-1]  # Extract '01', '02', etc.

# Load the data
s = np.loadtxt(input_file)

# Extract halo positions 
halo_pos_x = s[:, 8]
halo_pos_y = s[:, 9]
halo_pos_z = s[:, 10]

# Create the output array for halo positions
halo_pos = np.vstack((halo_pos_x, halo_pos_y, halo_pos_z)).T

# Extract the shape of halo positions
halo_pos_shape = halo_pos.shape

# print(f"Input file: {input_file}")
# print(f"Output folder: {output_dir}/")
print(f"Halo position shape in output_{output_suffix}: {halo_pos_shape}")