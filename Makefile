project:
	if [ `pgrep -x Xcode` ]; then \
		killall -9 Xcode; \
	fi
	tuist clean builds
	tuist fetch
	tuist generate --no-open --xcframeworks
	pod install
	open projects.xcworkspace
	
