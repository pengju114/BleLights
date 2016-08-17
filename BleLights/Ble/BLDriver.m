//
//  BLDriver.m
//  BleLights
//
//  Created by 陆振文 on 16/8/16.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLDriver.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLLog.h"


static const NSString* BLServiceUUIDs[] = {@""};
static const NSString* BLWriteCharacteristicUUIDs[] = {@""};
static const NSString* BLReadCharacteristicUUIDs = {@""};


@interface BLDriver ()<CBPeripheralDelegate>
@property(nonatomic, strong) CBPeripheral *peripheral;
@end

@implementation BLDriver
@synthesize state = _state;
@synthesize stateDidChangeCallback;

-(instancetype)initWithPeripheral:(CBPeripheral *)p{
    if (self = [super init]) {
        _peripheral = p;
    }
    return self;
}

-(void)config{
    _peripheral.delegate = self;
    [self dispatchState:BLDriverConfiguring];
    [_peripheral discoverServices:nil];
}

-(void)dispatchState:(BLDriverState)s{
    _state = s;
    if (stateDidChangeCallback) {
        stateDidChangeCallback(self, s);
    }
}


#pragma mark CBPeripheralDelegate methods

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    if (error) {
        BLLog(@"discover services error:%@",error);
        [self dispatchState:BLDriverUnable];
        return;
    }
    for (CBService *s in peripheral.services) {
        // 过滤
        BLLog(@"discover service success:%@, start discover characristic",s.UUID);
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    if (error) {
        BLLog(@"discover characteristics error for services[%@]:%@",service,error);
        [self dispatchState:BLDriverUnable];
        return;
    }
    for (CBCharacteristic *c in service.characteristics) {
        // 过滤
        BLLog(@"discover characteristics success:%@, set notify",c.UUID);
        [peripheral readValueForCharacteristic:c];
        [peripheral setNotifyValue:YES forCharacteristic:c];
    }
}

/*!
 *  @method peripheral:didUpdateValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (error) {
        BLLog(@"read error for characteristic[%@]:%@",characteristic.UUID,error);
    }else{
        BLLog(@"read success for characteristic[%@]:%@",characteristic.UUID,characteristic.value);
    }
}

/*!
 *  @method peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a {@link writeValue:forCharacteristic:type:} call, when the <code>CBCharacteristicWriteWithResponse</code> type is used.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (error) {
        BLLog(@"write error for characteristic[%@]:%@",characteristic.UUID,error);
    }else{
        BLLog(@"write success for characteristic[%@]:%@",characteristic.UUID,characteristic.value);
    }
}

/*!
 *  @method peripheral:didUpdateNotificationStateForCharacteristic:error:
 *  @discussion				This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (error) {
        BLLog(@"didUpdateNotificationStateForCharacteristic error for characteristic[%@]:%@",characteristic.UUID,error);
    }else{
        BLLog(@"didUpdateNotificationStateForCharacteristic success for characteristic[%@]",characteristic.UUID);
        [self dispatchState:BLDriverReady];
    }
}

@end
