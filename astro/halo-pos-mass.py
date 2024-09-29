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

# Extract halo positions and masses
halo_pos_x = s[:, 8]
halo_pos_y = s[:, 9]
halo_pos_z = s[:, 10]
halo_mass = s[:, 2]

# Create the output array for halo positions
halo_pos = np.vstack((halo_pos_x, halo_pos_y, halo_pos_z)).T

# Create output filenames with the correct suffix
halo_pos_file = os.path.join(output_dir, f'halo_pos_{output_suffix}.npy')
halo_mass_file = os.path.join(output_dir, f'halo_mass_{output_suffix}.npy')

# Save the arrays
np.save(halo_pos_file, halo_pos)
np.save(halo_mass_file, halo_mass)

print(f"Input file: {input_file}")
print(f"Output folder: {output_dir}/")
print(f"Halo positions file: {halo_pos_file}")
print(f"Halo masses file: {halo_mass_file}")