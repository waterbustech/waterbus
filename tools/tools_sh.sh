echo "=============DART============"
echo "1. import_sorter"
echo "2. dart_code_metrics"
echo "3. generate native screen"
echo "4. flutter pub outdated"
echo "5. build_runner"

while :
do 
	read -p "Run with: " input
	case $input in
		1)
		flutter pub run import_sorter:main
		break
		;;
		2)
		flutter pub run dart_code_metrics:metrics analyze lib
		break
        ;;
		3)
		flutter pub run flutter_native_splash:create --path=../native_splash_generator.yaml
		break
        ;;
		4)
		flutter pub outdated
		break
        ;;
		5)
		# -d = --delete-conflicting-outputs
		flutter packages pub run build_runner build -d
		flutter pub run import_sorter:main
		dart fix --apply 
		break
        ;;
        *)
		;;
	esac
done