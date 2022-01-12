#!/bin/bash
#Generate React Native apk

##### Versions
# 7/07/2021 v1.0 - JL - version inital
# 20/09/2021 v2.0 - JL - add functions : init_keystore, make_react_native_bundle, update
# ----------------------------------------------------------------------
# List of functions
# init_folders : Check/Delete "signing_config" and Check/Create "assets" folder
# ini_remove_drawable_raw : Check/Delete "drawable-*" and "raw"
# init_gradlew : Execute different gradlew task
# init_apk : Generate debug or apk file
# init_keystore : Generate keystore, update gradle.properties and build.gradle
# make_react_native_bundle : Generate react native bundle
# update : Update Gradlew version
# ----------------------------------------------------------------------
SH_VERSION=v2.0
# ----------------------------------------------------------------------

echo "=========================================================="
echo "=========================================================="
echo "This batch file will build and release a React Native apk."
echo "----------------------------------------------------------"

#####
# Set Gobal variables
#####

KEYTOOL=$JAVA_HOME\\bin\\keytool.exe
HOME_FOLDER=$(pwd)	#get pwd output && assign to variable

#####
# End Gobal variables
#####

#region Main body of functions starts here
init_app_info(){
	#read -p "Set react native folder : " user_input
	read -p "App Name ? => " APP_NAME
	read -p "App Version ? => " APP_VERSION
	APK_NAME=$APP_NAME-$APP_VERSION
	KEYSTORE_FILE_NAME=release-$APP_NAME-key.jks
	KEYSTORE_FILE=$HOME_FOLDER/android/app/$KEYSTORE_FILE_NAME


	echo App Name : $APP_NAME
	echo App Version : $APP_VERSION
	echo React Native home folder : $HOME_FOLDER
	echo Java home folder : $JAVA_HOME
	echo Keytool home folder : $KEYTOOL
	echo Keystore path : $KEYSTORE_FILE
	echo "----------------------------------------------------------"
}

init_folders(){
	# check if log directory does not exist
	if [ ! -d $HOME_FOLDER/android/app/build/intermediates/signing_config ];
		then
			echo $HOME_FOLDER/android/app/build/intermediates/signing_config does not exist!
		else
			echo Deleting... $HOME_FOLDER/android/app/build/intermediates/signing_config!
			rm -rf $HOME_FOLDER/android/app/build/intermediates/signing_config
	fi
	
	# 1.1- Generate react native bundle
	# check if assets folder exist
	if [ -d $HOME_FOLDER/android/app/src/main/assets ];
		then
			echo $HOME_FOLDER/android/app/src/main/assets exist!
	 	else
			echo Create folder... $HOME_FOLDER/android/app/src/main/assets
			mkdir $HOME_FOLDER/android/app/src/main/assets
	fi
}

make_react_native_bundle(){
	echo Go to $HOME_FOLDER...
	cd $HOME_FOLDER

	echo Generate react native bundle...
	react-native bundle --platform android --dev false --entry-file index.js --bundle-output $HOME_FOLDER/android/app/src/main/assets/index.android.bundle --assets-dest $HOME_FOLDER/android/app/src/main/res 

}

init_keystore(){
	
	case $1 in
		make)
			# check if keystore exist, if not make it
			if [ -f "$KEYSTORE_FILE" ];
				then
					echo $KEYSTORE_FILE exist!
				else
					echo $KEYSTORE_FILE does not exist!
					echo Generate keystore....
					read -p "Set keystore alias : " KEYSTORE_ALIAS
					
					"$KEYTOOL" -genkey -v -keystore $KEYSTORE_FILE -alias $KEYSTORE_ALIAS -keyalg RSA -keysize 2048 -validity 10000
					
					init_keystore link
			fi
		;;
		link)
			echo .......
			echo Add the information in $HOME_FOLDER/android/gradle.properties
			echo =======================================================================
			echo MYAPP_UPLOAD_STORE_FILE=$KEYSTORE_FILE_NAME
			echo MYAPP_UPLOAD_KEY_ALIAS=$KEYSTORE_ALIAS
			echo MYAPP_UPLOAD_STORE_PASSWORD=
			echo MYAPP_UPLOAD_KEY_PASSWORD=
			echo =======================================================================
			start notepad "$HOME_FOLDER/android/gradle.properties"
			read -p 'Press Enter to continue' k
			
			
			echo .......
			echo Add the information in $HOME_FOLDER/android/app/build.gradle
			echo In the signingConfigs obj
			echo After in buildTypes.release obj
			echo =======================================================================
			echo release {
			echo if \(project.hasProperty\('MYAPP_UPLOAD_STORE_FILE'\)\) {
			echo 		storeFile file\(MYAPP_UPLOAD_STORE_FILE\)
			echo 		storePassword MYAPP_UPLOAD_STORE_PASSWORD
			echo  		keyAlias MYAPP_UPLOAD_KEY_ALIAS
			echo  		keyPassword MYAPP_UPLOAD_KEY_PASSWORD
			echo  		v2SigningEnabled true
			echo 	}
			echo }
			echo =======================================================================
			echo signingConfig signingConfigs.release
			echo =======================================================================
			start notepad "$HOME_FOLDER/android/app/build.gradle"
			read -p 'Press Enter to continue' k
		;;
		*)
			echo "init_keystore - Argument '$1' provided is not registered"			
		;;
	esac
}

ini_remove_drawable_raw(){
	# 4- remove \drawable-* and \raw On :
	echo remove /drawable-* and /raw folder...
	HOME_ANDROID_RES_FOLDER=$HOME_FOLDER/android/app/src/main/res

	#for /D %f in ("%HOME_FOLDER%\android\app\src\main\res\drawable-*") do rmdir "%f" /Q /S
	if [ -d $HOME_ANDROID_RES_FOLDER/drawable-mdpi ]; 
		then 
			rm -r $HOME_ANDROID_RES_FOLDER/drawable-mdpi 
			echo $HOME_ANDROID_RES_FOLDER/drawable-mdpi deleted
		else 
			echo no drawable-mdpi folder to delete 
	fi
	if [ -d $HOME_ANDROID_RES_FOLDER/drawable-hdpi ]; 
		then 
			rm -r $HOME_ANDROID_RES_FOLDER/drawable-hdpi 
			echo $HOME_ANDROID_RES_FOLDER/drawable-hdpi deleted
		else 
			echo no drawable-hdpi folder to delete 
	fi
	if [ -d $HOME_ANDROID_RES_FOLDER/drawable-xhdpi ]; 
		then 
			rm -r $HOME_ANDROID_RES_FOLDER/drawable-xhdpi 
			echo $HOME_ANDROID_RES_FOLDER/drawable-xhdpi deleted
		else 
			echo no drawable-xhdpi folder to delete 
	fi
	if [ -d $HOME_ANDROID_RES_FOLDER/drawable-xxhdpi ]; 
		then 
			rm -r $HOME_ANDROID_RES_FOLDER/drawable-xxhdpi   
			echo $HOME_ANDROID_RES_FOLDER/drawable-xxhdpi deleted
		else 
			echo no drawable-xxhdpi folder to delete 
	fi
	if [ -d $HOME_ANDROID_RES_FOLDER/drawable-xxxhdpi ]; 
		then 
			rm -r $HOME_ANDROID_RES_FOLDER/drawable-xxxhdpi   
			echo $HOME_ANDROID_RES_FOLDER/drawable-xxxhdpi deleted
		else 
			echo no drawable-xxxhdpi folder to delete 
	fi

	if [ -d $HOME_ANDROID_RES_FOLDER/raw ]; 
		then 
			rm -r $HOME_ANDROID_RES_FOLDER/raw
			echo $HOME_ANDROID_RES_FOLDER/raw deleted
		else 
			echo no raw folder to delete 
	fi
	
}

init_gradlew(){
	echo Go to $HOME_FOLDER/android...
	cd $HOME_FOLDER/android
	
	case $1 in
		stop)
			echo "Stoping gradlew...."
			./gradlew --stop
		;;
		clean)
			echo ".Cleaning gradlew..."
			./gradlew clean
		;;
		clean_assembleRelease)
			echo ".Cleaning app assembleRelease..."
			./gradlew clean app:assembleRelease -x bundleReleaseJsAndAssets
		;;
		*)
			echo "init_gradlew - Argument '$1' provided is not registered"			
		;;
	esac
}

init_apk(){

	case $1 in
		debug)
			echo Go to $HOME_FOLDER/android...
			cd $HOME_FOLDER/android
			./gradlew assembleDebug
			
			if [ -f $HOME_FOLDER/android/app/build/outputs/apk/debug/app-debug.apk ]; 
				then 
					cp -p $HOME_FOLDER/android/app/build/outputs/apk/debug/app-debug.apk $HOME_FOLDER/android/app/build/outputs/apk/debug/$APK_NAME-debug.apk
					rm -f $HOME_FOLDER/android/app/build/outputs/apk/debug/app-debug.apk
					echo Debug apk created at $HOME_FOLDER/android/app/build/outputs/apk/debug/$APK_NAME-debug.apk
				else 
					echo Debug apk not created!
			fi
		;;
		release)
			echo Go to $HOME_FOLDER/android...
			cd $HOME_FOLDER/android
			./gradlew assembleRelease
			
			if [ -f $HOME_FOLDER/android/app/build/outputs/apk/release/app-release.apk ]; 
				then 
					cp -p $HOME_FOLDER/android/app/build/outputs/apk/release/app-release.apk $HOME_FOLDER/android/app/build/outputs/apk/release/$APK_NAME-release.apk
					rm -f $HOME_FOLDER/android/app/build/outputs/apk/release/app-release.apk
					echo Release apk created at $HOME_FOLDER/android/app/build/outputs/apk/release/$APK_NAME-release.apk
				else 
					echo Release apk not created!
			fi
		;;
		*)
			echo "init_apk - Argument '$1' provided is not registered"			
		;;
	esac

		
		
}

update(){
	if [ ! -d "$HOME_FOLDER" ];
		then
			read -p "Set react native app home folder : " HOME_FOLDER
	fi

	echo Go to $HOME_FOLDER/android...
	cd $HOME_FOLDER/android
	
	echo Current version...
	./gradlew --version
	echo Updating to $1...
	./gradlew wrapper --gradle-version $1
	./gradlew --version
}
#endregion of functions ends here


#region Main body of script starts here

# Check if there are arguments 
if [ "$*" == "" ];
	then
		echo "Main - No arguments provided"
		exit
fi

case $1 in
	version)
		echo "Current script version $SH_VERSION"
	;;
	update)
		update $2
	;;
	debug)
		init_app_info

		echo "Generating Debug APK"
		init_gradlew stop
		init_gradlew clean
		init_folders
		make_react_native_bundle
		 
		init_apk debug
	;;
	release)
		init_app_info

		echo "Generating Release APK....."
		init_keystore make
		#init_keystore link
		init_folders
		init_gradlew stop
		init_gradlew clean
		init_gradlew clean_assembleRelease
		ini_remove_drawable_raw 
		init_apk release
	;;
	*)
		echo "Main - Argument '$1' provided is not registered"
		exit
	;;
esac
exit
#endregion Main body of script ends here