# React Native Generate APK (Android)
## What is an .apk file?
An Android Package Kit (APK) is the package file format used by the Android OS for distribution and installation of mobile apps. It is similar to the .exe file you have on Windows OS, an .apk file is for android.
## Debug APK
### What can I use it for?
A debug .apk file will allow you to install and test your app before publishing to app stores. Mind you, this is not yet ready for publishing, and there are quite a few things you’ll need to do to before you can publish. Nevertheless, it’ll be useful for initial distribution and testing.
You’ll need to enable debugging options on your phone to run this apk.
##### How to generate one in 3 steps?
#### Step 1:
Go to the root of the project in the terminal and run the below command :
````sh
react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res
````
#### Step 2
Go to android directory :
````sh
cd android
````
#### Step 3
Now in this android folder, run this command
````sh
./gradlew assembleDebug
````
There! you’ll find the apk file in the following path:
yourProject/android/app/build/outputs/apk/debug/app-debug.apk

###### version 1 (10/2021 - Paris)
###### Developped by JDevs