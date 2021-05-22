DEBUG=0
export ARCHS = arm64 arm64e
TARGET = iphone:13.0:13.0
THEOS_DEVICE_IP=192.168.168.121
THEOS_DEVICE_PORT=22

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Vinyl

Vinyl_FILES = Tweak.xm
Vinyl_CFLAGS = -fobjc-arc
Vinyl_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += vinylprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
