//
//  CBPeripheral+ZWCompatible.h
//  BleLights
//
//  Created by 陆振文 on 16/8/10.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (ZWCompatible)

-(NSString *)UUIDString;
-(BOOL)connected;

@end
