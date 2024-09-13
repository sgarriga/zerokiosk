
# Zero Kiosk: A Raspberry Pi Zero compatible kiosk 

Fork of https://github.com/alecmalloc/zeroscreen

This version creates a RAM-disk to hold images that feh will display.
The images are snapshots of an external webpage specified in the .kiosk.cfg file created by wkhtmltoimg.

### Flash SD card with Raspian with Desktop
### Ensure SSH is enabled
### Disable Screen Blanking**: Use `raspi-config` and select `2: Display Options` to disable screen blanking.
### Install Necessary Software
-   `sudo apt install feh` 
-   `sudo apt install unclutter` 
-   Download latest wkhtmltopdf bundle from https://wkhtmltopdf.org/downloads.html
-   `sudo apt install wkhtmltox_*.deb` 
### Clone this repository
-   `git clone https://github.com/sgarriga/zerokiosk.git` 
### Install

-   **Modify `kiosk.cfg` to point to the desired page
  ```
    cp kiosk.cfg ~/.kiosk.cfg
    sudo cp start_screen.sh /usr/local/bin/
    mkdir -p ~/.config/autostart/
    cp screen_autostart.desktop ~/.config/autostart/
    cp unclutter_autostart.desktop ~/.config/autostart/
  ```
    
