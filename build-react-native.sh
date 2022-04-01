#!/bin/bash
#Generate React Native apk

##### Versions
# 07/07/2021 v1.0 - JL - version inital
# 20/09/2021 v2.0 - JL - added functions : init_keystore, make_react_native_bundle, update
# 01/04/2022 v3.0 - JL - change script steps, added functions : init_app_info, init_env ; updated functions : init_keystore
# ----------------------------------------------------------------------
# List of functions
# init_env 					: Check if all environment variables are OK
# init_folders 				: Check/Delete "signing_config" and Check/Create "assets" folder
# init_gradlew 				: Execute different gradlew task
# init_apk 					: Generate debug or apk file
# init_keystore 			: Generate keystore, update gradle.properties and build.gradle
# update 					: Update Gradlew version
# ----------------------------------------------------------------------
SH_VERSION=v3.0
# ----------------------------------------------------------------------

echo "=========================================================="
echo "=========================================================="
echo "This batch file will build and release a React Native apk."
echo "----------------------------------------------------------"

#####
# Set Gobal variables
#####

iskeystoreMade=false
KEYTOOL=$JAVA_HOME\\bin\\keytool.exe
HOME_FOLDER=$(pwd)	#get pwd output && assign to variable

#####
# End Gobal variables
#####

#region Main body of functions starts here
init_env() {

	if [ ! $JAVA_HOME ]; then
		echo "--- The JAVA_HOME variable is not set so keytool wont work."
		echo "--- check if keytool command exist"

		if [[ "$(command -v keytool)" == "" ]]; then
			echo "--- keytool command does not exist"
			exit
		else
			echo "--- keytool command exist"
			KEYTOOL="$(command -v keytool)"
		fi
	fi
}

init_app_info() {
	
	#read -p "Set react native folder : " user_input
	read -p "App Name ? => " APP_NAME
	read -p "App Version ? => " APP_VERSION
	APK_NAME=$APP_NAME-$APP_VERSION
	KEYSTORE_FILE_NAME=release-$APP_NAME-key.jks
	KEYSTORE_FILE=$HOME_FOLDER/android/app/$KEYSTORE_FILE_NAME

	echo "--- App Name : $APP_NAME"
	echo "--- App Version : $APP_VERSION"
	echo "--- React Native home folder : $HOME_FOLDER"
	echo "--- Java home folder : $JAVA_HOME"
	echo "--- Keytool home folder : $KEYTOOL"
	echo "--- Keystore path : $KEYSTORE_FILE"
	echo "--- ----------------------------------------------------------"
}

init_keystore(){

	case $1 in
		make)
			# check if keystore exist, if not make it
			if [ -f "$KEYSTORE_FILE" ]; then
				echo "--- $KEYSTORE_FILE exist!"
			else
				echo "--- $KEYSTORE_FILE does not exist!"
				echo "--- Generate keystore...."
				read -p "Set keystore alias : " KEYSTORE_ALIAS
				
				echo "--- $KEYTOOL" -genkey -v -keystore $KEYSTORE_FILE -alias $KEYSTORE_ALIAS -keyalg RSA -keysize 2048 -validity 10000
				"$KEYTOOL" -genkey -v -keystore $KEYSTORE_FILE -alias $KEYSTORE_ALIAS -keyalg RSA -keysize 2048 -validity 10000
				iskeystoreMade=true
				init_keystore link
			fi
		;;
		link)
			if [ $iskeystoreMade == true ]; then
				
				echo .......
				echo Add the information in $HOME_FOLDER/android/gradle.properties
				echo =======================================================================
				echo MYAPP_UPLOAD_STORE_FILE=$KEYSTORE_FILE
				echo MYAPP_UPLOAD_KEY_ALIAS=$KEYSTORE_ALIAS
				echo MYAPP_UPLOAD_STORE_PASSWORD=****
				echo MYAPP_UPLOAD_KEY_PASSWORD=****
				echo =======================================================================
				gnome-terminal -- bash -c "nano "$HOME_FOLDER/android/gradle.properties"; exec bash"
				read -p 'Press Enter to continue' k
				
				echo .......
				echo Add the information in $HOME_FOLDER/android/app/build.gradle
				echo In the signingConfigs obj
				echo After in buildTypes.release obj
				echo =======================================================================
				echo signingConfigs {
				echo 	release {
				echo 	if \(project.hasProperty\(\'MYAPP_UPLOAD_STORE_FILE\'\)\) {
				echo 			storeFile file\(MYAPP_UPLOAD_STORE_FILE\)
				echo 			storePassword MYAPP_UPLOAD_STORE_PASSWORD
				echo  			keyAlias MYAPP_UPLOAD_KEY_ALIAS
				echo  			keyPassword MYAPP_UPLOAD_KEY_PASSWORD
				echo  			v2SigningEnabled true
				echo 		}
				echo 	}
				echo }
				echo =======================================================================
				echo signingConfig signingConfigs.release
				echo =======================================================================
                gnome-terminal -- bash -c "nano "$HOME_FOLDER/android/app/build.gradle"; exec bash"
				read -p 'Press Enter to continue' k

			else
				echo Check the android studio variables in $HOME_FOLDER/android/gradle.properties
				echo =======================================================================
				echo MYAPP_UPLOAD_STORE_FILE=
				echo MYAPP_UPLOAD_KEY_ALIAS=
				echo MYAPP_UPLOAD_STORE_PASSWORD=
				echo MYAPP_UPLOAD_KEY_PASSWORD=
				echo =======================================================================
				gnome-terminal -- bash -c "nano "$HOME_FOLDER/android/gradle.properties"; exec bash"
				read -p 'Press Enter to continue' k

				echo Check signingConfigs object in $HOME_FOLDER/android/app/build.gradle
				echo =======================================================================
				echo signingConfigs {
				echo 	release {
				echo 	if \(project.hasProperty\(\'MYAPP_UPLOAD_STORE_FILE\'\)\) {
				echo 			storeFile file\(MYAPP_UPLOAD_STORE_FILE\)
				echo 			storePassword MYAPP_UPLOAD_STORE_PASSWORD
				echo  			keyAlias MYAPP_UPLOAD_KEY_ALIAS
				echo  			keyPassword MYAPP_UPLOAD_KEY_PASSWORD
				echo  			v2SigningEnabled true
				echo 		}
				echo 	}
				echo }
				echo =======================================================================
				echo signingConfig signingConfigs.release
				echo =======================================================================
				gnome-terminal -- bash -c "nano "$HOME_FOLDER/android/app/build.gradle"; exec bash"
				read -p 'Press Enter to continue' k
			fi			
		;;
		*)
			echo "--- init_keystore - Argument '$1' provided is not registered"			
		;;
	esac
}

init_gradlew(){
	echo Go to $HOME_FOLDER/android...
	cd $HOME_FOLDER/android
	chmod 775 ./gradlew

	case $1 in
		stop)
			echo "--- Stoping gradlew...."
			./gradlew --stop
		;;
		clean)
			echo "--- .Cleaning gradlew..."
			./gradlew clean
		;;
		clean_assembleRelease)
			echo "--- .Cleaning app assembleRelease..."
			./gradlew clean app:assembleRelease -x bundleReleaseJsAndAssets
		;;
		*)
			echo "--- init_gradlew - Argument '$1' provided is not registered"			
		;;
	esac
}

init_apk(){

	case $1 in
		debug)
			echo "--- Go to $HOME_FOLDER/android..."
			cd $HOME_FOLDER/android
			./gradlew assembleDebug
			
			if [ -f $HOME_FOLDER/android/app/build/outputs/apk/debug/app-debug.apk ]; 
				then 
					cp -p $HOME_FOLDER/android/app/build/outputs/apk/debug/app-debug.apk $HOME_FOLDER/android/app/build/outputs/apk/debug/$APK_NAME-debug.apk
					rm -f $HOME_FOLDER/android/app/build/outputs/apk/debug/app-debug.apk
					echo "--- Debug apk created at $HOME_FOLDER/android/app/build/outputs/apk/debug/$APK_NAME-debug.apk"
				else 
					echo "--- Debug apk not created!"
			fi
		;;
		release)
			echo "--- Go to $HOME_FOLDER/android..."
			cd $HOME_FOLDER/android
			./gradlew assembleRelease
			
			if [ -f $HOME_FOLDER/android/app/build/outputs/apk/release/app-release.apk ]; 
				then 
					cp -p $HOME_FOLDER/android/app/build/outputs/apk/release/app-release.apk $HOME_FOLDER/android/app/build/outputs/apk/release/$APK_NAME-release.apk
					rm -f $HOME_FOLDER/android/app/build/outputs/apk/release/app-release.apk
					echo "--- Release apk created at $HOME_FOLDER/android/app/build/outputs/apk/release/$APK_NAME-release.apk"
				else 
					echo "--- Release apk not created!"
			fi
		;;
		bundle)
			echo "--- Go to $HOME_FOLDER/android..."
			cd $HOME_FOLDER/android
			./gradlew bundleRelease
			
			if [ -f $HOME_FOLDER/android/app/build/outputs/apk/release/app-release.apk ]; 
				then 
					cp -p $HOME_FOLDER/android/app/build/outputs/apk/release/app-release.apk $HOME_FOLDER/android/app/build/outputs/apk/release/$APK_NAME-release.apk
					rm -f $HOME_FOLDER/android/app/build/outputs/apk/release/app-release.apk
					echo "--- Release apk created at $HOME_FOLDER/android/app/build/outputs/apk/release/$APK_NAME-release.apk"
				else 
					echo "--- Release apk not created!"
			fi
		;;
		*)
			echo "--- init_apk - Argument '$1' provided is not registered"			
		;;
	esac

		
		
}

update(){
	if [ ! -d "$HOME_FOLDER" ];
		then
			read -p "Set react native app home folder : " HOME_FOLDER
	fi

	echo "--- Go to $HOME_FOLDER/android..."
	cd $HOME_FOLDER/android
	
	echo "--- Current version..."
	./gradlew --version
	echo "--- Updating to $1..."
	./gradlew wrapper --gradle-version $1
	./gradlew --version
}
#endregion of functions ends here


#region Main body of script starts here

# Check if there are arguments 
if [ "$*" == "" ];
	then
		echo "--- Main - No arguments provided"
		exit
fi

init_env

case $1 in
	version)
		echo "--- Current script version $SH_VERSION"
	;;
	update)
		update $2
	;;
	debug)
		init_app_info

		echo "--- Generating Debug APK"
		init_gradlew stop
		init_gradlew clean
		init_apk debug
	;;
	release)
		init_app_info

		echo "--- Generating Release APK....."
		init_keystore make
		init_gradlew stop
		init_gradlew clean 
		init_apk release
	;;
	*)
		echo "--- Main - Argument '$1' provided is not registered"
		exit
	;;
esac
exit
#endregion Main body of script ends here
