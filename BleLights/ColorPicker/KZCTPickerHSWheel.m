//
//  KZCTPickerHSWheel.m
//  BleLights
//
//  Created by 陆振文 on 16/8/14.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "KZCTPickerHSWheel.h"
#import "HSV.h"

@implementation KZCTPickerHSWheel

- (id)initAtOrigin:(CGPoint)origin
{
    return [self initAtOrigin:origin withImage:@"ctWheel"];
}

- (void) mapPointToColor:(CGPoint) point
{
    if (!CGRectContainsPoint(wheelImageView.frame, point)) {
        return;
    }
    
    float dis = sqrtf(powf(wheelImageView.center.x - point.x, 2) + powf(wheelImageView.center.y - point.y,2));
    if (dis > 120) {
        return;
    }
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    currentHSV = RGB_to_HSV(RGBTypeMake(pixel[0]/255.0,pixel[1]/255.0,pixel[2]/255.0));
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    wheelKnobView.center = point;
}

@end
