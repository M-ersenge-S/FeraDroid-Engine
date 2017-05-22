#!/system/bin/sh
### FeraDroid Engine v1.1 | By FeraVolt. 2017 ###
B=/system/engine/bin/busybox;
RAM=$($B free -m | $B awk '{ print $2 }' | $B sed -n 2p);
CORES=$($B grep -c 'processor' /proc/cpuinfo);
MADMAX=$($B cat /system/engine/raw/FDE_config.txt | $B grep -e 'mad_max=1');
FSCORE=/system/engine/prop/fscore;
SCORE=/system/engine/prop/score;
BG=$((RAM/100));
if [ "$CORES" = "0" ]; then
 CORES=1;
fi;
mount -o remount,rw /data;
mount -o remount,rw /system;
$B echo "Cleaning trash...";
$B chmod -R 777 /data/tombstones;
$B rm -f /data/tombstones/*;
$B chmod -R 000 /data/tombstones;
$B echo "1" > $FSCORE;
$B echo "Re-calibrating battery...";
dumpsys batteryinfo --reset;
dumpsys batterystats --reset;
$B rm - f /data/system/batterystats.bin;
$B rm - f /data/system/batterystats-checkin.bin;
$B echo "1" > $FSCORE;
if [ -e /sys/devices/platform/i2c-gpio.9/i2c-9/9-0036/power_supply/fuelgauge/fg_reset_soc ]; then
 $B echo "Fuelgauge report reset.";
 $B echo "1" > /sys/devices/platform/i2c-gpio.9/i2c-9/9-0036/power_supply/fuelgauge/fg_reset_soc;
 $B echo "1" >> $FSCORE;
fi;
if [ -e /system/etc/calib.cfg_bak ]; then
 $B echo "Display calibration is already optimized.";
elif [ -e /system/etc/calib.cfg ]; then
 $B mv /system/etc/calib.cfg /system/etc/calib.cfg_bak;
 $B mv /system/engine/raw/calib.cfg /system/etc/calib.cfg;
 $B chmod 644 /system/etc/calib.cfg;
 $B echo "Assertive display detected.";
 $B echo "Patching to powersave and optimized display calibration...";
 $B echo "1" >> $FSCORE;
elif [ -e /system/etc/ad_calib.cfg ]; then
 $B mv /system/etc/ad_calib.cfg /system/etc/calib.cfg_bak;
 $B mv /system/engine/raw/calib.cfg /system/etc/calib.cfg;
 $B chmod 644 /system/etc/calib.cfg;
 $B echo "Assertive display detected.";
 $B echo "Patching to powersave and optimized display calibration...";
 $B echo "1" >> $FSCORE;
fi;
if [ -e /data/misc/mtkgps.dat ]; then
 $B rm -f /data/misc/mtkgps.dat;
 $B echo "MTK GPS data cleared.";
 $B echo "1" >> $FSCORE;
fi;
if [ -e /data/misc/epo.dat ]; then
 $B rm -f /data/misc/epo.dat;
 $B echo "EPO data cleared.";
 $B echo "1" >> $FSCORE;
fi;
if [ ! -e /system/etc/gps_fde_bak ]; then
 if [ -e /system/etc/gps.conf ]; then
  $B cp /system/etc/gps.conf /system/etc/gps_fde_bak
 else
  $B touch /system/etc/gps.conf;
 fi;
 $B chmod 777 /system/etc/gps.conf;
 $B echo "Patching GPS config...";
 $B sed -e "s=DEBUG_LEVEL=#=" -i /system/etc/gps.conf;
 $B sed -e "s=ERR_ESTIMATE=#=" -i /system/etc/gps.conf;
 $B sed -e "s=NTP_SERVER=#=" -i /system/etc/gps.conf;
 $B sed -e "s=XTRA_=#=" -i /system/etc/gps.conf;
 $B sed -e "s=DEFAULT=#=" -i /system/etc/gps.conf;
 $B sed -e "s=INTERMEDIATE=#=" -i /system/etc/gps.conf;
 $B sed -e "s=ACCURACY=#=" -i /system/etc/gps.conf;
 $B sed -e "s=SUPL_HOST=#=" -i /system/etc/gps.conf;
 $B sed -e "s=SUPL_PORT=#=" -i /system/etc/gps.conf;
 $B sed -e "s=NMEA=#=" -i /system/etc/gps.conf;
 $B sed -e "s=CAPABILITIES=#=" -i /system/etc/gps.conf;
 $B sed -e "s=SUPL_ES=#=" -i /system/etc/gps.conf;
 $B sed -e "s=USE_EMERGENCY=#=" -i /system/etc/gps.conf;
 $B sed -e "s=SUPL_MODE=#=" -i /system/etc/gps.conf;
 $B sed -e "s=SUPL_VER=#=" -i /system/etc/gps.conf;
 $B sed -e "s=REPORT=#=" -i /system/etc/gps.conf;
 {
  $B echo "   "
  $B echo "   "
  $B echo "### FeraDroid Engine v1.1 | By FeraVolt. 2017 ###"
  $B echo "DEBUG_LEVEL=0"
  $B echo "ERR_ESTIMATE=0"
  $B echo "NTP_SERVER=time.izatcloud.net"
  $B echo "CAPABILITIES=0x37"
  $B echo "DEFAULT_AGPS_ENABLE=TRUE"
  $B echo "DEFAULT_USER_PLANE=TRUE"
  $B echo "INTERMEDIATE_POS=0"
  $B echo "NMEA_PROVIDER=0"
  $B echo "REPORT_POSITION_USE_SUPL_REFLOC=1"
  $B echo "XTRA_SERVER_1=http://xtrapath1.izatcloud.net/xtra2.bin"
  $B echo "XTRA_SERVER_2=http://xtrapath2.izatcloud.net/xtra2.bin"
  $B echo "XTRA_SERVER_3=http://xtrapath3.izatcloud.net/xtra2.bin"
  $B echo "XTRA_VERSION_CHECK=0"
  $B echo "SUPL_ES=0"
  $B echo "USE_EMERGENCY_PDN_FOR_EMERGENCY_SUPL=1"
  $B echo "SUPL_MODE=1"
  $B echo "SUPL_HOST=supl.qxwz.com"
  $B echo "SUPL_PORT=7275"
  $B echo "SUPL_VER=0x20000"
  $B echo "   "
 } >> /system/etc/gps.conf;
 $B chmod 644 /system/etc/gps.conf;
else
 $B echo "GPS config is already patched.";
 $B echo "1" >> $FSCORE;
fi; 
if [ ! -e /system/build.prop_bak ]; then
 $B cp /system/build.prop /system/engine/raw/build.prop;
 $B cp /system/build.prop /system/build.prop_bak;
 $B chmod 777 /system/engine/raw/build.prop;
 $B echo "Patching build.prop...";
 $B sed -e "s=power.saving.mode=#power.saving.mode=" -i /system/engine/raw/build.prop;
 $B sed -e "s=persist.radio.ramdump=#persist.radio.ramdump=" -i /system/engine/raw/build.prop;
 $B sed -e "s=pm.sleep_mode=#pm.sleep_mode=" -i /system/engine/raw/build.prop;
 $B sed -e "s=ro.ril.disable.power.collapse=#ro.ril.disable.power.collapse=" -i /system/engine/raw/build.prop;
 $B sed -e "s=ro.ril.fast.dormancy=#ro.ril.fast.dormancy=" -i /system/engine/raw/build.prop;
 $B sed -e "s=ro.ril.fast.dormancy.rule=#ro.ril.fast.dormancy.rule=" -i /system/engine/raw/build.prop;
 $B sed -e "s=ro.config.hw_power_saving=#ro.config.hw_power_saving=" -i /system/engine/raw/build.prop;
 $B sed -e "s=dev.pm.dyn_samplingrate=#dev.pm.dyn_samplingrate=" -i /system/engine/raw/build.prop;
 $B sed -e "s=persist.radio.add_power_save=#persist.radio.add_power_save=" -i /system/engine/raw/build.prop;
 $B sed -e "s=ro.com.google.networklocation=#ro.com.google.networklocation=" -i /system/engine/raw/build.prop;
 $B sed -e "s=ro.ril.def.agps.feature=#ro.ril.def.agps.feature=" -i /system/engine/raw/build.prop;
 $B sed -e "s=ro.ril.def.agps.mode=#ro.ril.def.agps.mode=" -i /system/engine/raw/build.prop;
 $B sed -e "s=ro.gps.agps_provider=#ro.gps.agps_provider=" -i /system/engine/raw/build.prop;
 $B sed -e "s=persist.added_boot_bgservices=#persist.added_boot_bgservices=" -i /system/engine/raw/build.prop;
 $B sed -e "s=ro.config.max_starting_bg=#ro.config.max_starting_bg=" -i /system/engine/raw/build.prop;
 $B sed -e "s=ro.sys.fw.bg_apps_limit=#ro.sys.fw.bg_apps_limit=" -i /system/engine/raw/build.prop;
 if [ -e /system/etc/calib.cfg ]; then
  $B sed -e "s=ro.qcom.ad=#ro.qcom.ad=" -i /system/engine/raw/build.prop;
  $B sed -e "s=ro.qcom.ad.calib.data=#ro.qcom.ad.calib.data=" -i /system/engine/raw/build.prop;
 fi;
 {
  $B echo "   "
  $B echo "   "
  $B echo "### FeraDroid Engine v1.1 | By FeraVolt. 2017 ###"
  $B echo "bp_patch=v1.1"
  $B echo "ro.feralab.engine=1.1"
  $B echo "power.saving.mode=1"
  $B echo "persist.radio.ramdump=0"
  $B echo "pm.sleep_mode=1"
  $B echo "ro.ril.disable.power.collapse=0"
  $B echo "ro.semc.enable.fast_dormancy=false"
  $B echo "ro.ril.fast.dormancy=0"
  $B echo "ro.ril.fast.dormancy.rule=0"
  $B echo "ro.config.hw_power_saving=1"
  $B echo "dev.pm.dyn_samplingrate=1"
  $B echo "persist.radio.add_power_save=1"
  $B echo "ro.com.google.networklocation=0"
  $B echo "ro.ril.def.agps.feature=1"
  $B echo "ro.ril.def.agps.mode=1"
  $B echo "ro.gps.agps_provider=1"
  $B echo "persist.added_boot_bgservices=$CORES"
  $B echo "ro.config.max_starting_bg=$((CORES+1))"
  $B echo "ro.sys.fw.bg_apps_limit=$BG"
  if [ -e /system/etc/calib.cfg ]; then
   $B echo "ro.qcom.ad=1"
   $B echo "ro.qcom.ad.calib.data=/system/etc/calib.cfg"
  fi;
 } >> /system/engine/raw/build.prop;
 $B cp -f /system/engine/raw/build.prop /system/build.prop;
 $B chmod 644 /system/build.prop;
else
 $B echo "Build.prop is already patched to $(getprop bp_patch)";
fi;
$B echo "19" >> $FSCORE;
FSCR=$($B awk '{ sum += $1 } END { print sum }' $FSCORE);
$B echo "$FSCR" >> $SCORE;
