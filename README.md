# React Native Builder

This shell script will prepare React Native build before generating Android Studio apk (debug or release)
Also update update Android Gradle

## Get Starting

Very simple, copy the script file in react native home folder and execute the file
Update Gradle : 
```sh
$ cd /c/WorkPlace/MyReactNativeHome
$ ./build-react-native.sh update
$ ./build-react-native.sh update x.x
```
Build debug apk :
```sh
$ cd /c/WorkPlace/MyReactNativeHome
$ ./build-react-native.sh debug
```
Build release apk : 
```sh
$ cd /c/WorkPlace/MyReactNativeHome
$ ./build-react-native.sh release
```

###### version 1.2.16 (10/2021 - Paris)
###### Developped by JDevs