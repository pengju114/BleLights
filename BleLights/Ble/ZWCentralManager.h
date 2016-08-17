//
//  ZWCentralManager.h
//  BleLights
//
//  Created by luzhenwen on 16/8/16.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class BLDevice;

@interface ZWCentralManager : NSObject

@property(nonatomic, strong, readonly) CBCentralManager *centralManager;

-(void)addCentralManagerObserver:(id<CBCentralManagerDelegate>)observer;
-(void)removeCentralManagerObserver:(id<CBCentralManagerDelegate>)observer;

-(void)connect:(BLDevice *)d;
-(void)cancelConnect:(BLDevice *)d;

@end
