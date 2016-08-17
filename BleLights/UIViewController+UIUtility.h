//
//  UIViewController+UIUtility.h
//  BleLights
//
//  Created by 陆振文 on 16/8/10.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIUtility)

-(id)showMessage:(NSString *)title message:(NSString *)msg;
-(void)showNavagationBarProgress;
-(void)hideNavagationBarProgress;

-(void)setLayoutCompatible;

@end
