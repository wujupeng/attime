APP_NAME=AtTime
SRC=src/main.m src/AppDelegate.m
CFLAGS=-fobjc-arc
FRAMEWORKS=-framework Cocoa -framework QuartzCore
PLIST=Info.plist
BUNDLE_DIR=$(APP_NAME).app
CONTENTS=$(BUNDLE_DIR)/Contents
MACOS=$(CONTENTS)/MacOS
RESOURCES=$(CONTENTS)/Resources
BUILD=build
DMGROOT=$(BUILD)/dmgroot
DMG=$(APP_NAME).dmg

all: $(APP_NAME)
$(APP_NAME): $(SRC)
	clang $(CFLAGS) $(SRC) $(FRAMEWORKS) -o $(APP_NAME)

bundle: all $(CONTENTS)/Info.plist
	mkdir -p $(MACOS) $(RESOURCES)
	cp $(APP_NAME) $(MACOS)/$(APP_NAME)
	echo -n 'APPL????' > $(CONTENTS)/PkgInfo

$(CONTENTS)/Info.plist: $(PLIST)
	mkdir -p $(CONTENTS)
	cp $(PLIST) $(CONTENTS)/Info.plist

zip: bundle
	zip -r $(APP_NAME).zip $(BUNDLE_DIR)

dmg: bundle
	rm -rf $(DMGROOT)
	mkdir -p $(DMGROOT)
	cp -R $(BUNDLE_DIR) $(DMGROOT)/$(BUNDLE_DIR)
	rm -f $(DMGROOT)/Applications
	ln -s /Applications $(DMGROOT)/Applications
	hdiutil create -volname $(APP_NAME) -srcfolder $(DMGROOT) -ov -format UDZO $(DMG)

run: all
	./$(APP_NAME)

clean:
	rm -f $(APP_NAME) $(APP_NAME).zip $(DMG)
	rm -rf $(BUNDLE_DIR) $(BUILD)