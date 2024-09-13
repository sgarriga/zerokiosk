#!/bin/bash

# create mount point for RAM filesystem is it doesn't exist
if ! [ -d "/var/kiosk_files" ]; then
  sudo mkdir /var/kiosk_files
fi

# create a 1MB filesystem for images
RAM_FS=`grep ramfs /etc/fstab | awk '{ printf("%s", $2); }'`
if [ -z "$RAM_FS" ]; then
  echo 'ramfs /var/kiosk_files tmpfs nodev,nosuid,size=1M 0 0' | sudo tee -a /etc/fstab
  sudo mount -a
  sudo systemctl daemon-reload
fi

. $HOME/.kiosk.cfg

if ! [ -d "$RAM_FS/tmp" ]; then
  mkdir $RAM_FS/tmp
fi

# Temporary files to store file lists for comparison
PREV_FILE_LIST=$RAM_FS/tmp/prev
CURR_FILE_LIST=$RAM_FS/tmp/curr

# Get the page to display
wkhtmltoimage --format jpeg --height 1080 --width 1920 --disable-smart-width \
  $SOURCE_PAGE $RAM_FS/image.jpg

# Generate an initial file list
ls "$RAM_FS" > "$PREV_FILE_LIST"

#start feh initial
feh -F -D 5 "$RAM_FS" &

while true; do
  # Generate a current file list
  ls "$RAM_FS" > "$CURR_FILE_LIST"
  
  # Compare the previous and current file lists
  if ! cmp -s "$PREV_FILE_LIST" "$CURR_FILE_LIST"; then
    # If differences are found, terminate the current instance of feh
    pkill -f "feh -F -D 5 $RAM_FS"
    # Restart feh with the updated image directory and settings
    feh -F -D 5 "$RAM_FS" &
    
    # Update the previous file list for the next iteration
    mv -f "$CURR_FILE_LIST" "$PREV_FILE_LIST"
  fi
  
  # Wait for a specified interval before checking again
  sleep 30 

  # Get the page to display
  . $HOME/.kiosk.cfg
  wkhtmltoimage --format jpeg --height 1080 --width 1920 --disable-smart-width \
    $SOURCE_PAGE $RAM_FS/image.jpg
done

