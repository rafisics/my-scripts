import numpy as np
import sys
import os

# Check if the script is run with an argument
if len(sys.argv) != 2:
    print("Usage: python void-pos-radii.py <input_file>")
    sys.exit(1)

# Get the input file from the command-line argument
input_file = sys.argv[1]

# Extract the directory name and the identifier (which will be used as the suffix)
output_dir = os.path.dirname(input_file)
output_suffix = os.path.basename(output_dir).split('_')[-1]  # Extract '01', '02', etc.

# Load the data
r = np.loadtxt(input_file)

# Extract void positions and radii
void_pos_x = r[:, 1]
void_pos_y = r[:, 2]
void_pos_z = r[:, 3]
void_r_eff = r[:, 4]

# Create the output array for void positions
void_pos = np.vstack((void_pos_x, void_pos_y, void_pos_z)).T

# Create output filenames with the correct suffix
void_pos_file = os.path.join(output_dir, f'void_pos_{output_suffix}.npy')
void_radii_file = os.path.join(output_dir, f'void_radii_{output_suffix}.npy')

# Save the arrays
np.save(void_pos_file, void_pos)
np.save(void_radii_file, void_r_eff)

print(f"Input file: {input_file}")
print(f"Output folder: {output_dir}/")
print(f"Void positions file: {void_pos_file}")
print(f"Void radii file: {void_radii_file}")