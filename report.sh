#!/bin/ksh
dir=/opt/bam/WD/pathfinder
# source $dir/pathfinder.env 
echo "<html><body><table style='float: left;' border='1' width='100%' cellspacing='0' cellpadding='0'><tbody><tr bgcolor=lightgreen><td style='text-align: center; width: 100%;' colspan='3'><strong>Pathfinder - Sanity Check</strong></td></tr><tr><td style='text-align: center; width: 100%;' colspan='3'><span style='color: lightgrey;'><em>&lt;Please mention summary of the Sanity&gt;</em></span></td></tr>" > $dir/report.html
mv $dir/current.report.txt $dir/last.report.txt
cp $dir/current.txt $dir/current.report.txt
# rm $dir/trend.zip

#Start of Basic OS
echo "<tr bgcolor=lightblue><td style='text-align: center; width: 100%;' colspan='3'>Operating System</td></tr>" >> $dir/report.html

#Start of CPU
echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>CPU</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html
yellowBreach=0
redBreach=0

grep 'CPU Usage' $dir/current.report.txt > $dir/cpu.report
cat $dir/cpu.report | while read data
do
	background=lightgreen
	servername=`echo $data | cut -d, -f1`
	value=`echo $data | cut -d, -f3`
	lastvalue=`grep "$servername:CPU" $dir/last.report.txt | head -1 | cut -d, -f2`
	diffvalue=`expr $lastvalue - $value`
	threshold=`grep CPU $dir/reportThreshold.cfg | cut -d, -f2`
	major=`grep CPU $dir/reportThreshold.cfg | cut -d, -f3`
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
	echo SERVER:$servername: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
	echo "<tr>" >> $dir/report.html
	echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
	echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
	echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
	echo "</tr>" >> $dir/report.html
done

#Start of MEMORY
echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>MEMORY</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html


grep MEMORY $dir/current.report.txt > $dir/memory.report
cat $dir/memory.report | while read data
do
        background=lightgreen
        servername=`echo $data | cut -d: -f1`
        value=`echo $data | cut -d, -f2`
        lastvalue=`grep "$servername:MEMORY" $dir/last.report.txt | head -1 | cut -d, -f2`
        diffvalue=`expr $lastvalue - $value`
        threshold=`grep MEMORY $dir/reportThreshold.cfg | cut -d, -f2`
	    major=`grep MEMORY $dir/reportThreshold.cfg | cut -d, -f3`
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
        echo SERVER:$servername: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
        echo "<tr>" >> $dir/report.html
        echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
        echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
        echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
        echo "</tr>" >> report.html
done


#Start of SWAP_SPACE
echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>SWAP SPACE</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html


grep SWAP_SPACE $dir/current.report.txt > $dir/swap.report
cat $dir/swap.report | while read data
do
        background=lightgreen
        servername=`echo $data | cut -d: -f1`
        value=`echo $data | cut -d, -f2`
        lastvalue=`grep "$servername:SWAP_SPACE" $dir/last.report.txt | head -1 | cut -d, -f2`
        diffvalue=`expr $lastvalue - $value`
        threshold=`grep SWAP_SPACE $dir/reportThreshold.cfg | cut -d, -f2`
	major=`grep SWAP_SPACE $dir/reportThreshold.cfg | cut -d, -f3`
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
        echo SERVER:$servername: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
        echo "<tr>" >> $dir/report.html
        echo "<td style='width: 50%; '>$servername</td>" >> $dir/report.html
        echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
        echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
        echo "</tr>" >> $dir/report.html

done


#Start of DISK_SPACE
echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>DISK SPACE</span></td></tr>" >> $dir/report.html
echo "<tr><td style='width: 50%; text-align: center;'>Server</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html


grep DISK_SPACE $dir/current.report.txt > $dir/swap.report
cat $dir/swap.report | while read data
do
        background=lightgreen
        servername=`echo $data | cut -d: -f1`
	pattern=`echo $data | cut -d, -f1`
	partition=`echo $data | cut -d: -f2 | cut -d\- -f2 | cut -d, -f1`
        value=`echo $data | cut -d, -f2`
        lastvalue=`grep "$pattern," $dir/last.report.txt | cut -d, -f2`
        diffvalue=`expr $lastvalue - $value`
        threshold=`current_logSK_SPACE $dir/reportThreshold.cfg | cut -d, -f3`
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
        echo SERVER:$pattern: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
        echo "<tr>" >> $dir/report.html
        echo "<td style='width: 50%; '>$servername-($partition)</td>" >> $dir/report.html
        echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
        echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
        echo "</tr>" >> $dir/report.html
done

#Start of BAM
#echo "<tr><td style='text-align: center; width: 100%;' colspan='3' bgcolor='darkblue'><span style='color: white'>Business - Order Status</span></td></tr>" >> $dir/report.html
#echo "<tr><td style='width: 50%; text-align: center;'>Paramater</td><td style='width: 25%; text-align: center;'>Current Value</td><td style='width: 25%; text-align: center;'>Value Change</td></tr>" >> $dir/report.html


grep "RAM:" $dir/current.report.txt > $dir/bam.report
cat $dir/bam.report | while read data
do
        background=lightgreen
        paramname=`echo $data | cut -d, -f1 | cut -d: -f2`
        pattern=`echo $data | cut -d, -f1`
        value=`echo $data | cut -d, -f2`
        lastvalue=`grep "$pattern," $dir/last.report.txt | cut -d, -f2`
        diffvalue=`expr $lastvalue - $value`
        threshold=`grep $pattern $dir/reportThreshold.cfg | cut -d, -f2`
        major=`grep $pattern $dir/reportThreshold.cfg | cut -d, -f3`
        if [ $value -gt $threshold ]
        then
                background=yellow
		#mailStatus=YELLOW
        fi
        if [ $value -gt $major ]
        then
                background=red
		#mailStatus=RED
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
        echo SERVER:$pattern: VALUE:$value: LASTVALUE:$lastvalue: DIFF:$diffvalue: THRESHOLD:$threshold:
        echo "<tr>" >> $dir/report.html
        echo "<td style='width: 50%; '>$paramname</td>" >> $dir/report.html
        echo "<td style='width: 25%;  background-color: $background; text-align: right; '>$value</td>" >> $dir/report.html
        echo "<td style='width: 25%; background-color: lightgrey; text-align: right; '>$diffvalue ($stat)</td>" >> $dir/report.html
        echo "</tr>" >> $dir/report.html

done

echo "</tbody></table></body></html>">>$dir/report.html

summary="There are $yellowBreach warning threshold and $redBreach major threshold violations"
mailStatus=GREEN
if [ $yellowBreach -gt 0 ]
then
	mailStatus=YELLOW
fi

if [ $redBreach -gt 0 ]
then
	mailStatus=RED
fi

mailDate=`date +%x"-"%H":"%M`
mailSubject=`echo "$mailStatus:PATHFINDER SANITY:$summary at $mailDate"`


pass=$RANDOM
zip --password $pass -j $dir/trend.zip $dir/trend.csv
sleep 10



#Send email with Report and trend as attachment
v_mailpart="$(uuidgen)/$(hostname)"
echo "To: $reportTo 
Subject: $mailSubject 
From: Interim Project <noreply@talktalkbusiness.co.uk>
Content-Type: multipart/mixed; boundary=\"$v_mailpart\"
MIME-Version: 1.0

This is a multi-part message in MIME format.
--$v_mailpart
Content-Type: text/html
Content-Disposition: inline

`cat $dir/report.html`

--$v_mailpart
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name=trend.zip
Content-Disposition: attachment; filename=trend.zip

`base64 $dir/trend.zip`
 --$v_mailpart--" | /usr/sbin/sendmail -t

sleep 10
#Send Password
echo "From: Interim Project <noreply@talktalkbusiness.co.uk>" > $dir/password.html
echo "To: noreply@talktalkbusiness.co.uk" >> $dir/password.html
echo "Bcc: $reportTo" >> $dir/password.html
echo "Subject: (CONFIDENTIAL)RE:$mailSubject" >> $dir/password.html
echo "Content-Type: text/html" >> $dir/password.html
echo "MIME-Version: 1.0" >> $dir/password.html
echo ""  >> password.html
echo "BCC Intentional: Password for the trend.zip file is: $pass" >> $dir/password.html
/usr/sbin/sendmail $reportTo < $dir/password.html



#echo "Please find the report attached. Please popuate the graphs and share the details to sayantan.basu@cgi.com" | mailx -s "$mailSubject" -S "$mailSmtp" -a "$dir/report.zip" -r "$mailFrom" -b "$mailTo" "$mailFrom"
#sleep 10
#echo "Password: $pass" | mailx -s "CONFIDENTIAL: Delete Email after usage" -S "$mailSmtp"  -r "$mailFrom" -b "$mailTo" "$mailFrom" 
rm $dir/cpu.report $dir/memory.report $dir/swap.report $dir/bam.report
