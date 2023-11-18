#£¡/bin/sh

temp_max=`cat /sys/class/power_supply/bms/temp_max`;
time_ot=`cat /sys/class/power_supply/bms/time_ot`;

#echo $temp_max $time_ot
# -eq -Compares two arguments for equality
# -ne -Compares whether two arguments are not equal
# -lt -Whether parameter 1 is less than parameter 2
# -le -Whether parameter 1 is less than or equal to parameter 2
# -gt -Whether parameter 1 is greater than parameter 2
# -ge -Whether parameter 1 is greater than or equal to parameter 2

# 1. temperature 60~62 and time <= 2H: normal streamline
#    temperature 60~62 and time > 2H: replace the battery
# 2. temperature 63~65 and time < 10H: Mandatory battery replacement + main camera
# 3. temperature 66~85 and time < 10H: Mandatory battery replacement + main camera, mandatory screen replacement
#   (temperature 60~65: CIT screen checks whether there is# a burnt-in screen, 
#    if there is a burnt-in screen, it needs to be replaced, and if there is no burn-in screen pass)
# 4. temperature >= 86: scrapped , or Time at abnormal temperature >= 10H: scrapped

if [ $temp_max -gt 128 ] && [ $temp_max -le 20 ]
then
    temp_max=`cat /sys/class/power_supply/bms/temp_max`;
    time_ot=`cat /sys/class/power_supply/bms/time_ot`;
fi

msg=""
result="fail"


if [ $temp_max -gt 60 ] && [ $temp_max -le 62 ] && [ $time_ot -le 2  ]
then
    msg="Risk goods"
    result="pass"
fi

if [ $temp_max -gt 60 ] && [ $temp_max -le 62 ] && [ $time_ot -gt 2 ]
then
    msg="Replace the battery"
fi

if [ $temp_max -ge  63 ] && [ $temp_max -le 65 ] && [ $time_ot -le 10 ]
then
    msg="Replace the battery and the main camera"
fi

if [ $temp_max -ge 66 ] && [ $temp_max -le 85 ] && [ $time_ot -le 10 ]
then
    msg="Replace the battery and the main camera display screen"
fi

if  [ $temp_max -ge 86 ]
then
    msg="Scrap"
fi

if  [ $temp_max -le 60 ] && [ $time_ot -eq 0 ]
then
    result="pass"
    msg="pass"
fi

echo result=$result temp_max=$temp_max time_ot=$time_ot msg=$msg
