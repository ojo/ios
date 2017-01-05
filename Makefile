all:

dependencies: carthage cocoapods

carthage:
	carthage bootstrap --no-use-binaries

cocoapods: bundler
	bundle exec pod install --verbose

bundler:
	bundle install

clean:
	rm -rf Carthage
	rm -rf Pods

beta:
	bundle exec fastlane ios beta
