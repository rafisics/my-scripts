# For Gevolution & Screening

set -x LD_LIBRARY_PATH /home/rafi/Documents/astrophysics/hdf5-1.14.3/build/lib $LD_LIBRARY_PATH

function run_gevolution
    set start $argv[1]
    set end $argv[2]
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        echo "Running Gevolution for settings_$i..."
        mpirun --oversubscribe -np 16 ./gevolution -n 4 -m 4 -s settings/settings_$i.ini
        echo "================================"
    end
end

function run_screening
    set start $argv[1]
    set end $argv[2]
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        echo "Running Screening for settings_$i..."
        mpirun --oversubscribe -np 16 ./gevolution -n 4 -m 4 -s settings/settings_$i.ini
        echo "================================"
    end
end

function set_mode
    set short_mode $argv[1]  # 'g' for Gevolution or 's' for Screening

    # Set $mode based on $short_mode
    if test $short_mode = "g"
        set -g mode "gevolution"
    else if test $short_mode = "s"
        set -g mode "screening"
    else
        echo "Invalid mode! Use 'g' for Gevolution or 's' for Screening."
        return 1
    end

    # Capitalize the first letter of $mode and store in $Mode
    set -g Mode (string sub -s 1 -l 1 $mode | string upper)(string sub -s 2 $mode)
end

function read_settings 
    set_mode $argv[1]  # 'g' for Gevolution or 's' for Screening
    set start $argv[2]
    set end $argv[3]
    echo "Reading the settings files... [$Mode]"
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        python ~/my-scripts/astro/read-settings.py ~/Documents/astrophysics/{$mode}/settings/settings_$i.ini
        echo "================================"
    end
end

function read_seed
    set_mode $argv[1]  # 'g' for Gevolution or 's' for Screening
    set start $argv[2]
    set end $argv[3]
    set seed_list  # an empty list to store the seed values

    echo "Reading the settings files... [$Mode]"

    for i in (seq -f "%02g" $start $end)
        # echo "================================"
        # Capture the output of the Python script (which prints only the seed value)
        set seed_value (python ~/my-scripts/astro/read-seed.py ~/Documents/astrophysics/{$mode}/settings/settings_$i.ini)
        
        # Append the seed value to the list
        set seed_list $seed_list $seed_value
        # echo "Seed value for settings_$i.ini: $seed_value"
        # echo "================================"
    end

    # Print the entire list of seed values
    echo "All seed values: $seed_list"
end

function create_settings_seed
    set_mode $argv[1]  # 'g' for Gevolution or 's' for Screening
    set start $argv[2]
    set end $argv[3]
    set seed 42 413 360 444 124 955 266 62 846 935 845 908 537 827 317 109 861 785 415 956 470  # list of 21 seeds

    for i in (seq -f "%02g" $start $end)
        set current_seed $seed[$i]  # Use $i directly as Fish array is 1-based

        echo "================================"
        echo "Create settings ($i) with seed=$current_seed..."

        # Create a temporary copy of custom_settings.ini
        cp settings/custom_settings.ini settings/settings_$i.ini

        # Update the temporary settings file with current seed and output path while preserving the format
        sed -i "s/^\(seed *= *\)[0-9]\{1,\}/\1$current_seed/" settings/settings_$i.ini
        sed -i "s|^output path * =.*|output path         = /mnt/ssd-ext/$mode-phi/outputs/output_$i/|" settings/settings_$i.ini

        # Remove the temporary settings file after the run
        # rm settings/settings_$i.ini

        echo "================================"
    end
end

function run_simulation
    set_mode $argv[1]  # 'g' for Gevolution or 's' for Screening
    set start $argv[2]
    set end $argv[3]
    set seed 42 413 360 444 124 955 266 62 846 935 845 908 537 827 317 109 861 785 415 956 470  # list of 21 seeds

    for i in (seq -f "%02g" $start $end)
        set current_seed $seed[$i]  # Use $i directly as Fish array is 1-based

        echo "================================"
        echo "Running $Mode for settings ($i) with seed=$current_seed..."

        # Create a copy of custom_settings.ini
        cp settings/custom_settings.ini settings/settings_$i.ini

        # Update the copied settings file with current seed and output path while preserving the format
        sed -i "s/^\(seed *= *\)[0-9]\{1,\}/\1$current_seed/" settings/settings_$i.ini
        sed -i "s|^output path * =.*|output path         = /mnt/ssd-ext/$mode-phi/outputs/output_$i/|" settings/settings_$i.ini

        # Run the simulation using the temporary settings file
        mpirun --oversubscribe -np 16 ./gevolution -n 4 -m 4 -s settings/settings_$i.ini

        # Remove the temporary settings file after the run
        rm settings/settings_$i.ini

        echo "================================"
    end
end

#########################################

# For Rockstar
function run_rockstar
    set_mode $argv[1]  # 'g' for Gevolution or 's' for Screening
    set start $argv[2]
    set end $argv[3]
    
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        # rockstar
        echo "Running Rockstar for output_$i... [$Mode]"
        python ~/my-scripts/astro/rockstar.py custom_quickstart.cfg /mnt/ssd-ext/{$mode}-phi/outputs/output_$i/lcdm_snap003_cdm /mnt/ssd-ext/{$mode}-phi/rockstar-outputs/output_$i/
        echo "================================"
        # halo_pos_mass
        echo "Getting halo position and mass for output_$i... [$Mode]"
        python ~/my-scripts/astro/halo-pos-mass.py /mnt/ssd-ext/{$mode}-phi/rockstar-outputs/output_$i/halos_0.0.ascii 
        echo "================================"
    end
end

function get_halo_pos_mass
    set_mode $argv[1]  # 'g' for Gevolution or 's' for Screening
    set start $argv[2]
    set end $argv[3]
    
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        echo "Getting halo position and mass for output_$i... [$Mode]"
        python ~/my-scripts/astro/halo-pos-mass.py /mnt/ssd-ext/{$mode}-phi/rockstar-outputs/output_$i/halos_0.0.ascii 
        echo "================================"
    end
end

function get_halo_pos_shape
    set_mode $argv[1]  # 'g' for Gevolution or 's' for Screening
    set start $argv[2]
    set end $argv[3]
    
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        # echo "Getting halo position shape for output_$i... [$Mode]"
        python ~/my-scripts/astro/halo-pos-shape.py /mnt/ssd-ext/{$mode}-phi/rockstar-outputs/output_$i/halos_0.0.ascii 
        echo "================================"
    end
end

#########################################

# For Revolver
function run_revolver
    set_mode $argv[1]  # 'g' for Gevolution or 's' for Screening
    set start $argv[2]
    set end $argv[3]

    for i in (seq -f "%02g" $start $end)
        echo "================================"
        # revolver
        echo "Running Revolver for halo_pos_$i... [$Mode]"
        TRACER_FILE=/mnt/ssd-ext/{$mode}-phi/rockstar-outputs/output_$i/halo_pos_$i.npy python revolver.py --par parameters/custom_params.py
        echo "================================"
        # void_pos_radii
        echo "Getting void position and radii for output_$i... [$Mode]"
        python ~/my-scripts/astro/void-pos-radii.py /mnt/ssd-ext/{$mode}-phi/revolver-outputs/output_$i/zobov-voids_halo_{$i}_cat.txt
        echo "================================"
    end
end

function get_void_pos_radii
    set_mode $argv[1]  # 'g' for Gevolution or 's' for Screening
    set start $argv[2]
    set end $argv[3]
      
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        echo "Getting void position and radii for output_$i... [$Mode]"
        python ~/my-scripts/astro/void-pos-radii.py /mnt/ssd-ext/{$mode}-phi/revolver-outputs/output_$i/zobov-voids_halo_{$i}_cat.txt
        echo "================================"
    end
end

function get_void_pos_shape
    set_mode $argv[1]  # 'g' for Gevolution or 's' for Screening
    set start $argv[2]
    set end $argv[3]
      
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        # echo "Getting void position shape for output_$i... [$Mode]"
        python ~/my-scripts/astro/void-pos-shape.py /mnt/ssd-ext/{$mode}-phi/revolver-outputs/output_$i/zobov-voids_halo_{$i}_cat.txt
        echo "================================"
    end
end