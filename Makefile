setup:
	git config core.hooksPath .githooks
	flutter pub get

run:
	flutter run

web:
	flutter run -d chrome

test:
	flutter test

analyze:
	flutter analyze --no-pub

gen:
	dart run build_runner build --delete-conflicting-outputs

