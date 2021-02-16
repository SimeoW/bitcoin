if [ ! -d "src" ] ; then
	cd .. # If located in src or any other level of depth 1, return
fi

pruned="false"
if [ -d "/media/sf_Bitcoin/blocks/" ] && [ ! -f "/media/sf_Bitcoin/bitcoin.pid" ] ; then
	dir="/media/sf_Bitcoin"
elif [ -d "/media/sf_BitcoinAttacker/blocks/" ] && [ ! -f "/media/sf_BitcoinAttacker/bitcoin.pid" ] ; then
	dir="/media/sf_BitcoinAttacker"
elif [ -d "/media/sf_BitcoinVictim/blocks/" ] && [ ! -f "/media/sf_BitcoinVictim/bitcoin.pid" ] ; then
	dir="/media/sf_BitcoinVictim"
elif [ -d "/media/sim/BITCOIN/blocks/" ] && [ ! -f "/media/sim/BITCOIN/bitcoin.pid" ] ; then
	dir="/media/sim/BITCOIN"
else
	dir="$HOME/.bitcoin/"
	pruned="true"

	if [ ! -d "$dir" ] ; then
		mkdir "$dir"
	fi
fi

if [ -f "$dir/bitcoin.pid" ] ; then
	echo "The directory \"$dir\" has bitcoin.pid, meaning that Bitcoin is already running. In order to ensure that the blockchain does not get corrupted, the program will now terminate."
	exit 1
fi

echo "datadir = $dir"

if [ ! -f "$dir/bitcoin.conf" ] ; then
	echo "Resetting configuration file"
	echo "server=1" > "$dir/bitcoin.conf"
	echo "rpcuser=cybersec" >> "$dir/bitcoin.conf"
	echo "rpcpassword=kZIdeN4HjZ3fp9Lge4iezt0eJrbjSi8kuSuOHeUkEUbQVdf09JZXAAGwF3R5R2qQkPgoLloW91yTFuufo7CYxM2VPT7A5lYeTrodcLWWzMMwIrOKu7ZNiwkrKOQ95KGW8kIuL1slRVFXoFpGsXXTIA55V3iUYLckn8rj8MZHBpmdGQjLxakotkj83ZlSRx1aOJ4BFxdvDNz0WHk1i2OPgXL4nsd56Ph991eKNbXVJHtzqCXUbtDELVf4shFJXame" >> "$dir/bitcoin.conf"
	echo "rpcport=8332" >> "$dir/bitcoin.conf"
	#echo "rpcallowip=0.0.0.0/0" >> "$dir/bitcoin.conf"
	#echo "rpcbind = 0.0.0.0:8332" >> "$dir/bitcoin.conf"
	#echo "upnp=1" >> "$dir/bitcoin.conf"
	echo "listen=1" >> "$dir/bitcoin.conf"
fi

if [ "$1" == "gui" ] ; then
	if [ "$pruned" == "true" ] ; then
		echo "Pruned mode activated, only keeping 550 block transactions"
		echo
		src/qt/bitcoin-qt -prune=550 -datadir="$dir" -debug=researcher
	else
		echo
		src/qt/bitcoin-qt -datadir="$dir" -debug=researcher
	fi
else

	# Only open the console if not already open
	if ! wmctrl -l | grep -q "Custom Bitcoin Console" ; then
		# Find the right terminal
		if [ -x "$(command -v mate-terminal)" ] ; then
			mate-terminal -t "Custom Bitcoin Console" -- python3 bitcoin_console.py
		elif [ -x "$(command -v xfce4-terminal)" ] ; then
			xfce4-terminal -t "Custom Bitcoin Console" -- python3 bitcoin_console.py
		else
			gnome-terminal -t "Custom Bitcoin Console" -- python3 bitcoin_console.py
		fi
	fi

	if [ "$pruned" == "true" ] ; then
		echo "Pruned mode activated, only keeping 550 block transactions"
		echo
		src/bitcoind -prune=550 -datadir="$dir" -debug=researcher
	else
		echo
		src/bitcoind -datadir="$dir" -debug=researcher
		# Reindexing the chainstate:
		#src/bitcoind -datadir="/media/sf_Bitcoin" -debug=researcher -reindex-chainstate
	fi
fi
