#!/usr/bin/tclsh

# ----------------------------------------
# firstime.tcl 1.4
# my File Integrity Monitor (myFIM)
# Created by Steven W. Balch Jr.
# ----------------------------------------

# ----------------------------------------

set conffile [lindex $argv 0]
set password [lindex $argv 1]

#--------------------------------------

#--------------------------------------
if {$conffile == ""} {
puts {}
puts { -- It looks like you are missing the configuration file -- }
puts {}
puts {  -- firstime.tcl / v1.4 / my File Integrity Monitor -- }
puts {}
puts {      -- This is how you use this utility -- }
puts {}
puts {      -- ./firstime.tcl configuration-file password -- }
puts {}
puts {      -- for example -- }
puts {}
puts {      -- ./firstime.tcl myFIM.conf password  -- }
puts {}
exit
                    }

if {$password == ""} {
puts {}
puts { -- It looks like you are missing the password -- }
puts {}
puts {  -- firstime.tcl / v1.4 / my File Integrity Monitor -- }
puts {}
puts {      -- This is how you use this utility -- }
puts {}
puts {      -- ./firstime.tcl configuration-file password -- }
puts {}
puts {      -- for example -- }
puts {}
puts {      -- ./firstime.tcl myFIM.conf password  -- }
puts {}
exit
                    }

puts ""
puts "Running myFIM For The First Time...."
puts ""
#--------------------------------------

#--------------------------------------

proc getconf {} {
global conffile filelist exclist
set confinfo [open $conffile r]

set dirclr directory
set excclr exclude


while {[gets $confinfo entry] >= 0} {



if {[regexp {directory:} $entry] ==1} {
set spline_1 [split $entry {:}]
set dir [lindex $spline_1 0]

if {[string compare $dirclr $dir] == 1} {
set dirlist [lindex $spline_1 1]

} else {
set dirlist [lindex $spline_1 1]
set filelistrw [glob -type f $dirlist/*]
lappend filelist $filelistrw
       }
                                      }


if {[regexp {exclude:} $entry] ==1} {
set spline_1 [split $entry {:}]
set exc [lindex $spline_1 0]

if {[string compare $excclr $exc] == 1} {
set exclistrw [lindex $spline_1 1]

} else {
set exclistrw [lindex $spline_1 1]
lappend exclist $exclistrw
       }
                                      }


                                      }                                      
                                      
                                   
close $confinfo
                   }
getconf
# ----------------------------------------

proc buildit {} { 
global filelist exclist

set filerw [split $filelist ]

foreach item $filerw {

set clean [string trim $item ?\}\{?]

if {[regexp {/etc/initpipe} $clean] ==1} {
} else {
if {[regexp {/etc/utmppipe} $clean] ==1} {
} else {

if {[lsearch -exact $exclist $clean] != -1} {
} else {

exec md5sum $clean >> myFIM-md5.db
       }
       }
       }
                     }

foreach item $filerw {


set clean [string trim $item ?\}\{?]

if {[regexp {/etc/initpipe} $clean] ==1} {
} else {
if {[regexp {/etc/utmppipe} $clean] ==1} {
} else {

if {[lsearch -exact $exclist $clean] != -1} {
} else {

exec ls -ld $clean >> myFIM-rwx.db
       }
       }
       }
                     }


                  }
buildit
# ----------------------------------------

proc cryptit {} { 
global password

if [catch {exec crypt $password \<myFIM-md5.db \>myFIM-md5.cdb} err] {
                                                                     }
if [catch {exec crypt $password \<myFIM-rwx.db \>myFIM-rwx.cdb} err] {
                                                                     }


if [catch {exec rm myFIM-md5.db} err] {
                                     }
if [catch {exec rm myFIM-rwx.db} err] {
                                     }
                                           
if [catch {exec chmod 600 myFIM-md5.cdb} err] {
                                              }
if [catch {exec chmod 600 myFIM-rwx.cdb} err] {
                                              }                                          

puts ""
puts "myFIM has completed...."
puts ""

                  }
cryptit
# ----------------------------------------
