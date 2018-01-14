include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BatteryStatus
BatteryStatus_FILES = Tweak.x
BatteryStatus_PRIVATE_FRAMEWORKS = BatteryCenter BluetoothManager
BatteryStatus_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
