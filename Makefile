project:
	if [ `pgrep -x Xcode` ]; then \
		killall -9 Xcode; \
	fi
	mise install
	tuist install
	tuist generate --no-open
	pod install
	open joosum.xcworkspace

resource:
	if [ `pgrep -x Xcode` ]; then \
		killall -9 Xcode; \
	fi
	tuist generate --no-open --xcframeworks
	pod install
	open joosum.xcworkspace

XCODE_USER_TEMPLATES_DIR=~/Library/Developer/Xcode/Templates/File\ Templates
XCODE_USER_SNIPPETS_DIR=~/Library/Developer/Xcode/UserData/CodeSnippets

JOOSUM_TEMPLATES_DIR=JoosumTemplate/Joosum

install:
	mkdir -p $(XCODE_USER_TEMPLATES_DIR)

	rm -fR $(XCODE_USER_TEMPLATES_DIR)/$(JOOSUM_TEMPLATES_DIR)
	cp -R $(JOOSUM_TEMPLATES_DIR) $(XCODE_USER_TEMPLATES_DIR)

uninstall:
	rm -fR $(XCODE_USER_TEMPLATES_DIR)/$(JOOSUM_TEMPLATES_DIR)
