//
//  BLDeviceManager.h
//  BleLights
//
//  Created by 陆振文 on 16/8/17.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLDevice;

@interface BLDeviceManager : NSObject

+(BLDeviceManager *)shareManager;

-(void)addDevice:(BLDevice *)d;

-(NSArray *)allDevicies;

-(NSArray *)connectedDevicies;

-(NSArray *)disconnectedDevicies;

@end
