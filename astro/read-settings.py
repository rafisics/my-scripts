import sys

def read_settings(file_path):
    settings = {
        'tiling factor': None,
        'seed': None,
        'boxsize': None,
        'Ngrid': None
    }

    try:
        with open(file_path, 'r') as file:
            for line in file:
                # Remove comments from the line
                line = line.split('#')[0].strip()

                # Extract values for specific settings
                if 'tiling factor' in line:
                    settings['tiling factor'] = line.split('=')[1].strip()
                elif 'seed' in line:
                    settings['seed'] = line.split('=')[1].strip()
                elif 'boxsize' in line:
                    settings['boxsize'] = line.split('=')[1].strip()
                elif 'Ngrid' in line:
                    settings['Ngrid'] = line.split('=')[1].strip()
    except FileNotFoundError:
        print(f"Error: The file '{file_path}' does not exist.")
        sys.exit(1)

    return settings

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python read-settings.py <settings_file>")
        sys.exit(1)

    settings_file = sys.argv[1]
    settings = read_settings(settings_file)

    # Get the file name (without the path and extension)
    file_name = settings_file.split('/')[-1].split('.')[0]

    # Format the output
    output = f"{file_name} : tiling factor = {settings['tiling factor']}, seed = {settings['seed']}, boxsize = {settings['boxsize']}, Ngrid = {settings['Ngrid']},"
    print(output)