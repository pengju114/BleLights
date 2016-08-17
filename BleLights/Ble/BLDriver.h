//
//  BLDriver.h
//  BleLights
//
//  Created by 陆振文 on 16/8/16.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BLDriverState){
    BLDriverConfiguring,
    BLDriverReady,
    BLDriverUnable
};

@class BLDriver;

typedef void(^BLDriverStateChangeCallback)(BLDriver *, BLDriverState);


@class CBPeripheral;

@interface BLDriver : NSObject

@property(nonatomic, assign, readonly) BLDriverState state;
@property(nonatomic, copy) BLDriverStateChangeCallback stateDidChangeCallback;

-(instancetype)initWithPeripheral:(CBPeripheral *)p;

// 连上后，驱动需要调用此方法重新配置
-(void)config;

@end
