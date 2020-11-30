# vbox_install
Shell scripts to setup an OCR4all docker container inside of a VirtualBox.

# Build guide
* Start a fresh VirtualBox 
* Mount a `Ubuntu 20.04.1 LTS` ISO, complete the setup process (default user should be called `ocr4all`!)
* After the installation is finished and you're logged in, clone this repistory
* Inside the repository run the following scripts in this order
  * `sudo sh setup.sh`
  * `sudo sh config.sh`
  * `sh run.sh`
* Afterwards reboot one last time
