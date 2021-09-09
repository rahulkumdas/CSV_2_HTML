#!/bin/ksh
dir=/home/rahul0324/Desktop/TempCSV2HTML
# source $dir/pathfinder.env 
echo "<html><body><table style='float: left;' border='1' width='100%' cellspacing='0' cellpadding='0'><tbody><tr bgcolor=lightgreen><td style='text-align: center; width: 100%;' colspan='3'><strong>Infrastructure Overview</strong></td></tr><tr><td style='text-align: center; width: 100%;' colspan='3'><span style='color: lightgrey;'><em>&lt;Please mention summary of the Sanity&gt;</em></span></td></tr>" > $dir/report.html
# mv $dir/current.report.txt $dir/last.report.txt
# cp $dir/current.txt $dir/current.report.txt
# rm $dir/trend.zip

#Start of Basic OS
# echo "<tr bgcolor=lightblue><td style='text-align: center; width: 100%;' colspan='3'>Operating System</td></tr>" >> $dir/report.html

#Top 5 Process
echo "<tr><td style='text-align: center; width: 100%;' colspan='2' bgcolor='darkblue'><span style='color: white'>Top 5 Process</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 50%; text-align: center;'>Component Name</td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'Top 5 process' $dir/current.csv > $dir/top_5_process.report
cat $dir/top_5_process.report | while read data
do
	servername=`echo $data | cut -d, -f1`
	value=`echo $data | cut -d, -f3`
	parameter=`echo $data | cut -d, -f2`
    	
	echo SERVER:$servername: PARAMETER: $parameter VALUE:$value
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
	echo "<td style='width: 50%;  background-color: $background; text-align: center; '>$value</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

# ----<><>------------
echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>Infrastructure Capacity</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Parameter</td><td style='width: 25%; text-align: center;'>Value</td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'Infradata' $dir/current.csv > $dir/Infradata.report
cat $dir/Infradata.report | while read data
do
	servername=`echo $data | cut -d, -f1`
	value=`echo $data | cut -d, -f4`
	parameter=`echo $data | cut -d, -f3`
    	
	echo SERVER:$servername: PARAMETER: $parameter VALUE:$value
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%; text-align: center; '>$parameter</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: center; '>$value</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

grep 'Networkdata' $dir/current.csv > $dir/Networkdata.report
cat $dir/Networkdata.report | while read data
do
        servername=`echo $data | cut -d, -f1`
        value=`echo $data | cut -d, -f4`
        parameter=`echo $data | cut -d, -f3`

        echo SERVER:$servername: PARAMETER: $parameter VALUE:$value
        echo "<tr>" >> $dir/report.html
        echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
        echo "<td style='width: 25%; text-align: center; '>$parameter</td>" >> $dir/report.html
        echo "<td style='width: 25%;  background-color: $background; text-align: center; '>$value</td>" >> $dir/report.html
        echo "</tr>" >> $dir/report.html

done

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
	parameter=`echo $data | cut -d, -f2`
	value=`echo $data | cut -d, -f3`
    	lastvalue=`grep "$servername,CPU Usage" $dir/last.csv | head -1 | cut -d, -f3`
	diffvalue=`expr $lastvalue - $value`
	threshold=`grep 'CPU Usage' $dir/reportThreshold.csv | cut -d, -f2`
	major=`grep 'CPU Usage' $dir/reportThreshold.csv | cut -d, -f3`
    
	if [ $value -gt $threshold ]

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
	
	echo SERVER:$servername: PARAMETER: $parameter VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: center; '>$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: center; '>$diffvalue ($stat)</td>" >> $dir/report.html
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
	parameter=`echo $data | cut -d, -f2`
	value=`echo $data | cut -d, -f3`
    lastvalue=`grep "$servername,Memory Percent" $dir/last.csv | head -1 | cut -d, -f3`
	diffvalue=`expr $lastvalue - $value`
	threshold=`grep 'Memory Percent' $dir/reportThreshold.csv | cut -d, -f2`
	major=`grep 'Memory Percent' $dir/reportThreshold.csv | cut -d, -f3`
    
	if [ $value -gt $threshold ]

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
	
	echo SERVER:$servername: PARAMETER: $parameter VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: center; '>$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: center; '>$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

#Start of Disk Usage
echo "<tr><td style='text-align: center; width: 100%;' colspan='4' bgcolor='darkblue'><span style='color: white'>Disk Usage</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 25%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Disk Name</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'Disk Usage' $dir/current.csv > $dir/disk_usage.report
cat $dir/disk_usage.report | while read data
do
	background=lightgreen
	servername=`echo $data | cut -d, -f1`
	parameter=`echo $data | cut -d, -f2`
	diskname=`echo $data | cut -d, -f3`
	value=`echo $data | cut -d, -f4`
    lastvalue=`grep "$servername,Disk Usage" $dir/last.csv | head -1 | cut -d, -f4`
	diffvalue=`expr $lastvalue - $value`
	threshold=`grep 'Didk Usage' $dir/reportThreshold.csv | cut -d, -f2`
	major=`grep 'Disk Usage' $dir/reportThreshold.csv | cut -d, -f3`
    
	if [ $value -gt $threshold ]

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

	echo SERVER:$servername: PARAMETER: $parameter DISKNAME: $diskname VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 25%; '>$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%; '>$diskname</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: center; '>$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: center; '>$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html
done
