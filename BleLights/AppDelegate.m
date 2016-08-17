//
//  AppDelegate.m
//  BleLights
//
//  Created by 陆振文 on 16/8/9.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImage+Utility.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setNavigationBarStyle];
    [self setTabBarStyle];
    return YES;
}

-(void)setNavigationBarStyle{
    //1. 设置导航栏的背景图片
    UINavigationBar *bar=[UINavigationBar appearance];
    //[bar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background.png"] forBarMetrics:UIBarMetricsDefault];
    [bar setBackgroundColor:[UIColor darkGrayColor]];
    
    bar.barStyle = UIStatusBarStyleLightContent;
    
    bar.tintColor = [UIColor whiteColor];
    if ([bar respondsToSelector:@selector(barTintColor)]) {
        bar.barTintColor = [UIColor darkGrayColor];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        
        [bar setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor]] forBarMetrics:UIBarMetricsDefault];
        
        CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
        rect.origin.y = - rect.size.height;
        UIView *statusBarView = [[UIView alloc] initWithFrame:rect];
        statusBarView.backgroundColor = [UIColor lightGrayColor];
        [bar addSubview:statusBarView];
        
    }
    
    [bar setTitleTextAttributes:@{
                                  NSFontAttributeName: [UIFont systemFontOfSize:22],
                                  NSForegroundColorAttributeName: [UIColor whiteColor]
                                  }];
    
    //1.2 设置返回按钮的颜色  在plist中添加 View controller-based status bar appearance=NO切记。
    //    [bar setTintColor:kBackButtonColor];
    //	//设置返回按钮指示器图片
    //	UIImage *backImage=[[UIImage imageNamed:@"navigationbar_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 5)];
    //	[[UINavigationBar appearance] setBackIndicatorImage:backImage];
    //	[[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navigationbar_back_highlighted"]];
    //
    //2. 设置导航栏文字的主题
    [bar setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName:[UIColor whiteColor],
                                  }];
    //3. 设置UIBarButtonItem的外观
    UIBarButtonItem *barItem=[UIBarButtonItem appearance];
    //4. 该item上边的文字样式
    NSDictionary *fontDic=@{
                            NSForegroundColorAttributeName:[UIColor whiteColor],
                            NSFontAttributeName: [UIFont systemFontOfSize:14]
                            };
    [barItem setTitleTextAttributes:fontDic
                           forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:fontDic
                           forState:UIControlStateHighlighted];

    [barItem setBackgroundImage:[[UIImage imageWithColor:[UIColor clearColor]] resizableImg:UIEdgeInsetsMake(1, 1, 1, 1)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barItem setBackgroundImage:[[UIImage imageWithColor:[UIColor clearColor]] resizableImg:UIEdgeInsetsMake(1, 1, 1, 1)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    barItem.tintColor = [UIColor clearColor];
    
    
    // 5.设置状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)setTabBarStyle{
    UITabBar *bar = [UITabBar appearance];
    if ([bar respondsToSelector:@selector(setTranslucent:)]) {
        bar.translucent = NO;
    }
    
    UIColor *bgColor = [UIColor whiteColor];
    [bar setBackgroundImage:[[UIImage imageWithColor:bgColor] resizableImg:UIEdgeInsetsMake(1, 1, 1, 1)]];
    
    bar.tintColor = bgColor;
//    if ([bar respondsToSelector:@selector(barTintColor)]) {
//        bar.barTintColor = [UIColor lightGrayColor];
//    }
    
    bar.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
    bar.selectedImageTintColor = [UIColor clearColor];
    bar.selectionIndicatorImage = [UIImage imageWithColor:[UIColor clearColor]];
    
    UITabBarItem *tabItem = [UITabBarItem appearance];
    
    [tabItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                      }
                           forState:UIControlStateNormal];
    [tabItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName:[UIColor whiteColor]//[UIColor colorWithRed:0.290 green:0.686 blue:0.973 alpha:1.00]
                                      
                                      }
                           forState:UIControlStateSelected];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
