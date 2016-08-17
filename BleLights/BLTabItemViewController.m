//
//  BLTabItemViewController.m
//  BleLights
//
//  Created by 陆振文 on 16/8/11.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLTabItemViewController.h"


@implementation BLTabItemViewController

-(void)viewDidLoad{
    [self setLayoutCompatible];
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.title = self.title;
}

@end
