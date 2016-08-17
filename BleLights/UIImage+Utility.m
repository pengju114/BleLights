//
//  UIImage+Utility.m
//  BleLights
//
//  Created by 陆振文 on 16/8/12.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

+(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 4, 4);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage *)resizableImg:(UIEdgeInsets)capInsets{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
        return  [self resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    }else if([self respondsToSelector:@selector(resizableImageWithCapInsets:)]){
        return [self resizableImageWithCapInsets:capInsets];
    }else{
        CGSize size = [self size];
        CGFloat leftCap = (size.width - (capInsets.right + capInsets.left)) * 0.5f + capInsets.left - 1;
        CGFloat topCap  = (size.height - (capInsets.top + capInsets.bottom)) * 0.5f + capInsets.top - 1;
        return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
    }
}


+(UIImage *)backImageWithSize:(CGSize)size color:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, size.width,size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context,true);
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    
    CGFloat strokeWidth = 2.5f;
    CGFloat padding     = strokeWidth;
    
    size.height -= (strokeWidth * 2);
    size.width  -= (strokeWidth * 2);
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetLineJoin(context, kCGLineJoinMiter);
    
    // 最长弦长度
    CGFloat c    = size.height;
    CGFloat extX = c * 0.25f;
    CGFloat x1   = size.width * 0.5f + padding + extX;
    CGFloat x2   = padding + extX;
    CGFloat y1   = padding;
    CGFloat y2   = y1 + size.height * 0.5f;
    CGFloat y3   = y1 + size.height;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, x1, y1);
    CGContextAddLineToPoint(context, x2, y2);
    CGContextAddLineToPoint(context, x1, y3);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
