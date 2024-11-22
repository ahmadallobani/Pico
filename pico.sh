#!/bin/bash

# Source directories
SOURCE_FLASH_NUKE="/home/fakelaw/random/pico/flash/flash_nuke.uf2"
SOURCE_DRIVER="/home/fakelaw/random/pico/flash/adafruit-circuitpython-raspberry_pi_pico_w-en_US-9.2.0.uf2"
SOURCE_NEEDED_FILES="/home/fakelaw/random/pico/needed_files"

# Destination directories (dynamic RPI-RP2 detection)
# Find all RPI-RP2 mounts
RPI_RP2_DIRS=$(ls -d /media/fakelaw/RPI-RP2* 2>/dev/null)

if [ -z "$RPI_RP2_DIRS" ]; then
    echo "Error: No RPI-RP2 mount found!" >&2
    exit 1
fi

# If there are multiple directories, choose the first one (you can adjust this logic as needed)
DEST_RPI_RP2=$(echo "$RPI_RP2_DIRS" | head -n 1)

# Check if there are multiple directories and prompt the user to select one
if [ $(echo "$RPI_RP2_DIRS" | wc -l) -gt 1 ]; then
    echo "Multiple RPI-RP2 directories found:"
    select DEST_RPI_RP2 in $RPI_RP2_DIRS; do
        if [ -n "$DEST_RPI_RP2" ]; then
            echo "Selected: $DEST_RPI_RP2"
            break
        else
            echo "Invalid choice, please select a valid directory."
        fi
    done
fi

# Destination for CIRCUITPY
DEST_CIRCUITPY="/media/fakelaw/CIRCUITPY"

# Copy flash_nuke.uf2 to RPI-RP2
echo "Copying flash_nuke.uf2 to $DEST_RPI_RP2..."
cp "$SOURCE_FLASH_NUKE" "$DEST_RPI_RP2"
if [ $? -eq 0 ]; then
    echo "flash_nuke.uf2 copied successfully!"
else
    echo "Error copying flash_nuke.uf2" >&2
    exit 1
fi

# Wait for 10 seconds
echo "Waiting for 10 seconds..."
sleep 20

# Copy driver.uf2 to RPI-RP2
echo "Copying driver.uf2 to $DEST_RPI_RP2..."
cp "$SOURCE_DRIVER" "$DEST_RPI_RP2"
if [ $? -eq 0 ]; then
    echo "driver.uf2 copied successfully!"
else
    echo "Error copying driver.uf2" >&2
    exit 1
fi

# Wait for 20 seconds
echo "Waiting for 20 seconds..."
sleep 25

# Replace and override files on CIRCUITPY with the files from needed_files
echo "Replacing files in CIRCUITPY with files from needed_files..."
cp -r "$SOURCE_NEEDED_FILES"/* "$DEST_CIRCUITPY/"
if [ $? -eq 0 ]; then
    echo "Files replaced successfully in CIRCUITPY!"
else
    echo "Error replacing files in CIRCUITPY" >&2
    exit 1
fi

# Accept all changes and overrides automatically
echo "Changes accepted and files overwritten."

