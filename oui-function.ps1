# documented at https://isc.sans.edu/forums/diary/Mining+Live+Networks+for+OUI+Data+Oddness/25404/
# assumes that the oui.txt file exists, and that its in c:\utils - edit this to fit your implementation
# declare this variable globally so that the OUILookup function doesn't have read the file each time it is called
$global:ouilist = import-csv -Delimiter "`t" -path "c:\utils\oui.txt"

function OUILookup {
    # limited to traditional 6 digit OUIs for now
    # take the input, replace all mac delimeters
    $MAC = $args[0] -replace "[-:\.]",""
    # grab the first 6 chars for an OUI first pass
    $OUI = $MAC.Substring(0,6).ToUpper()

    #find the OUI in the table
    foreach ($entry in $ouilist){
        if ($oui -eq $entry.OUI){
           return $entry
           }
        }
}
