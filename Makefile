all:

dependencies: carthage cocoapods

carthage:
	carthage update

cocoapods: bundler
	bundle exec pod install --verbose

bundler:
	bundle install

clean:
	rm -rf Carthage
	rm -rf Pods
