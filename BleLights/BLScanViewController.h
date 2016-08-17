//
//  NSMainViewController.h
//  BleLights
//
//  Created by 陆振文 on 16/8/9.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLScanViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIBarButtonItem *scannButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(IBAction)toggleScan:(id)sender;
-(IBAction)startScan;
@end
