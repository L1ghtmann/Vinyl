DEBUG=0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Vinyl

Vinyl_FILES = Tweak/Tweak.xm Tweak/VinylManager.m
Vinyl_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += vinylprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
