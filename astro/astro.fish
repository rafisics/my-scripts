set -x LD_LIBRARY_PATH /home/rafi/Documents/astrophysics/hdf5-1.14.3/build/lib $LD_LIBRARY_PATH

# For Gevolution & Screening

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

#########################################

# For Rockstar
function run_rockstar_g
    set start $argv[1]
    set end $argv[2]
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        # rockstar_g
        echo "Running Rockstar for output_$i... [Gevolution]"
        python ~/my-scripts/astro/rockstar.py custom_quickstart.cfg /mnt/ssd-ext/gevolution-phi/outputs/output_$i/lcdm_snap003_cdm /mnt/ssd-ext/gevolution-phi/rockstar-outputs/output_$i/
        echo "================================"
        # halo_pos_mass_g
        echo "Getting halo position and mass for output_$i... [Gevolution]"
        python ~/my-scripts/astro/halo-pos-mass.py /mnt/ssd-ext/gevolution-phi/rockstar-outputs/output_$i/halos_0.0.ascii 
        echo "================================"
    end
end

function run_rockstar_s
    set start $argv[1]
    set end $argv[2]
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        # rockstar_s
        echo "Running Rockstar for output_$i... [Screening]"
        python ~/my-scripts/astro/rockstar.py custom_quickstart.cfg /mnt/ssd-ext/screening-phi/outputs/output_$i/lcdm_snap003_cdm /mnt/ssd-ext/screening-phi/rockstar-outputs/output_$i/
        echo "================================"
        # halo_pos_mass_g
        echo "Getting halo position and mass for output_$i... [Screening]"
        python ~/my-scripts/astro/halo-pos-mass.py /mnt/ssd-ext/screening-phi/rockstar-outputs/output_$i/halos_0.0.ascii 
        echo "================================"
    end
end

function get_halo_pos_mass_g 
    set start $argv[1]
    set end $argv[2]
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        echo "Getting halo position and mass for output_$i... [Gevolution]"
        python ~/my-scripts/astro/halo-pos-mass.py /mnt/ssd-ext/gevolution-phi/rockstar-outputs/output_$i/halos_0.0.ascii 
        echo "================================"
    end
end

function get_halo_pos_mass_s 
    set start $argv[1]
    set end $argv[2]
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        echo "Getting halo position and mass for output_$i... [Screening]"
        python ~/my-scripts/astro/halo-pos-mass.py /mnt/ssd-ext/screening-phi/rockstar-outputs/output_$i/halos_0.0.ascii 
        echo "================================"
    end
end

#########################################

# For Revolver
function run_revolver_g
    set start $argv[1]
    set end $argv[2]
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        # revolver_g
        echo "Running Revolver for halo_pos_$i... [Gevolution]"
        TRACER_FILE=/mnt/ssd-ext/gevolution-phi/rockstar-outputs/output_$i/halo_pos_$i.npy python revolver.py --par parameters/custom_params.py
        echo "================================"
        # void_pos_radii_g
        echo "Getting void position and radii for output_$i... [Gevolution]"
        python ~/my-scripts/astro/void-pos-radii.py /mnt/ssd-ext/gevolution-phi/revolver-outputs/output_$i/zobov-voids_halo_{$i}_cat.txt
        echo "================================"
    end
end

function run_revolver_s
    set start $argv[1]
    set end $argv[2]
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        # revolver_s
        echo "Running Revolver for halo_pos_$i... [Screening]"
        TRACER_FILE=/mnt/ssd-ext/screening-phi/rockstar-outputs/output_$i/halo_pos_$i.npy python revolver.py --par parameters/custom_params.py
        echo "================================"
        # get_void_pos_radii_s
        echo "Getting void position and radii for output_$i... [Screening]"
        python ~/my-scripts/astro/void-pos-radii.py /mnt/ssd-ext/screening-phi/revolver-outputs/output_$i/zobov-voids_halo_{$i}_cat.txt
        echo "================================"
    end
end

function get_void_pos_radii_g 
    set start $argv[1]
    set end $argv[2]
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        echo "Getting void position and radii for output_$i... [Gevolution]"
        python ~/my-scripts/astro/void-pos-radii.py /mnt/ssd-ext/gevolution-phi/revolver-outputs/output_$i/zobov-voids_halo_{$i}_cat.txt
        echo "================================"
    end
end

function get_void_pos_radii_s 
    set start $argv[1]
    set end $argv[2]
    for i in (seq -f "%02g" $start $end)
        echo "================================"
        echo "Getting void position and radii for output_$i... [Screening]"
        python ~/my-scripts/astro/void-pos-radii.py /mnt/ssd-ext/screening-phi/revolver-outputs/output_$i/zobov-voids_halo_{$i}_cat.txt
        echo "================================"
    end
end
