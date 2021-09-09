#!/bin/ksh
dir=/home/rahul0324/Desktop/TempCSV2HTML
# source $dir/pathfinder.env 
echo "<html><body><table style='float: left;' border='1' width='100%' cellspacing='0' cellpadding='0'><tbody><tr bgcolor=lightgreen><td style='text-align: center; width: 100%;' colspan='3'><strong>Infrastructure Overview</strong></td></tr><tr><td style='text-align: center; width: 100%;' colspan='3'><span style='color: lightgrey;'><em>&lt;Please mention summary of the Sanity&gt;</em></span></td></tr>" > $dir/report.html
# mv $dir/current.report.txt $dir/last.report.txt
# cp $dir/current.txt $dir/current.report.txt
# rm $dir/trend.zip

#Start of Basic OS
# echo "<tr bgcolor=lightblue><td style='text-align: center; width: 100%;' colspan='3'>Operating System</td></tr>" >> $dir/report.html

#Start of CPU Usage
echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>CPU Usage</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'CPU Usage' $dir/current.csv > $dir/cpu_usage.report
cat $dir/cpu_usage.report | while read data
do
	background=lightgreen
	servername=`echo $data | cut -d, -f1`
	value=`echo $data | cut -d, -f3`
    lastvalue=`grep "$servername,CPU Usage" $dir/last.csv | head -1 | cut -d, -f3`
	diffvalue=`expr $lastvalue - $value`
	threshold=`grep 'CPU Usage' $dir/reportThreshold.csv | cut -d, -f2`
	major=`grep 'CPU Usage' $dir/reportThreshold.csv | cut -d, -f3`
    # echo $servername, $value, $lastvalue, $diffvalue, $threshold, $major
    if [ "$(($value - $threshold))" ]

	then
		background=yellow
		yellowBreach=`expr $yellowBreach + 1`
	fi
	if [ $value -gt $major ]
	then
		background=red
		redBreach=`expr $redBreach + 1`	
	fi
	if [ $diffvalue -gt 0 ]
	then
		stat="UP"
	elif [ $diffvalue -lt 0 ]
	then
		stat="DN"
	else
		stat="--"
	fi
	echo SERVER:$servername: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

#Start of CPU Count
echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>CPU Count</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'CPU Count' $dir/current.csv > $dir/cpu_count.report
cat $dir/cpu_count.report | while read data
do
	background=lightgreen
	servername=`echo $data | cut -d, -f1`
	value=`echo $data | cut -d, -f3`
    lastvalue=`grep "$servername,CPU Count" $dir/last.csv | head -1 | cut -d, -f3`
	diffvalue=`expr $lastvalue - $value`
	threshold=`grep 'CPU Count' $dir/reportThreshold.csv | cut -d, -f2`
	major=`grep 'CPU Count' $dir/reportThreshold.csv | cut -d, -f3`
    echo $servername, $value, $lastvalue, $diffvalue, $threshold, $major
    if [ "$(($value - $threshold))" ]

	then
		background=yellow
		yellowBreach=`expr $yellowBreach + 1`
	fi
	if [ $value -gt $major ]
	then
		background=red
		redBreach=`expr $redBreach + 1`	
	fi
	if [ $diffvalue -gt 0 ]
	then
		stat="UP"
	elif [ $diffvalue -lt 0 ]
	then
		stat="DN"
	else
		stat="--"
	fi
	echo SERVER:$servername: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

#Start of Memory Percent
echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>Memory Percent</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'Memory Percent' $dir/current.csv > $dir/memory_percent.report
cat $dir/memory_percent.report | while read data
do
	background=lightgreen
	servername=`echo $data | cut -d, -f1`
	value=`echo $data | cut -d, -f3`
    lastvalue=`grep "$servername,Memory Percent" $dir/last.csv | head -1 | cut -d, -f3`
	diffvalue=`expr $lastvalue - $value`
	threshold=`grep 'Memory Percent' $dir/reportThreshold.csv | cut -d, -f2`
	major=`grep 'Memory Percent' $dir/reportThreshold.csv | cut -d, -f3`
    # echo $servername, $value, $lastvalue, $diffvalue, $threshold, $major
    if [ "$(($value - $threshold))" ]

	then
		background=yellow
		yellowBreach=`expr $yellowBreach + 1`
	fi
	if [ $value -gt $major ]
	then
		background=red
		redBreach=`expr $redBreach + 1`	
	fi
	if [ $diffvalue -gt 0 ]
	then
		stat="UP"
	elif [ $diffvalue -lt 0 ]
	then
		stat="DN"
	else
		stat="--"
	fi
	echo SERVER:$servername: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

#Start of Disk Usage
echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>Disk Usage</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'Disk Usage' $dir/current.csv > $dir/disk_usage.report
cat $dir/disk_usage.report | while read data
do
	background=lightgreen
	servername=`echo $data | cut -d, -f1`
	value=`echo $data | cut -d, -f4`
    lastvalue=`grep "$servername,Disk Usage" $dir/last.csv | head -1 | cut -d, -f4`
	diffvalue=`expr $lastvalue - $value`
	threshold=`grep 'Disk Usage' $dir/reportThreshold.csv | cut -d, -f3`
	major=`grep 'Disk Usage' $dir/reportThreshold.csv | cut -d, -f4`
    # echo $servername, $value, $lastvalue, $diffvalue, $threshold, $major
    if [ "$(($value - $threshold))" ]

	then
		background=yellow
		yellowBreach=`expr $yellowBreach + 1`
	fi
	if [ $value -gt $major ]
	then
		background=red
		redBreach=`expr $redBreach + 1`	
	fi
	if [ $diffvalue -gt 0 ]
	then
		stat="UP"
	elif [ $diffvalue -lt 0 ]
	then
		stat="DN"
	else
		stat="--"
	fi
	echo SERVER:$servername: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

# #Start of Disk name
# echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>Disk Name</span></td></tr>" >> $dir/report.html
# echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html
# yellowBreach=0
# redBreach=0

# grep 'Disk name' $dir/current.csv > $dir/disk_name.report
# cat $dir/disk_name.report | while read data
# do
# 	background=lightgreen
# 	servername=`echo $data | cut -d, -f1`
# 	value=`echo $data | cut -d, -f4`
#     lastvalue=`grep "$servername,Disk name" $dir/last.csv | head -1 | cut -d, -f4`
# 	diffvalue=`expr $lastvalue - $value`
# 	threshold=`grep 'Disk name' $dir/reportThreshold.csv | cut -d, -f3`
# 	major=`grep 'Disk name' $dir/reportThreshold.csv | cut -d, -f4`
#     # echo $servername, $value, $lastvalue, $diffvalue, $threshold, $major
#     if [ "$(($value - $threshold))" ]

# 	then
# 		background=yellow
# 		yellowBreach=`expr $yellowBreach + 1`
# 	fi
# 	if [ $value -gt $major ]
# 	then
# 		background=red
# 		redBreach=`expr $redBreach + 1`	
# 	fi
# 	if [ $diffvalue -gt 0 ]
# 	then
# 		stat="UP"
# 	elif [ $diffvalue -lt 0 ]
# 	then
# 		stat="DN"
# 	else
# 		stat="--"
# 	fi
# 	echo SERVER:$servername: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
# 	echo "<tr>" >> $dir/report.html
# 	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
# 	echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
# 	echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
# 	echo "</tr>" >> $dir/report.html

# done

# #Start of Traffic in
# echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>Traffic In</span></td></tr>" >> $dir/report.html
# echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html
# yellowBreach=0
# redBreach=0

# grep 'Traffic in' $dir/current.csv > $dir/traffic_in.report
# cat $dir/traffic_in.report | while read data
# do
# 	background=lightgreen
# 	servername=`echo $data | cut -d, -f1`
# 	value=`echo $data | cut -d, -f3`
#     lastvalue=`grep "$servername,Traffic in" $dir/last.csv | head -1 | cut -d, -f3`
# 	diffvalue=`expr $lastvalue - $value`
# 	threshold=`grep 'Traffic in' $dir/reportThreshold.csv | cut -d, -f2`
# 	major=`grep 'Traffic in' $dir/reportThreshold.csv | cut -d, -f3`
#     # echo $servername, $value, $lastvalue, $diffvalue, $threshold, $major
#     if [ "$(($value - $threshold))" ]

# 	then
# 		background=yellow
# 		yellowBreach=`expr $yellowBreach + 1`
# 	fi
# 	if [ $value -gt $major ]
# 	then
# 		background=red
# 		redBreach=`expr $redBreach + 1`	
# 	fi
# 	if [ $diffvalue -gt 0 ]
# 	then
# 		stat="UP"
# 	elif [ $diffvalue -lt 0 ]
# 	then
# 		stat="DN"
# 	else
# 		stat="--"
# 	fi
# 	echo SERVER:$servername: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
# 	echo "<tr>" >> $dir/report.html
# 	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
# 	echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
# 	echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
# 	echo "</tr>" >> $dir/report.html

# done

# #Start of Traffic out
# echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>Traffic Out</span></td></tr>" >> $dir/report.html
# echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html
# yellowBreach=0
# redBreach=0

# grep 'Traffic out' $dir/current.csv > $dir/traffic_out.report
# cat $dir/traffic_out.report | while read data
# do
# 	background=lightgreen
# 	servername=`echo $data | cut -d, -f1`
# 	value=`echo $data | cut -d, -f3`
#     lastvalue=`grep "$servername,Traffic out" $dir/last.csv | head -1 | cut -d, -f3`
# 	diffvalue=`expr $lastvalue - $value`
# 	threshold=`grep 'Traffic out' $dir/reportThreshold.csv | cut -d, -f2`
# 	major=`grep 'Traffic out' $dir/reportThreshold.csv | cut -d, -f3`
#     # echo $servername, $value, $lastvalue, $diffvalue, $threshold, $major
#     if [ "$(($value - $threshold))" ]

# 	then
# 		background=yellow
# 		yellowBreach=`expr $yellowBreach + 1`
# 	fi
# 	if [ $value -gt $major ]
# 	then
# 		background=red
# 		redBreach=`expr $redBreach + 1`	
# 	fi
# 	if [ $diffvalue -gt 0 ]
# 	then
# 		stat="UP"
# 	elif [ $diffvalue -lt 0 ]
# 	then
# 		stat="DN"
# 	else
# 		stat="--"
# 	fi
# 	echo SERVER:$servername: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
# 	echo "<tr>" >> $dir/report.html
# 	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
# 	echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
# 	echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
# 	echo "</tr>" >> $dir/report.html

# done
