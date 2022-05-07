#!/bin/bash
BUFFER=0.1
#########################################################################
#########################################################################


which screen &> /dev/null
if ! [ -x "$(command -v screen)" ]; then
	echo "Program 'screen' ni nameščen. Namestite ga s 'sudo apt install screen' in ponovno poženite testno scripto."
	exit 3
fi
clear

fullPrint=$( [ $# -gt 0 ] && echo '' || echo 1 )

FOL="/tmp/os-dn2"
rm -r $FOL &> /dev/null
mkdir $FOL

function supressErr {
	exec 3>&2
	exec 2> /dev/null
}

function resumeErr {
	exec 2>&3
}
if [ "$fullPrint" ]; then
	echo -e "--------------------------------------------------------------------------\n"
	echo -e "\t2. DOMAČA NALOGA IZ OPERACIJSKIH SISTEMOV 2021/2022"
	echo -e "\tKontaktna oseba: Žiga Emeršič (ziga.emersic@fri.uni-lj.si)"
	echo -e "\n--------------------------------------------------------------------------"
fi

function res {
	# resumeErr
	p=$1
	pts=$2
	c="$3"

	if [ "$fullPrint" ]; then
		[ $p -eq $pts ] && echo -e "\e[1m$p/$pts\e[0m | $c" || echo -e "\e[41;1m$p/$pts\e[0m | $c"
	else
		cS="${c:5:3}"
		echo -n "$cS$p; "
	fi
	# supressErr
}

function printSlow {
	s="$1"
	for (( i=0; i<${#s}; i++ )); do
		sleep 0.005
		echo -en "\e[1m"
		if [ "${s:$i:1}" = "#" ]; then
			echo -en "\e[3$(( $RANDOM * 6 / 32767 + 1 ))m${s:$i:1}"
		else
			echo -en "\e[0m\e[1m${s:$i:1}"
		fi
	done
	echo -e "\e[0m"
}

echo "Presvitli cesar nam danes odobril odprtje telovadnice Gibčna veverica! Zaenkrat smo štirje: Alojzij, Mihael R, Jožef in moja malenkost.

Danes smo se prvič tehtali - Mihael R 81kg, Jožef 92 kg, Alojzij 76.

Jožef je pripeljal še nadarjeni Frančiško in Ivano, vendar pa Alojzija ni bilo že tri tedne, Mihael F se nam noče pridružit.

Ob novem mesecu so teže: Frančiška 67, Ivana 62, Mihael R 85 in malo čez, okrepil se je tudi Jožef 96k, vedno-odsotni-in-shujšani Alojzij 74.

Pred nastopom proti Ogrom kamor bosta šla Frančiška in Mihael R so teže enake, le Jožef ima zdaj že 97 kil. Končno se nam je pridružil še Mihael F - tehtali ga bomo naslednjič.

Ivana 65, Jožef 100.

Alojzij 71!

Mihael F 81" > $FOL/gibcnaveverica.txt

#########################################################################
#########################################################################
# supressErr
allP=0

if [ -x DN2a.sh ]; then

	#######################
	p=0
	pts=2
	c="Test 1: Preverba ustreznosti formata izpisa za podnalogo a."

	a=$(./DN2a.sh $$ | grep -E [0-9]+\ [0-9]+ | wc -l)

	if [ $a -eq 1 ]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################

else
	echo -e "\e[31m/// Skripte DN3a.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi

if [ -x DN2b.sh ]; then	

	#######################
	p=0
	pts=2
	c="Test 2: Preverba formata izpisa pri podnalogi b, za systemd."

	a=$(./DN2b.sh systemd)

	if [[ "$a" =~ ^[0-9] ]]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################
else
	echo -e "\e[31m/// Skripte DN3b.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi

if [ -x DN2c.sh ]; then

	#######################
	p=0
	pts=2
	c="Test 3: Preverba delovanja za c, pri vhodih systemd in ocvrtajuha."

	session_name=$(($(date +%s) - 1000000))
	screen -dmS $session_name ./DN2c.sh; sleep $BUFFER
	screen -r $session_name -p0 -X stuff "systemd\n"; sleep $BUFFER
	screen -r $session_name -p0 -X stuff "ocvrtajuha\n"; sleep $BUFFER
	screen -r $session_name -p0 -X hardcopy $FOL/t2; sleep $BUFFER
	screen -X -S $session_name kill
	a=$(cat $FOL/t2 | tr -d '[:space:]')
	b="Vnesiteimeprocesa:systemdOBSTAJAVnesiteimeprocesa:ocvrtajuha-Vnesiteimeprocesa:"

	if [[ "$a" = "$b" ]]; then
		p=$pts
	fi

	res $p $pts "$c"
	allP=$(($allP+$p))
	#######################
else
	echo -e "\e[31m/// Skripte DN2c.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi


if [ -x DN2d.sh ]; then
	

	#######################
	p=0
	pts=4
	c="Test 4: Preverba izpisa pri podnalogi d, z uporabo vsebine iz gibcnaveverica.txt in argumenta Alojzij."
	a=$(./DN2d.sh $FOL/gibcnaveverica.txt Alojzij | tr -d '[:space:]')
	b="Alojzij73"

	if [ "$a" = "$b" ]; then
		p=$pts
	fi
	
	res $p $pts "$c"
	allP=$(($allP+$p))

	#######################

else
	echo -e "\e[31m/// Skripte DN3d.sh ni možno pognati. ///\e[0m Preverite ime in bit za izvajanje. \e[31m///\e[0m"
fi

rm -r $FOL &> /dev/null
grande=$allP
max=10
max_rest=10
# resumeErr

if [ "$fullPrint" ]; then	
	echo -e "\n\tSkupno število točk na tem javnem testu: \e[0m\e[1m$grande\e[0m/$max\e[0m%.\n"

	if [ $grande -eq $max ]; then
		printSlow "##########################################################################"
		printSlow "##########################################################################"
		printSlow "######################### B R A V O (zaenkrat) ###########################"
		printSlow "##########################################################################"
		printSlow "##########################################################################"
		echo ""
	fi

	echo -e "\e[94mPo oddaji lahko dobite do $max_rest dodatnih procentnih točk na skritih testih (skupno je možno dobiti tako $max+$max_rest=20% 2. domače naloge - oz. 5 točk od 25).\nNa zagovorih boste lahko dobili še do 80%, oz. 20 točk.\e[0m\n"
else
	echo -ne "Skupaj: $grande/$max\n"
fi
