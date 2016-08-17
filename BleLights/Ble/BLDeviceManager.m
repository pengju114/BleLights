//
//  BLDeviceManager.m
//  BleLights
//
//  Created by 陆振文 on 16/8/17.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLDeviceManager.h"
#import "BLDevice.h"

static BLDeviceManager *_mgr = nil;


@interface BLDeviceManager ()
@property(nonatomic, strong) NSMutableSet *ds;
@end

@implementation BLDeviceManager

+(id)allocWithZone:(struct _NSZone *)zone{
    @synchronized (self) {
        if (!_mgr) {
            _mgr = [super allocWithZone:zone];
        }
    }
    return _mgr;
}

+(BLDeviceManager*)shareManager{
    @synchronized (self) {
        if (!_mgr) {
            _mgr = [[BLDeviceManager alloc] init];
        }
        return _mgr;
    }
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _ds = [NSMutableSet setWithCapacity:8];
    }
    return self;
}


-(void)addDevice:(BLDevice *)d{
    @synchronized (_ds) {
        [_ds addObject:d];
    }
}

-(NSArray *)allDevicies{
    @synchronized (_ds) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:_ds.count];
        for (BLDevice *d in _ds) {
            [array addObject:d];
        }
        
        return array;
    }
}

-(NSArray *)filterByState:(BLDeviceState)s{
    @synchronized (_ds) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:_ds.count];
        for (BLDevice *d in _ds) {
            if (s == d.state) {
                [array addObject:d];
            }
        }
        
        return array;
    }
}

-(NSArray *)connectedDevicies{
    return [self filterByState:BLDeviceConnected];
}

-(NSArray *)disconnectedDevicies{
    return [self filterByState:BLDeviceDisconnected];
}

@end
