echo "=============WATERBUS TOOLS DART============"
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
		dart run import_sorter:main
		break
		;;
		2)
		dart run dart_code_metrics:metrics analyze lib
		break
        ;;
		3)
		dart run flutter_native_splash:create --path=splash-setup.yaml
		break
        ;;
		4)
		flutter pub outdated
		break
        ;;
		5)
		dart run build_runner build -d
		dart run import_sorter:main
		dart fix --apply  
		break
        ;;
        *)
		;;
	esac
done