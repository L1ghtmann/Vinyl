include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = VinylPrefs
ARCHS = arm64 arm64e
VinylPrefs_FILES = $(wildcard *.m)
VinylPrefs_INSTALL_PATH = /Library/PreferenceBundles
VinylPrefs_FRAMEWORKS = UIKit
VinylPrefs_PRIVATE_FRAMEWORKS = Preferences
VinylPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/VinylPrefs.plist$(ECHO_END)
