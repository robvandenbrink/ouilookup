
function updateouis
{
	curl --insecure "https://www.wireshark.org/download/automated/data/manuf" | tr -d : > $HOME/Downloads/oui.txt
}
# first make sure that the data file is there
if ! [ -f $HOME/Downloads/oui.txt ] 
then
    updateouis
fi

# syntax check
case $1 in
	-h | -H | --h | --H | --help | -? | --? )
		echo "
OUI Utility
Syntax:
     OUI NN:NN:NN      Request information on a specific OUI
                       Input is NOT case sensitive
                       Acceptable delimiters include :, . or -
                       Address delimeters can be in any position 
                       (at the 2 or 4 byte boundaries for instance)
                       Address delimeters are optional, and can be 
                       partially specified
                       So any of 005000, 00:50:00, 0050.00, 00-50-00 and
		       even just 50 are acceptable inputs
    OUI Manufacturer   List all OUI's associated with a manufacturer
                       Partial company names are acceptable
                       Input is NOT case sensitive
    OUI update         Update the OUI listing
                       This update comes from Wireshark's consolidated
                         vendor list
                       This list is compiled from a number of sources, and
                         is considered a superset of the IEEE list
                       This is downloaded from:
                             https://code.wireshark.org/review/gitweb?
                              p=wireshark.git;a=blob_plain;f=manuf;hb=HEAD
                       The IEEE listing can be obtained from: 
                             http://standards-oui.ieee.org/oui/oui.csv
                             http://standards-oui.ieee.org/cid/cid.csv
                             http://standards-oui.ieee.org/iab/iab.csv
                             http://standards-oui.ieee.org/oui28/mam.csv
                             http://standards-oui.ieee.org/oui36/oui36.csv
"
		;;
	update | --update | -update | -u | --u)
		updateouis
		;;
	
	*) 
	echo $1 | tr -d ":\-.\r\n\ " | tr '[:lower:]' '[:upper:]' > /tmp/ouioui.tmp
	cat $HOME/Downloads/oui.txt | grep -f /tmp/ouioui.tmp
	cat $HOME/Downloads/oui.txt | grep -i $1
	rm /tmp/ouioui.tmp
	;;
esac


