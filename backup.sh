#!/bin/bash

# Create backup directories with timestamps
#mkdir -p /home/hugoh/zip-backups/world/
#mkdir -p /home/hugoh/zip-backups/world_nether/
#mkdir -p /home/hugoh/zip-backups/world_the_end/
#mkdir -p /home/hugoh/zip-backups/plugins/

# Execute zip commands
zip -r /home/hugoh/zip-backups/world/$(date +%Y-%m-%d_%H-%M-%S).zip /home/hugoh/minecraft/world && \
zip -r /home/hugoh/zip-backups/world_nether/$(date +%Y-%m-%d_%H-%M-%S).zip /home/hugoh/minecraft/world_nether && \
zip -r /home/hugoh/zip-backups/world_the_end/$(date +%Y-%m-%d_%H-%M-%S).zip /home/hugoh/minecraft/world_the_end && \
zip -r /home/hugoh/zip-backups/plugins/$(date +%Y-%m-%d_%H-%M-%S).zip /home/hugoh/minecraft/plugins

# Define backup directories
backup_dirs=("/home/hugoh/zip-backups/world/" "/home/hugoh/zip-backups/world_nether/" "/home/hugoh/zip-backups/world_the_end/" "/home/hugoh/zip-backups/plugins/")

# Current date and time in the same format as filenames
current_date=$(date +%Y-%m-%d_%H-%M-%S)

# Loop over each backup directory
for dir in "${backup_dirs[@]}"; do
    # List all files in the directory
    ls -l $dir | awk '{print $9}' | while read file; do
        # Extract the timestamp from the filename
        file_date=$(echo $file | awk -F_ '{print $1}')
        
        # Convert the file date and current date to Unix timestamp for comparison
        file_timestamp=$(date -d"$file_date" +%s)
        current_timestamp=$(date -d"$current_date" +%s)

        # Calculate the difference in days
        diff=$(( (current_timestamp - file_timestamp) / 86400 ))

        # If the file was created more than 2 days ago, delete it
        if (( diff > 2 )); then
            rm $dir/$file
        fi
    done
done
find /home/hugoh/zip-backups/* -mtime +2 -type d -exec rm -rf {} +
