#!/system/bin/sh
### FeraDroid Engine v1.1 | By FeraVolt. 2017 ###
B=/system/engine/bin/busybox;
SCORE=/system/engine/prop/score;
MADMAX=$($B cat /system/engine/raw/FDE_config.txt | $B grep -e 'mad_max=1');
if [ -e /sys/module/lowmemorykiller/parameters/cost ]; then
 $B echo "LMK cost fine-tuning..";
 $B chown 0:0 /sys/module/lowmemorykiller/parameters/cost;
 $B chmod 666 /sys/module/lowmemorykiller/parameters/cost;
 if [ "mad_max=1" = "$MADMAX" ]; then
  $B echo "Mad LMK.";
  $B echo "64" > /sys/module/lowmemorykiller/parameters/cost;
  $B echo "4" >> $SCORE;
 else
  $B echo "32" > /sys/module/lowmemorykiller/parameters/cost;
  $B echo "1" >> $SCORE;
 fi;
fi;
if [ -e /sys/module/lowmemorykiller/parameters/fudgeswap ]; then
 $B echo "FudgeSwap support detected. Tuning..";
 $B chown 0:0 /sys/module/lowmemorykiller/parameters/fudgeswap;
 $B chmod 666 /sys/module/lowmemorykiller/parameters/fudgeswap;
 $B echo "1024" > /sys/module/lowmemorykiller/parameters/fudgeswap;
 $B echo "4" >> $SCORE;
fi;
if [ -e /sys/module/lowmemorykiller/parameters/debug_level ]; then
 $B chown 0:0 /sys/module/lowmemorykiller/parameters/debug_level;
 $B chmod 666 /sys/module/lowmemorykiller/parameters/debug_level;
 $B echo "0" > /sys/module/lowmemorykiller/parameters/debug_level;
 $B echo "1" >> $SCORE;
 $B echo "LMK debugging disabled";
fi;
if [ -e /sys/module/lowmemorykiller/parameters/lmk_fast_run ]; then
 $B chown 0:0 /sys/module/lowmemorykiller/parameters/lmk_fast_run;
 $B chmod 666 /sys/module/lowmemorykiller/parameters/lmk_fast_run;
 $B echo "1" > /sys/module/lowmemorykiller/parameters/lmk_fast_run;
 $B echo "1" >> $SCORE;
 $B echo "LMK fast run enabled";
fi;
if [ -e /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk ]; then
 $B echo "Enabling adaptive LMK..";
 $B chown 0:0 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
 $B chmod 666 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
 $B echo "1" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
 setprop lmk.autocalc true;
 $B echo "1" >> $SCORE;
else
 setprop lmk.autocalc false;
fi;
$B echo "Tuning system resposiveness..";
H=$($B pgrep -l '' | $B grep -E "launcher" | $B awk '{print $1}');
L=$($B pgrep -l '' | $B grep -E "home" | $B awk '{print $1}');
P=$($B pgrep -l '' | $B grep -E "phone" | $B awk '{print $1}');
D=$($B pgrep -l '' | $B grep -E "dialer" | $B awk '{print $1}');
T=$($B pgrep -l '' | $B grep -E "trebuchet" | $B awk '{print $1}');
sui=$($B pidof com.android.systemui);
set=$($B pidof com.android.settings);
net=$($B pidof netd);
if [ "$sui" ]; then
 $B renice -18 "$sui";
 $B echo "-17" > /proc/"$sui"/oom_adj;
 $B chown 0:0 /proc/"$sui"/oom_adj;
 $B chmod 100 /proc/"$sui"/oom_adj;
 $B echo " - system UI";
 $B echo "3" >> $SCORE;
fi;
if [ "$set" ]; then
 $B renice -17 "$set";
 $B echo "-17" > /proc/"$set"/oom_adj;
 $B chown 0:0 /proc/"$set"/oom_adj;
 $B chmod 100 /proc/"$set"/oom_adj;
 $B echo " - settings";
 $B echo "3" >> $SCORE;
fi;
if [ "$net" ]; then
 $B renice -15 "$net";
 $B echo "-14" > /proc/"$net"/oom_adj;
 $B chown 0:0 /proc/"$net"/oom_adj;
 $B chmod 100 /proc/"$net"/oom_adj;
 $B echo " - network daemon";
 $B echo "3" >> $SCORE;
fi;
if [ "$H" ]; then
 $B renice -18 "$H";
 $B echo "-17" > /proc/"$H"/oom_adj;
 $B chown 0:0 /proc/"$H"/oom_adj;
 $B chmod 100 /proc/"$H"/oom_adj;
 $B echo " - home launcher";
 $B echo "3" >> $SCORE;
fi;
if [ "$L" ]; then
 $B renice -18 "$L";
 $B echo "-17" > /proc/"$L"/oom_adj;
 $B chown 0:0 /proc/"$L"/oom_adj;
 $B chmod 100 /proc/"$L"/oom_adj;
 $B echo " - home launcher";
 $B echo "3" >> $SCORE;
fi;
if [ "$P" ]; then
 $B renice -17 "$P";
 $B echo "-17" > /proc/"$P"/oom_adj;
 $B chown 0:0 /proc/"$P"/oom_adj;
 $B chmod 100 /proc/"$P"/oom_adj;
 $B echo " - phone";
 $B echo "3" >> $SCORE;
fi;
if [ "$D" ]; then
 $B renice -17 "$D";
 $B echo "-17" > /proc/"$D"/oom_adj;
 $B chown 0:0 /proc/"$D"/oom_adj;
 $B chmod 100 /proc/"$D"/oom_adj;
 $B echo " - dialer";
 $B echo "3" >> $SCORE;
fi;
if [ "$T" ]; then
 $B renice -18 "$T";
 $B echo "-17" > /proc/"$T"/oom_adj;
 $B chown 0:0 /proc/"$T"/oom_adj;
 $B chmod 100 /proc/"$T"/oom_adj;
 $B echo " - trebuchet launcher";
 $B echo "3" >> $SCORE;
fi;
sync;
$B sleep 1;

