# myFIM
Open Source File Integrity Monitor (FIM) for Linux based systems.

## Supported Sites:
github.com

## Requirements:
- tclsh `apt install tcl`
- crypt `apt install mcrypt`

## Usage:
*Edit myFIM.conf for customization and also make sure all file permissions are setup correctly.*

*Run the firstime.tcl script to collect a baseline of selected files to monitor.*

  `./firstime.tcl myFIM.conf <password>`
  
*Run the update.tcl script to determine if any files have been modified.*

  `./update.tcl myFIM.conf <password>`
  
*myFIM will report any attribute, ownership, and md5 changes to files.*
