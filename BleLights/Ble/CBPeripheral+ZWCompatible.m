//
//  CBPeripheral+ZWCompatible.m
//  BleLights
//
//  Created by 陆振文 on 16/8/10.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "CBPeripheral+ZWCompatible.h"

@implementation CBPeripheral (ZWCompatible)

-(NSString *)UUIDString{
    if ([self respondsToSelector:@selector(identifier)]) {
        return self.identifier.UUIDString;
    }else{
        CFUUIDRef uuidref = (__bridge CFUUIDRef)([self performSelector:@selector(UUID)]);
        if (uuidref) {
            CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidref);
            NSString *uuid = [NSString stringWithFormat:@"%@",strRef];
            CFRelease(strRef);
            return uuid;
        }
        return nil;
    }
}

-(BOOL)connected{
    if ([self respondsToSelector:@selector(state)]) {
        return self.state == CBPeripheralStateConnected;
    }
    
    return (BOOL)[self performSelector:@selector(isConnected)];
}

@end
