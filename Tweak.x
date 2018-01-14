// iOS 9 - 11
@interface BCBatteryDevice : NSObject <NSCopying, NSCoding>
- (NSString *)matchIdentifier;
- (long long)percentCharge;
@end

// iOS 9 - 11
@interface BCBatteryDeviceController : NSObject
+ (instancetype)sharedInstance;
- (NSArray<BCBatteryDevice *> *)connectedDevices;
@end

// iOS 5 - 11
@interface BluetoothDevice : NSObject
- (NSString *)address;
- (int)batteryLevel;
@end

%hook BluetoothDevice

- (int)batteryLevel {
    for (BCBatteryDevice *targ in BCBatteryDeviceController.sharedInstance.connectedDevices) {
        if ([targ.matchIdentifier isEqualToString:self.address]) {
            return targ.percentCharge;
        }
    }
    return -1;
}

- (BOOL)supportsBatteryLevel {
    return (self.batteryLevel != -1);
}

%end
