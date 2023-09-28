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

cpu_0123=("cpu0" "cpu1" "cpu2" "cpu3")
cpu_456=("cpu4" "cpu5" "cpu6")
cpu_7=("cpu7")
cpu_all=(${cpu_0123[*]}  ${cpu_456[*]} ${cpu_7[*]})

# 设置权限
for core in ${cpu_all[*]}
do
    max_freq_path="/sys/devices/system/cpu/${core}/cpufreq/scaling_max_freq"
    min_freq_path="/sys/devices/system/cpu/${core}//cpufreq/scaling_min_freq"

    chmod 644 $max_freq_path
    chmod 644 $min_freq_path
done

function set_cpu_frequency {
    array=$1
    for core in ${array[*]}
    do
        max_freq_path="/sys/devices/system/cpu/${core}/cpufreq/scaling_max_freq"
        min_freq_path="/sys/devices/system/cpu/${core}//cpufreq/scaling_min_freq"

        echo $2 > $max_freq_path
        echo $3 > $min_freq_path
    done
}

# 读取配置
cpu_0123_max_frequency=$(cat "$MODDIR"/cpu_0123_max_frequency)
cpu_456_max_frequency=$(cat "$MODDIR"/cpu_456_max_frequency)
cpu_7_max_frequency=$(cat "$MODDIR"/cpu_7_max_frequency)

# 设置 CPU 最大, 最小频率
set_cpu_frequency "${cpu_0123[*]}" $cpu_0123_max_frequency 300000
set_cpu_frequency "${cpu_456[*]}" $cpu_456_max_frequency 710400
set_cpu_frequency "${cpu_7[*]}" $cpu_7_max_frequency 844800

exit 0
