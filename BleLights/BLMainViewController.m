//
//  BLMainViewController.m
//  BleLights
//
//  Created by 陆振文 on 16/8/11.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLMainViewController.h"
#import "UIViewController+UIUtility.h"
#import "UIImage+Utility.h"

@interface BLMainViewController () <UITabBarControllerDelegate>
@property(nonatomic, strong) UIView *selectedBackgroundView;
@end

@implementation BLMainViewController
@synthesize selectedBackgroundView;

-(void)viewDidLoad{
    
    UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle:self.tabBar.items[0].title image:[self img:@"color"] tag:0];//[self.tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:self.tabBar.items[1].title image:[self img:@"ct"] tag:1];//[self.tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:self.tabBar.items[2].title image:[self img:@"scene"] tag:2];//[self.tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:self.tabBar.items[3].title image:[self img:@"setting"] tag:3];//[self.tabBar.items objectAtIndex:3];
    // 对item设置相应地图片
    
    if ([item0 respondsToSelector:@selector(setSelectedImage:)]) {
        
        item0.selectedImage = [self img:@"color"];
        item1.selectedImage = [self img:@"ct"];
        item2.selectedImage = [self img:@"scene"];
        item3.selectedImage = [self img:@"setting"];
    }else{
        [item0 setFinishedSelectedImage:[self img:@"color"] withFinishedUnselectedImage:[self img:@"color"]];
        [item1 setFinishedSelectedImage:[self img:@"ct"] withFinishedUnselectedImage:[self img:@"ct"]];
        [item2 setFinishedSelectedImage:[self img:@"scene"] withFinishedUnselectedImage:[self img:@"scene"]];
        [item3 setFinishedSelectedImage:[self img:@"setting"] withFinishedUnselectedImage:[self img:@"setting"]];
    }
    
    self.viewControllers[0].tabBarItem = item0;
    self.viewControllers[1].tabBarItem = item1;
    self.viewControllers[2].tabBarItem = item2;
    self.viewControllers[3].tabBarItem = item3;
    
    [super viewDidLoad];
    
    [self setLayoutCompatible];
    
    self.delegate = self;
    
    UIView *selectedBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width / self.tabBar.items.count, self.tabBar.frame.size.height)];
    selectedBg.backgroundColor = [UIColor lightGrayColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        [self.tabBar insertSubview:selectedBg atIndex:1];
    }else{
        [self.tabBar insertSubview:selectedBg atIndex:0];
    }
    self.selectedBackgroundView = selectedBg;
    
//    
//    if ([[[UIDevice currentDevice] systemVersion]floatValue] < 7) {
//        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage backImageWithSize:CGSizeMake(24, 24) color:[UIColor whiteColor]] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
//        UIImage *bg = [[UIImage imageWithColor:[UIColor clearColor]] resizableImg:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [backBtn setBackgroundImage:bg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [backBtn setBackgroundImage:bg forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        
//        self.navigationItem.leftBarButtonItem = backBtn;
//    }
}


-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIImage *)img:(NSString *)name{
    UIImage *imgObj = [UIImage imageNamed:name];
    if ([imgObj respondsToSelector:@selector(imageWithRenderingMode:)]) {
        return [imgObj imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return imgObj;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger i = tabBarController.selectedIndex;
    CGFloat w = self.tabBar.frame.size.width / self.tabBar.items.count;
    CGRect rect = self.selectedBackgroundView.frame;
    rect.origin.x = i * w;
    rect.size.width = w;
    self.selectedBackgroundView.frame = rect;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSInteger i = self.selectedIndex;
    CGFloat w = self.tabBar.frame.size.width / self.tabBar.items.count;
    CGRect rect = self.selectedBackgroundView.frame;
    rect.origin.x = i * w;
    rect.size.width = w;
    self.selectedBackgroundView.frame = rect;
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

@end
