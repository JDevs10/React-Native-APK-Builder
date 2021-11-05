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
## Release APK
### What can I use it for?

#### Step 1. Generate a keystore :
You will need a Java generated signing key which is a keystore
file used to generate a React Native executable binary for Android. 
You can create one using the keytool in the terminal with the following command
````sh
keytool -genkey -v -keystore your_key_name.keystore -alias your_key_alias -keyalg RSA -keysize 2048 -validity 10000
````
Once you run the keytool utility, you’ll be prompted to type in a password. 
*Make sure you remember the password 
You can change **your_key_name** with any name you want, 
as well as **your_key_alias**. This key uses key-size 2048, 
instead of default 1024 for security reason.
#### Step 2. Adding Keystore to your project :
Firstly, you need to copy the file **your_key_name.keystore** and
paste it under the **android/app** directory in your React Native project folder.
On Terminal:
````sh
mv my-release-key.keystore /android/app
````
You need to open your **android\app\build.gradle** file and add the keystore configuration. 
Like bellow :
```` groovy
signingConfigs {
   release {
       storeFile file(RELEASE_STORE_FILE)
       storePassword RELEASE_STORE_PASSWORD
       keyAlias RELEASE_KEY_ALIAS
       keyPassword RELEASE_KEY_PASSWORD
       // Optional, specify signing versions used
       v1SigningEnabled true
       v2SigningEnabled true
   }
}
buildTypes {
        release {
            signingConfig signingConfigs.release
        }
}
````
Then open and edit the example bellow.
Add the hidden information.
````
RELEASE_STORE_FILE={path to your keystore}
RELEASE_STORE_PASSWORD=*****
RELEASE_KEY_ALIAS=*****
RELEASE_KEY_PASSWORD=*****
````
#### Step 3. Release APK Generation :
Place your terminal directory to android using:
````sh
cd android
````
For Windows,
````sh
gradlew assembleRelease
````
For Linux and Mac OSX:
````sh
./gradlew assembleRelease
````
As a result, the **APK creation process is done.** You can find the generated APK at **android/app/build/outputs/apk/app-
release.apk.** This is the actual app, which you can send to your phone or upload to the Google Play Store. 
Congratulations, you’ve just generated a React Native Release Build APK for Android.


###### version 1 (10/2021 - Paris)
###### Developped by JDevs