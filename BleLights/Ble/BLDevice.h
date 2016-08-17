//
//  BLDevice.h
//  BleLights
//
//  Created by 陆振文 on 16/8/12.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;


typedef NS_ENUM(NSInteger, BLDeviceState) {
    BLDeviceDisconnected,
    BLDeviceConnecting,
    BLDeviceConnected
};

@class BLDevice;

@protocol BLDeviceStateObserver <NSObject>

@required
-(void)device:(BLDevice *)d stateDidChange:(BLDeviceState)s;

@end


@interface BLDevice : NSObject

@property(nonatomic, strong, readonly) CBPeripheral *peripheral;
@property(nonatomic, strong, readonly) NSDictionary *advertisementData;
@property(nonatomic, strong, readonly) NSNumber     *RSSI;
@property(nonatomic, assign, readonly) BLDeviceState state;

@property(nonatomic, assign, readonly, getter=isConnected) BOOL connected;

-(instancetype)initWithPeripheral:(CBPeripheral *)p advertisementData:(NSDictionary *)dic RSSI:(NSNumber *)RSSI;

-(NSString *)name;

-(void)connect;
-(void)disconnect;

-(void)addStateObserver:(id<BLDeviceStateObserver>)obsr;
-(void)removeStateObserver:(id<BLDeviceStateObserver>)obsr;

@end
