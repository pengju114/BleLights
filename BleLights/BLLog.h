//
//  BLLog.h
//  BleLights
//
//  Created by 陆振文 on 16/8/16.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG
#define BLLog(...) NSLog(__VA_ARGS__)
#else
#define BLLog(...)
#endif

@interface BLLog : NSObject

@end
