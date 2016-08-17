//
//  UIViewController+UIUtility.m
//  BleLights
//
//  Created by 陆振文 on 16/8/10.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "UIViewController+UIUtility.h"

@implementation UIViewController (UIUtility)

-(id)showMessage:(NSString *)title message:(NSString *)msg{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return alert;
    }else{
        UIAlertController *ctr = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [ctr addAction:cancel];
        [self presentViewController:ctr animated:YES completion:nil];
        return ctr;
    }
}

-(void)showNavagationBarProgress{
    UIActivityIndicatorView *p = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    p.hidesWhenStopped = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:p];
    [p startAnimating];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)hideNavagationBarProgress{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)setLayoutCompatible{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}


@end
