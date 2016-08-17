//
//  BLDevice.m
//  BleLights
//
//  Created by 陆振文 on 16/8/12.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLDevice.h"
#import "CBPeripheral+ZWCompatible.h"
#import "ZWBLEScanner.h"
#import "BLLog.h"
#import "BLDriver.h"
#import "BLDeviceManager.h"

@interface BLDevice () <CBCentralManagerDelegate>
@property(nonatomic, strong) NSMutableSet *observers;
@property(nonatomic, strong) BLDriver     *driver;
@end

@implementation BLDevice

- (instancetype)init
{
    return nil;
}

-(instancetype)initWithPeripheral:(CBPeripheral *)p advertisementData:(NSDictionary *)dic RSSI:(NSNumber *)RSSI{
    if (self = [super init]) {
        _peripheral = p;
        _advertisementData = dic;
        _RSSI = RSSI;
        _observers = [NSMutableSet setWithCapacity:6];
        _driver    = [[BLDriver alloc] initWithPeripheral:p];
        [[BLDeviceManager shareManager] addDevice:self];
    }
    return self;
}

-(void)dispatchState:(BLDeviceState)s{
    _state = s;
    if (s == BLDeviceConnected) {
        [_driver config];
    }
    @synchronized (_observers) {
        for (id<BLDeviceStateObserver> o in _observers) {
            [o device:self stateDidChange:s];
        }
    }
}

-(BOOL)isConnected{
    return [_peripheral connected];
}

-(NSString *)name{
    NSString *name = [_advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if (!name) {
        name = [_peripheral name];
    }
    return name;
}


-(void)addStateObserver:(id<BLDeviceStateObserver>)obsr{
    @synchronized (_observers) {
        [_observers addObject:obsr];
    }
}

-(void)removeStateObserver:(id<BLDeviceStateObserver>)obsr{
    @synchronized (_observers) {
        [_observers removeObject:obsr];
    }
}

-(void)connect{
    [[[ZWBLEScanner shareScanner] zwCentralManager] addCentralManagerObserver:self];
    
    [self dispatchState:BLDeviceConnecting];
    
    if ([_peripheral connected]) {
        [self dispatchState:BLDeviceConnected];
    }else{
        [[[ZWBLEScanner shareScanner] zwCentralManager] connect:self];
    }
}

-(void)disconnect{
    if (![_peripheral connected]) {
        [self dispatchState:BLDeviceDisconnected];
    }else{
        [[[ZWBLEScanner shareScanner] zwCentralManager] cancelConnect:self];
    }
}

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        return [_peripheral isEqual:[object peripheral]];
    }
    return NO;
}

-(NSUInteger)hash{
    return [_peripheral hash];
}


#pragma mark CBCentralManager delagate methods
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    BLLog(@"peripheral[%@] did connect",[self name]);
    [self dispatchState:BLDeviceConnected];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    BLLog(@"peripheral[%@] did fail to connect:%@",[self name], error);
    [self dispatchState:BLDeviceDisconnected];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    BLLog(@"peripheral[%@] did disconnect:%@",[self name],error);
    [self dispatchState:BLDeviceDisconnected];
}

@end
