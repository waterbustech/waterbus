echo "1. Run debug"
echo "2. Run profile"
echo "3. Run release"
while :
do 
	read -p "Run with: " input
	case $input in
		1)
		flutter run --dart-define="waterbus=DEV"
		break
		;;
		2)
		flutter run --dart-define="waterbus=DEV" --profile
		break
		;;
        3)
		flutter run --dart-define="waterbus=DEV" --release
		break
		;;
		*)
		;;
	esac
done