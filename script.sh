#!/bin/ksh
dir=/home/rahul0324/Desktop/TempCSV2HTML

echo "<html><body><table style='float: left;' border='1' width='100%' cellspacing='0' cellpadding='0'><tbody><tr bgcolor=lightgreen><td style='text-align: center; width: 100%;' colspan='12'><strong><b>Infrastructure Overview</b></strong></td></tr><tr><td style='text-align: center; width: 100%;' colspan='12'><span style='color: lightgrey;'><em>&lt;Please mention summary of the Sanity&gt;</em></span></td></tr>" > $dir/report.html
# mv $dir/current.report.txt $dir/last.report.txt
# cp $dir/current.txt $dir/current.report.txt


#Top 5 Process
echo "<tr><td style='text-align: center; width: 100%;' colspan='12' bgcolor='darkblue'><span style='color: white'><b>Top 5 Process</b></span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;' colspan=6 ><b>Server</b></td><td style='width: 50%; text-align: center;' colspan=6 ><b>Component Name</b></td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'top5processes' $dir/current.csv > $dir/top_5_process.report
cat $dir/top_5_process.report | while read data
do
	servername=`echo $data | cut -d, -f1`
	value=`echo $data | cut -d, -f3`
	parameter=`echo $data | cut -d, -f2`
    	
	echo SERVER:$servername: PARAMETER: $parameter VALUE:$value
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; text-align: center; ' colspan=6 >$servername</td>" >> $dir/report.html
	echo "<td style='width: 50%;  background-color: $background; text-align: center; ' colspan=6 >$value</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

# ----<><>------------
echo "<tr><td style='text-align: center; width: 100%;' colspan='12' bgcolor='darkblue'><span style='color: white'><b>Infrastructure Capacity</b></span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;' colspan=6 ><b>Server</b></td><td colspan=3 style='width: 25%; text-align: center;'><b>Parameter</b></td><td colspan=3 style='width: 25%; text-align: center;'><b>Value</b></td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'infradata' $dir/current.csv > $dir/Infradata.report
cat $dir/Infradata.report | while read data
do
	servername=`echo $data | cut -d, -f1`
	value=`echo $data | cut -d, -f4`
	parameter=`echo $data | cut -d, -f3`
    	
	echo SERVER:$servername: PARAMETER: $parameter VALUE:$value
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; text-align: center; ' colspan=6 >$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%; text-align: center; ' colspan=3>$parameter</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: center; 'colspan=3 >$value</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

grep 'networkdata' $dir/current.csv > $dir/Networkdata.report
cat $dir/Networkdata.report | while read data
do
        servername=`echo $data | cut -d, -f1`
        value=`echo $data | cut -d, -f4`
        parameter=`echo $data | cut -d, -f3`

        echo SERVER:$servername: PARAMETER: $parameter VALUE:$value
        echo "<tr>" >> $dir/report.html
        echo "<td style='width: 50%; text-align: center; ' colspan=6 >$servername</td>" >> $dir/report.html
        echo "<td style='width: 25%; text-align: center; ' colspan=3 >$parameter</td>" >> $dir/report.html
        echo "<td style='width: 25%;  background-color: $background; text-align: center; ' colspan=3 >$value</td>" >> $dir/report.html
        echo "</tr>" >> $dir/report.html

done

#Start of CPU Usage
echo "<tr><td style='text-align: center; width: 100%;' colspan='12' bgcolor='darkblue'><span style='color: white'><b>CPU Usage</b></span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;' colspan=6 ><b>Server</b></td><td style='width: 25%; text-align: center;' colspan=3 ><b>Current Value</b></td><td colspan=3 style='width: 25%; text-align: center;'><b>Value Change</b></td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'cpuusage' $dir/current.csv > $dir/cpu_usage.report
cat $dir/cpu_usage.report | while read data
do
	background=lightgreen
	servername=`echo $data | cut -d, -f1`
	parameter=`echo $data | cut -d, -f2`
	value=`echo $data | cut -d, -f3`
    lastvalue=`grep "$servername,cpuusage" $dir/last.csv | head -1 | cut -d, -f3`
	diffvalue=$(bc <<< "$lastvalue - $value")
	# diffvalue=`expr $lastvalue - $value`
	threshold=`grep 'cpuusage' $dir/reportThreshold.csv | cut -d, -f2`
	major=`grep 'cpuusage' $dir/reportThreshold.csv | cut -d, -f3`
    
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
	echo "<td style='width: 50%; text-align: center; ' colspan=6 >$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: center; ' colspan=3 >$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: center; ' colspan=3 >$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

#Start of Memory Percent
echo "<tr><td style='text-align: center; width: 100%;' colspan='12' bgcolor='darkblue'><span style='color: white'><b>Memory Percent</b></span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;' colspan=6 ><b>Server</b></td><td colspan=3 style='width: 25%; text-align: center;'><b>Current Value</b></td><td colspan=3 style='width: 25%; text-align: center;'><b>Value Change</b></td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'memorypercent' $dir/current.csv > $dir/memory_percent.report
cat $dir/memory_percent.report | while read data
do
	background=lightgreen
	servername=`echo $data | cut -d, -f1`
	parameter=`echo $data | cut -d, -f2`
	value=`echo $data | cut -d, -f3`
    lastvalue=`grep "$servername,memorypercent" $dir/last.csv | head -1 | cut -d, -f3`
	diffvalue=`expr $lastvalue - $value`
	# diffvalue=$(bc <<< "$lastvalue - $value")
	threshold=`grep 'memorypercent' $dir/reportThreshold.csv | cut -d, -f2`
	major=`grep 'memorypercent' $dir/reportThreshold.csv | cut -d, -f3`
    
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
	echo "<td style='width: 50%; text-align: center; ' colspan=6 >$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: center; ' colspan=3 >$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: center; ' colspan=3 >$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

#Start of Swap Memory Percent
echo "<tr><td style='text-align: center; width: 100%;' colspan='12' bgcolor='darkblue'><span style='color: white'><b>Swap Memory Percent</b></span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;' colspan=6 ><b>Server</b></td><td colspan=3 style='width: 25%; text-align: center;'><b>Current Value</b></td><td colspan=3 style='width: 25%; text-align: center;'><b>Value Change</b></td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'swapmemorypercent' $dir/current.csv > $dir/swap_memory_percent.report
cat $dir/swap_memory_percent.report | while read data
do
	background=lightgreen
	servername=`echo $data | cut -d, -f1`
	parameter=`echo $data | cut -d, -f2`
	value=`echo $data | cut -d, -f3`
    lastvalue=`grep "$servername,swapmemorypercent" $dir/last.csv | head -1 | cut -d, -f3`
	diffvalue=`expr $lastvalue - $value`
	# diffvalue=$(bc <<< "$lastvalue - $value")
	threshold=`grep 'swapmemorypercent' $dir/reportThreshold.csv | cut -d, -f2`
	major=`grep 'swapmemorypercent' $dir/reportThreshold.csv | cut -d, -f3`
    
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
	echo "<td style='width: 50%; text-align: center; ' colspan=6 >$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: center; ' colspan=3 >$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: center; ' colspan=3 >$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html

done

#Start of Disk Usage
echo "<tr><td style='text-align: center; width: 100%;' colspan='12' bgcolor='darkblue'><span style='color: white'><b>Disk Usage</b></span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 25%; text-align: center;' colspan=3><b>Server</b></td><td colspan=3 style='width: 25%; text-align: center;'><b>Disk Name</b></td><td colspan=3 style='width: 25%; text-align: center;'><b>Current Value</b></td><td colspan=3 style='width: 25%; text-align: center;'><b>Value Change</b></td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'diskusage' $dir/current.csv > $dir/disk_usage.report
cat $dir/disk_usage.report | while read data
do
	background=lightgreen
	servername=`echo $data | cut -d, -f1`
	parameter=`echo $data | cut -d, -f2`
	diskname=`echo $data | cut -d, -f3`
	value=`echo $data | cut -d, -f4`
    lastvalue=`grep "$servername,diskusage" $dir/last.csv | head -1 | cut -d, -f4`
	diffvalue=`expr $lastvalue - $value`
	threshold=`grep 'diskusage' $dir/reportThreshold.csv | cut -d, -f2`
	major=`grep 'diskusage' $dir/reportThreshold.csv | cut -d, -f3`
    
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
	echo "<td style='width: 25%; text-align: center; ' colspan=3>$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%; text-align: center; ' colspan=3 >$diskname</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: center; ' colspan=3 >$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: center; ' colspan=3 >$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html
done
