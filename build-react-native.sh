#Generate React Native apk

echo "=========================================================="
echo "=========================================================="
echo "This batch file will build and release a React Native apk."
echo "----------------------------------------------------------"

#####
# Set Gobal variables
#####

#read -p "Set react native folder : " user_input

#get pwd output && assign to variable
HOME_FOLDER=$(pwd)
echo $HOME_FOLDER


#####
# Main body of functions starts here
#####
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

init_gradlew(){
	# 2- Generate react native bundle
	echo Go to $HOME_FOLDER...
	cd $HOME_FOLDER

	echo Generate react native bundle...
	react-native bundle --platform android --dev false --entry-file index.js --bundle-output $HOME_FOLDER/android/app/src/main/assets/index.android.bundle --assets-dest $HOME_FOLDER/android/app/src/main/res 


	# 3- Execute gradlew :
	echo Stop gradlew...
	cd android
	./gradlew --stop


	echo Clean gradlew...
	./gradlew clean


	echo Clean app gradlew...
	./gradlew clean app:assembleRelease -x bundleReleaseJsAndAssets

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

android_studio_build(){
	echo need to configure android studio gradle
}
#####
# Main body of functions ends here
#####

#####
# Main body of script starts here
#####

init_folders

init_gradlew

ini_remove_drawable_raw

android_studio_build

read -p "Done!" xxx

#####
# Main body of script ends here
#####