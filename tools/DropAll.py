import datetime
import glob
import json
import os
import re
import subprocess
import sys
import time



# Send a command to the linux terminal
def terminal(cmd):
	return os.popen(cmd).read()

# Send a command to the Bitcoin console
def bitcoin(cmd):
	return terminal('./../src/bitcoin-cli -rpcuser=cybersec -rpcpassword=kZIdeN4HjZ3fp9Lge4iezt0eJrbjSi8kuSuOHeUkEUbQVdf09JZXAAGwF3R5R2qQkPgoLloW91yTFuufo7CYxM2VPT7A5lYeTrodcLWWzMMwIrOKu7ZNiwkrKOQ95KGW8kIuL1slRVFXoFpGsXXTIA55V3iUYLckn8rj8MZHBpmdGQjLxakotkj83ZlSRx1aOJ4BFxdvDNz0WHk1i2OPgXL4nsd56Ph991eKNbXVJHtzqCXUbtDELVf4shFJXame -rpcport=8332 ' + cmd)



peers = json.loads(bitcoin('list'))

for peer in peers:
	if re.match(r'[^:]+:[^:]+', peer):
		address = peer.split(':')[0]
		port = peer.split(':')[1]
		bitcoin(f'disconnect {address} {port}')
		print(f'Disconnected {peer}')

print('Script completed.')