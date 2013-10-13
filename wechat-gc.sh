#!/bin/bash
if test $# -ne 1
then
    echo "Usage: wechat-gongcun wechat.apk"
    exit
fi

folder=`basename -s .apk $1`

rm -rf $folder

#extract apk
apkutil deapk $1

####
#enter folder
####
pushd $folder

#fix png files,this is a problem of original wechat apk package.
for img in `file res/drawable-hdpi/*.png|grep JPEG|awk -F ":" '{print $1}'`
do
    nimg=res/drawable-hdpi/`basename -s .png $img`.jpg
    mv $img $nimg
done 
#png fix end

#replace AndroidManifest.xml
sed -i 's/tencent/tencen4/g' AndroidManifest.xml
sed -i 's/tencent/tencen4/g' apktool.yml 

#rename smali package path
for i in `find . -name *.smali`
do
    sed -i 's/com\.tencent/com\.tencen4/g' $i
    sed -i 's@com/tencent@com/tencen4@g' $i
done
#change the applications file folder in sdcard.
sed -i 's/tencent/tencen4/g' smali/com/tencent/mm/storage/k.smali
sed -i 's/tencent/tencen4/g' smali/com/tencent/mm/network/bi.smali 
sed -i 's/tencent/tencen4/g' smali/com/tencent/mm/compatible/f/h.smali
#mv folder name
mv smali/com/tencent smali/com/tencen4

#rename xml package path
for t in `find . -name "*.xml"`
do
    sed -i 's/com\.tencent/com\.tencen4/g' $t
    sed -i 's@com/tencent@com/tencen4@g' $t
done


#change the package path of jni interface in native libraries.
pushd lib/armeabi
#libImgTools can not be changed via objcopy
#Here we just change it directly and it works.
#sed -i 's/Java_com_tencent/Java_com_tencen4/g' libImgTools.so

#for lib in `grep Java_com_tencent *.so|awk '{print $3}'`
#do
#    for func in `nm --dynamic $lib |grep Java_com_tencent|awk '{print $3}'`
#    do
#        oldname=$func
#        newname=$(echo $oldname|sed 's/com_tencent_/com_tencen4_/g')
#        apk-elf-rename-func $lib $oldname $newname
#    done
#done

for i in `ls *.so`
do
    sed -i 's/tencent/tencen4/g' $i
    elfhash -r $i
done

popd #lib/armeabi

#process plugins
pushd assets/preload
#merge voip split packages to one jar
cat com.tencent.mm.plugin.voip.* > com.tencent.mm.plugin.voip.jar
rm -rf com.tencent.mm.plugin.voip.*.jar.*
#rename jars to ignore md5 in filename. it's annoying....
mv com.tencent.mm.plugin.qqmail*.jar com.tencent.mm.plugin.qqmail.jar
mv com.tencent.mm.plugin.qqsync*.jar  com.tencent.mm.plugin.qqsync.jar
mv com.tencent.mm.plugin.radar*.jar com.tencent.mm.plugin.radar.jar
mv com.tencent.mm.plugin.shake*.jar com.tencent.mm.plugin.shake.jar
mv com.tencent.mm.plugin.shoot*.jar com.tencent.mm.plugin.shoot.jar
mv com.tencent.mm.plugin.traceroute*.jar com.tencent.mm.plugin.traceroute.jar

for jar in `ls *.jar`
do
    mkdir tmp
    pushd tmp
    jar xf ../$jar
    rm -rf ../$jar

    rm -rf META-INF
    #baksmali dex and change package path
    apkutil baksmali classes.dex

    for i in `find . -name *.smali`
    do
        sed -i 's/com\.tencent/com\.tencen4/g' $i
        sed -i 's@com/tencent@com/tencen4@g' $i
    done
    mv out/com/tencent out/com/tencen4
    apkutil smali out
    rm -rf classes.dex
    mv out.dex classes.dex
    rm -rf out
    #change natives.
    if [ -d lib ]; then
        pushd lib/armeabi
            #for libso in `grep Java_com_tencent *.so|awk '{print $3}'`
            #do
            #    for func in `nm --dynamic $libso |grep Java_com_tencent|awk '{print $3}'`
            #    do
            #        oldname=$func
            #        newname=$(echo $oldname|sed 's/com_tencent_/com_tencen4_/g')
            #        apk-elf-rename-func $libso $oldname $newname
            #    done
            #done
            for i in `ls *.so`
            do
                sed -i 's/tencent/tencen4/g' $i
                elfhash -r $i
            done
        popd 
    fi

    jar cf ../$jar *

    popd
   
    apkutil sign $jar $jar-signed
    rm -rf $jar
    mv $jar-signed $jar
    jarmd5=`md5sum $jar|awk '{print $1}'`
    mv $jar `basename -s .jar $jar|sed 's/tencent/tencen4/g'`.$jarmd5.jar
    rm -rf tmp
done

split -b 1m `ls com.tencen4.mm.plugin.voip*.jar`
mv xaa `ls com.tencen4.mm.plugin.voip.*.jar`.0
mv xab `ls com.tencen4.mm.plugin.voip.*.jar`.1
mv xac `ls com.tencen4.mm.plugin.voip.*.jar`.2
rm -rf com.tencen4.mm.plugin.voip*.jar



popd



popd #folder


apkutil enapk $folder $folder-gongcun.apk

apkutil sign $folder-gongcun.apk $folder-gongcun-signed.apk
rm -rf $folder-gongcun.apk
mv $folder-gongcun-signed.apk $folder-gc-tencen4.apk

