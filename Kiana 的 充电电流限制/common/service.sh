#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode

# 等待开机32秒后开始执行
sleep 32
chmod 755 /sys/class/power_supply/*/*

# 读取配置
# 默认 3000000
charge_current=`expr $(cat "$MODDIR"/charge_current) \* 1000`

while true; do

# 读取当前充电状态
charging_status=$(cat /sys/class/power_supply/battery/status)

if [[ $charging_status == "Charging" ]]
then
    echo ${charge_current} > /sys/class/power_supply/main/constant_charge_current_max
    echo ${charge_current} > /sys/class/power_supply/main/current_max

    echo ${charge_current} > /sys/class/power_supply/dc/constant_charge_current_max
    echo ${charge_current} > /sys/class/power_supply/dc/current_max
    echo ${charge_current} > /sys/class/power_supply/battery/constant_charge_current_max

    echo ${charge_current} > /sys/class/power_supply/pc_port/current_max
    echo ${charge_current} > /sys/class/power_supply/qpnp-dc/current_max

    echo ${charge_current} > /sys/class/power_supply/usb/constant_charge_current_max
    echo ${charge_current} > /sys/class/power_supply/usb/current_max
    echo ${charge_current} > /sys/class/power_supply/usb/pd_current_max
    echo ${charge_current} > /sys/class/power_supply/usb/sdp_current_max
    echo ${charge_current} > /sys/class/power_supply/usb/hw_current_max
    echo ${charge_current} > /sys/class/power_supply/usb/ctm_current_max

    echo ${charge_current} > /sys/class/power_supply/parallel/constant_charge_current_max
fi

# 睡觉觉
sleep 2

done
exit