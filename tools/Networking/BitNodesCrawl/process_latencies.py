import os
import re
import json

outputFile = open(f'Node_Latencies.csv', 'w', newline='')

line = 'Address,'
line += 'Latency'

outputFile.write(line + '\n')

# List the files with a regular expression
def listFiles(regex, directory):
	path = os.path.join(os.curdir, directory)
	return [os.path.join(path, file) for file in os.listdir(path) if os.path.isfile(os.path.join(path, file)) and bool(re.match(regex, file))]

files = listFiles(r'', 'Latencies')
for file in files:
	print(f'Processing {file}')
	latency_sum = 0
	latency_num = 0
	with open(file) as json_file:
		data = json.load(json_file)
		if 'monthly_latency' in data:
			try:
				for month in data['monthly_latency']:
					if month['v'] > 0:
						latency_sum += month['v']
						latency_num += 1
			except:
				pass
	if latency_num != 0:
		latency = latency_sum / latency_num
		line = os.path.splitext(os.path.basename(file))[0] + ','
		line += str(latency)
		outputFile.write(line + '\n')

outputFile.close()
	
