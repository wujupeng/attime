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
ICON_NAME=AppIcon
ICONSET=$(BUILD)/AtTime.iconset
LOGO=logo.ico

all: $(APP_NAME)
$(APP_NAME): $(SRC)
	clang $(CFLAGS) $(SRC) $(FRAMEWORKS) -o $(APP_NAME)

bundle: all $(CONTENTS)/Info.plist icon
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

icon:
	mkdir -p $(BUILD) $(ICONSET) $(RESOURCES)
	sips -s format png $(LOGO) --out $(BUILD)/base.png >/dev/null
	sips -z 16 16   $(BUILD)/base.png --out $(ICONSET)/icon_16x16.png >/dev/null
	sips -z 32 32   $(BUILD)/base.png --out $(ICONSET)/icon_16x16@2x.png >/dev/null
	sips -z 32 32   $(BUILD)/base.png --out $(ICONSET)/icon_32x32.png >/dev/null
	sips -z 64 64   $(BUILD)/base.png --out $(ICONSET)/icon_32x32@2x.png >/dev/null
	sips -z 128 128 $(BUILD)/base.png --out $(ICONSET)/icon_128x128.png >/dev/null
	sips -z 256 256 $(BUILD)/base.png --out $(ICONSET)/icon_128x128@2x.png >/dev/null
	sips -z 256 256 $(BUILD)/base.png --out $(ICONSET)/icon_256x256.png >/dev/null
	sips -z 512 512 $(BUILD)/base.png --out $(ICONSET)/icon_256x256@2x.png >/dev/null
	sips -z 512 512 $(BUILD)/base.png --out $(ICONSET)/icon_512x512.png >/dev/null
	sips -z 1024 1024 $(BUILD)/base.png --out $(ICONSET)/icon_512x512@2x.png >/dev/null
	iconutil -c icns $(ICONSET) -o $(RESOURCES)/$(ICON_NAME).icns

run: all
	./$(APP_NAME)

clean:
	rm -f $(APP_NAME) $(APP_NAME).zip $(DMG)
	rm -rf $(BUNDLE_DIR) $(BUILD)