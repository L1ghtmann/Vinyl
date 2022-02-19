export DEBUG = 0
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:12.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Vinyl

Vinyl_FILES = Tweak.xm
Vinyl_CFLAGS = -fobjc-arc
Vinyl_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += VinylPrefs

include $(THEOS_MAKE_PATH)/aggregate.mk
