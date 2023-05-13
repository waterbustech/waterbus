echo "1. optimization test"
echo "2. start testing"
echo "3. check code coverage"
echo "4. validate codecov.yml"

while :
do 
	read -p "Run with: " input
	case $input in
		1)
		very_good test --optimization
		break
		;;
		2)
		very_good test --exclude-coverage '**/{core/**,gen/**,features/**/data/datasources/**,features/**/presentation/**,features/**/widgets/**,features/**/bloc/**,features/**/blocs/**,features/**/xmodels/**,features/**/screens/**,main.dart}' --no-optimization --min-coverage 90 
		break
        ;;
		3)
		rm -r coverage/
		flutter test --coverage
		lcov --remove coverage/lcov.info -o coverage/lcov.info \
			'lib/gen/**' \
			'lib/core/**' \
			'lib/features/**/data/datasources/**' \
			'lib/features/**/presentation/**' \
			'lib/features/**/widgets/**' \
			'lib/features/**/bloc/**' \
			'lib/features/**/blocs/**' \
			'lib/features/**/xmodels/**' \
			'lib/features/**/screens/**' \
			'lib/main.dart'

		cat coverage/lcov.info > coverage/lcov.base.info

		echo 'Generate html'
		genhtml coverage/lcov.base.info -o coverage/html
		open coverage/html/index.html
		break
        ;;
		4)
		cat codecov.yml | curl --data-binary @- https://codecov.io/validate
		break
		;;
        *)
		;;
	esac
done