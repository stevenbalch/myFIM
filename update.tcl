#!/usr/bin/tclsh

# ----------------------------------------
# update.tcl 1.4
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
puts {  -- update.tcl / v1.4 / my File Integrity Monitor -- }
puts {}
puts {      -- This is how you use this utility -- }
puts {}
puts {      -- ./update.tcl configuration-file password -- }
puts {}
puts {      -- for example -- }
puts {}
puts {      -- ./update.tcl myFIM.conf password  -- }
puts {}
exit
                    }

if {$password == ""} {
puts {}
puts { -- It looks like you are missing the password -- }
puts {}
puts {  -- update.tcl / v1.4 / my File Integrity Monitor -- }
puts {}
puts {      -- This is how you use this utility -- }
puts {}
puts {      -- ./update.tcl configuration-file password -- }
puts {}
puts {      -- for example -- }
puts {}
puts {      -- ./update.tcl myFIM.conf password  -- }
puts {}
exit
                    }

puts ""
puts "myFIM is re-checking the system...."
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

exec md5sum $clean >> myFIM-md5-ck.db
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

exec ls -ld $clean >> myFIM-rwx-ck.db
       }
       }
       }
                     }


                  }
buildit
# ----------------------------------------

proc decryptit {} { 
global password

catch {exec rm ck.data}
catch {exec echo "Below is a list of changes myFIM has detected:" >> ck.data}
catch {exec echo "" >> ck.data}
catch {exec echo "-- Beginning of Changes --" >> $rdir/ck.data}

if [catch {exec crypt $password \<myFIM-md5.cdb \>myFIM-md5.db} err] {
                                                                     }
if [catch {exec crypt $password \<myFIM-rwx.cdb \>myFIM-rwx.db} err] {
                                                                     }

if [catch {exec diff myFIM-md5.db myFIM-md5-ck.db >> ck.data} err] {
                                                                   }
if [catch {exec diff myFIM-rwx.db myFIM-rwx-ck.db >> ck.data} err] {
                                                                   }
#set date [exec date +%d%b%Y]
catch {exec echo "-- End of Changes --" >> ck.data}

set alldata [exec cat ck.data]
set sleng [string length $alldata]
#puts $sleng
if {$sleng == 68} {
puts "-- Good news, no changes found --"
} else {
puts $alldata
       }


if [catch {exec rm myFIM-md5.db} err] {
                                      }
if [catch {exec rm myFIM-rwx.db} err] {
                                      }
if [catch {exec rm myFIM-md5-ck.db} err] {
                                         }
if [catch {exec rm myFIM-rwx-ck.db} err] {
                                         }
if [catch {exec rm ck.data} err] {
                                 }                                                       


puts ""
puts "myFIM has completed...."
puts ""

                  }
decryptit
# ----------------------------------------
