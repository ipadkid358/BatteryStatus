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

// iOS 3 - 11
@interface SBBluetoothController : NSObject
+ (instancetype)sharedInstance;
- (void)updateBattery;
@end


%hook BluetoothDevice

- (int)batteryLevel {
    NSString *thisAddress = self.address;
    for (BCBatteryDevice *targ in BCBatteryDeviceController.sharedInstance.connectedDevices) {
        if ([targ.matchIdentifier isEqualToString:thisAddress]) {
            return targ.percentCharge;
        }
    }
    
    return %orig;
}

- (BOOL)supportsBatteryLevel {
    return (self.batteryLevel != -1);
}

%end


%hook BCBatteryDevice

- (void)setPercentCharge:(long long)charge {
    %orig;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SBBluetoothController *bluetoothController = [objc_getClass("SBBluetoothController") sharedInstance];
        [bluetoothController updateBattery];
    });
}

%end
