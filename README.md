# myFIM
Open Source File Integrity Monitor (FIM) for Linux based systems

Supported Sites
github.com

Requirements:
tclsh
crypt
md5sum

Usage:
Edit myFIM.conf for customization

Run the firstime.tcl script to collect a baseline of selected files to monitor.
./firstime.tcl myFIM.conf <password>

Run the update.tcl script to determine if pre-determined files have been modified.
./update.tcl myFIM.conf <password>
  
myFIM will report any attribute, ownership, and md5 changes to files.
