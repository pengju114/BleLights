//
//  ZWCentralManager.m
//  BleLights
//
//  Created by luzhenwen on 16/8/16.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "ZWCentralManager.h"
#import "BLDevice.h"

@interface ZWCentralManager () <CBCentralManagerDelegate>

@property(nonatomic, strong) NSMutableSet *observers;

@end

@implementation ZWCentralManager

@synthesize centralManager;

- (instancetype)init
{
    self = [super init];
    if (self) {
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _observers = [NSMutableSet setWithCapacity:8];
    }
    return self;
}

-(void)addCentralManagerObserver:(id<CBCentralManagerDelegate>)observer{
    @synchronized (_observers) {
        [_observers addObject:observer];
    }
}

-(void)removeCentralManagerObserver:(id<CBCentralManagerDelegate>)observer{
    @synchronized (_observers) {
        [_observers removeObject:observer];
    }
}


-(void)connect:(BLDevice *)d{
    [centralManager connectPeripheral:d.peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:[NSNumber numberWithBool:YES],CBConnectPeripheralOptionNotifyOnDisconnectionKey:[NSNumber numberWithBool:YES]}];
}

-(void)cancelConnect:(BLDevice *)d{
    [centralManager cancelPeripheralConnection:d.peripheral];
}

#pragma mark CBCentralManager delegate methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    @synchronized (_observers) {
        for (id<CBCentralManagerDelegate> obsr in _observers) {
            if ([obsr respondsToSelector:@selector(centralManagerDidUpdateState:)]) {
                [obsr centralManagerDidUpdateState:central];
            }
        }
    }
}

// @optional

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    @synchronized (_observers) {
        for (id<CBCentralManagerDelegate> obsr in _observers) {
            if ([obsr respondsToSelector:@selector(centralManager:willRestoreState:)]) {
                [obsr centralManager:central willRestoreState:dict];
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    @synchronized (_observers) {
        for (id<CBCentralManagerDelegate> obsr in _observers) {
            if ([obsr respondsToSelector:@selector(centralManager:didDiscoverPeripheral:advertisementData:RSSI:)]) {
                [obsr centralManager:central didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    @synchronized (_observers) {
        for (id<CBCentralManagerDelegate> obsr in _observers) {
            if ([obsr respondsToSelector:@selector(centralManager:didConnectPeripheral:)]) {
                [obsr centralManager:central didConnectPeripheral:peripheral];
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    @synchronized (_observers) {
        for (id<CBCentralManagerDelegate> obsr in _observers) {
            if ([obsr respondsToSelector:@selector(centralManager:didFailToConnectPeripheral:error:)]) {
                [obsr centralManager:central didFailToConnectPeripheral:peripheral error:error];
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    @synchronized (_observers) {
        for (id<CBCentralManagerDelegate> obsr in _observers) {
            if ([obsr respondsToSelector:@selector(centralManager:didDisconnectPeripheral:error:)]) {
                [obsr centralManager:central didDisconnectPeripheral:peripheral error:error];
            }
        }
    }
}

@end
