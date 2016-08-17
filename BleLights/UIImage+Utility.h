//
//  UIImage+Utility.h
//  BleLights
//
//  Created by 陆振文 on 16/8/12.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

+(UIImage *)imageWithColor:(UIColor *)color;

-(UIImage *)resizableImg:(UIEdgeInsets)capInsets;

+(UIImage *)backImageWithSize:(CGSize)size color:(UIColor *)color;

@end
