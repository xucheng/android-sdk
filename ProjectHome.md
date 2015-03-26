# <font color='blue'>Intro</font> #
Alternative android sdk is a collection of opensource utilities with some modifications, It can be used for these purpose:
  1. apk reverse engineering.(with apktool/smali/baksmali/dex2jar/dava)
  1. learning/developing smali language and run simple dex file under PC.(with smali/baksamli/pure java dalvikvm)
  1. develop android App but do not want to use official SDK.(javac/android.jar api16/dx/apktool/aapt/aidl)
  1. pure 64bit environment and do not like to install 32bit Android SDK with a lot of 32bit support libraries.(with android-utils, you need compile it yourself)

# <font color='blue'>Components</font> #
  1. Standalone aapt/adb/acp/aidl/zipalign extracted from original android source tree.These utilities can be compiled as 64bit native or 32bit native.
  1. Android.jar API16 and dx from original android SDK.
  1. Smali/Baksmali to decode/encode dex file
  1. Pure java dalvikvm modified from "android-dalvik-vm-on-java"
  1. dex2jar/dava to decompile dex to classes and java codes.
  1. apktool to extract and rebuild a APK file.
  1. Droiddraw GUI Builder.
  1. apk signer.
  1. A wrapper script to make everything easy.
  1. Examples include java/smali helloworld and a simple UI App that can be build with this SDK.

# <font color='blue'>Download</font> #

**Android-utils** ported from Android 4.1.2 source tree include aapt/adb/acp/aidl/zipalign. the porting scripts can be found in SVN.

https://ios-toolchain-based-on-clang-for-linux.googlecode.com/files/android-utils-4.1.2-r1.tar.gz

And a latest version from android git source tree.

https://ios-toolchain-based-on-clang-for-linux.googlecode.com/files/android-utils-4.4-r1.tar.gz


**Apkutil** include all other arch independent components

https://ios-toolchain-based-on-clang-for-linux.googlecode.com/files/apkutil-4.1.2-r3.tar.gz


# <font color='blue'>Build and Install</font> #
**For android-utils:**

```
$tar zxvf android-utils-4.1.2-r1.tar.gz
$cd android-utils
$./autogen.sh
$./configure --prefix=/usr
$make;make install
```

It will install adb/aapt/acp/aidl/zipalign to /usr/bin, if you want to install them to non-standard path, please specify the prefix when "configure" and make sure that your installation path is in PATH env.

**For apkutils:**

Just extract it to anywhere you want and link apkutil.sh to /usr/bin/apkutil


# <font color='blue'>Examples</font> #
There are some examples shipped with the sdk, Please
```
$cd apkutils/example
```
for more information.

# <font color='blue'>And More</font> #
```
Usage: apkutil <command>

command list:
  deapk       -- decompile apk file
  enapk       -- re-compile directory to apk
  if          -- install framework file to your system which needed by apktool

  baksmali    -- use baksmali to decode dex file
  smali       -- use smali to encode smalis to dex
  dalvikvm    -- use pure java dalvikvm to run simple dex file

  dex2jar     -- convert dex to jar
  jar2dex     -- convert jar to dex

  droiddraw   -- GUI builder
  installagent-- install droiddraw agent to device
  agentforward-- setup agentforward rule

  genrjava    -- generate R.java
  javac       -- javac wrapper with classpath set to android-4.1 framwork
  dava        -- java decompiler

  dx          -- dx wrapper

  sign        -- sign apk with testkey

  setdevice   -- setup device for adb
  adb         -- android adb wrapper
  adbrun      -- run command with adb
  adbshell    -- launch adb shell
  adbpush     -- adb push wrapper

  zipalign    -- zipalign wrapper
  aapt        -- aapt wrapper
  aidl        -- aidl wrapper
```