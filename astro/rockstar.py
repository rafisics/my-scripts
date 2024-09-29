import os
import sys
import subprocess

def create_temp_config(config_file, outbase_path):
    # Read the original config file
    with open(config_file, 'r') as file:
        config_data = file.read()
    
    # Replace the placeholder with the user-defined OUTBASE path
    config_data = config_data.replace("{OUTBASE_PATH}", outbase_path)
    
    # Create a temporary config file
    temp_config_file = "custom_quickstart_temp.cfg"
    with open(temp_config_file, 'w') as file:
        file.write(config_data)

    # print(f"Created temporary config with OUTBASE set to: {outbase_path} in {temp_config_file}")
    return temp_config_file

def run_rockstar(temp_config_file, input_file):
    # Run the Rockstar command with the temporary config file
    command = ["./rockstar", "-c", temp_config_file, input_file]
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Rockstar encountered an error: {e}")
    else:
        print("Rockstar executed successfully.")

def cleanup(temp_config_file):
    # Remove the temporary config file
    try:
        os.remove(temp_config_file)
        # print(f"Deleted temporary config file: {temp_config_file}")
    except OSError as e:
        print(f"Error deleting temporary config file: {e}")

def main():
    # Check if enough arguments are provided
    if len(sys.argv) != 4:
        print("Usage: python run_rockstar.py <config_file> <input_file> <outbase_path>")
        sys.exit(1)

    # Get the arguments
    config_file = sys.argv[1]
    input_file = sys.argv[2]
    outbase_path = sys.argv[3]

    # Create a temporary config file and run Rockstar
    temp_config_file = create_temp_config(config_file, outbase_path)
    run_rockstar(temp_config_file, input_file)
    
    # Clean up the temporary config file
    cleanup(temp_config_file)

if __name__ == "__main__":
    main()