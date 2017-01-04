# OJO for iOS

How to build the project:

1. run `pod install`
1. run `carthage update --no-use-binaries`
1. open `ojo.xcworkspace`
1. Build!

Optionally, if you don't yet have Cocoapods installed and you're familiar with Ruby, you can use Bundler to install it. Instead of running `pod install`, you run `bundle install` and then `bundle exec pod install`. For this workflow, you can use the Makefile. Just run `make dependencies` and open the workspace.
