ANDROID_SOURCE_FOLDER=/backup/work/code/android-git

mkdir -p android-utils

pushd android-utils
# 1. prepare folder layout
mkdir -p aapt/include
mkdir -p adb
mkdir -p libcutils/include
mkdir -p libmincrypt/include
mkdir -p zipalign
mkdir -p libhost/include
mkdir -p liblog
mkdir -p libzipfile/include
mkdir -p libutils/include
mkdir -p acp
mkdir -p aidl

# 2. copy sources from original andoid sourcetree
cp -r $ANDROID_SOURCE_FOLDER/platform_frameworks_base_from_apktool_fork/tools/aapt/* aapt
cp -r $ANDROID_SOURCE_FOLDER/core/adb/* adb
cp -r $ANDROID_SOURCE_FOLDER/core/libcutils/* libcutils
cp -r $ANDROID_SOURCE_FOLDER/core/libmincrypt/* libmincrypt
cp -r $ANDROID_SOURCE_FOLDER/core/include/cutils libcutils/include
cp -r $ANDROID_SOURCE_FOLDER/core/include/mincrypt libmincrypt/include
cp -r $ANDROID_SOURCE_FOLDER/core/include/android libcutils/include
cp -r $ANDROID_SOURCE_FOLDER/build/tools/zipalign/* zipalign
cp -r $ANDROID_SOURCE_FOLDER/build/libs/host/* libhost
cp -r $ANDROID_SOURCE_FOLDER/build/libs/host/include/host libhost/include
cp -r $ANDROID_SOURCE_FOLDER/core/liblog/* liblog
cp -r $ANDROID_SOURCE_FOLDER/core/libzipfile/* libzipfile
cp -r $ANDROID_SOURCE_FOLDER/core/include/zipfile libzipfile/include
cp -r $ANDROID_SOURCE_FOLDER/native/libs/utils/* libutils
cp -r $ANDROID_SOURCE_FOLDER/native/include/utils libutils/include
cp -r $ANDROID_SOURCE_FOLDER/core/include/corkscrew libutils/include
cp -r $ANDROID_SOURCE_FOLDER/native/include/private libutils/include
cp -r $ANDROID_SOURCE_FOLDER/core/include/system libutils/include
cp -r $ANDROID_SOURCE_FOLDER/native/include/android libutils/include
cp -r $ANDROID_SOURCE_FOLDER/platform_frameworks_base_from_apktool_fork/include/androidfw aapt/include
cp    $ANDROID_SOURCE_FOLDER/platform_frameworks_base_from_apktool_fork/libs/androidfw/Asset*.cpp aapt
cp    $ANDROID_SOURCE_FOLDER/platform_frameworks_base_from_apktool_fork/libs/androidfw/ResourceTypes.cpp aapt
cp    $ANDROID_SOURCE_FOLDER/platform_frameworks_base_from_apktool_fork/libs/androidfw/StreamingZipInflater.cpp aapt
cp -r $ANDROID_SOURCE_FOLDER/build/tools/acp/* acp
cp -r $ANDROID_SOURCE_FOLDER/platform_frameworks_base_from_apktool_fork/tools/aidl/* aidl

# 3. fix sources
(echo '0a'; echo "#define OS_PATH_SEPARATOR '/'"; echo '.'; echo 'wq') | ed -s libutils/String8.cpp
(echo '0a'; echo "#define OS_PATH_SEPARATOR '/'"; echo '.'; echo 'wq') | ed -s aapt/CrunchCache.cpp
(echo '0a'; echo "#define OS_PATH_SEPARATOR '/'"; echo '.'; echo 'wq') | ed -s aapt/Main.cpp
(echo '0a'; echo "#define OS_PATH_SEPARATOR '/'"; echo '.'; echo 'wq') | ed -s aidl/aidl.cpp
(echo '0a'; echo "#define OS_PATH_SEPARATOR '/'"; echo '.'; echo 'wq') | ed -s aidl/search_path.cpp
sed -i 's@#include <libexpat/expat.h>@#include <expat.h>@g' aapt/StringPool.h

pushd aidl
yacc -d -o aidl_language_y.cpp aidl_language_y.y
lex -oaidl_language_l.cpp aidl_language_l.l
popd

popd

# 4. add project files
if [ "`tar --help | grep -- --strip-components 2> /dev/null`" ]; then
    TARSTRIP=--strip-components
elif [ "`tar --help | grep bsdtar 2> /dev/null`" ]; then
    TARSTRIP=--strip-components
else
    TARSTRIP=--strip-path
fi
tar cf - files |tar ${TARSTRIP}=1 -xf - -C android-utils

# 5. Done
echo "Please enter android-utils dir and run ./autogen.sh;./configure"
