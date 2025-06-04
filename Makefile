githook:
	cd .githooks
	chmod +x pre-commit
	chmod +x pre-push
	git config core.hooksPath .githooks
gen_webp:
	bash tools/convert-webp.sh
format:
	dart run import_sorter:main
	dart format lib/
check-outdated:
	flutter pub outdated
build-runner:
	dart run build_runner build -d
	dart run import_sorter:main
	dart fix --apply