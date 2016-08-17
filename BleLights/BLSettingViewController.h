//
//  BLSettingViewController.h
//  BleLights
//
//  Created by 陆振文 on 16/8/11.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLTabItemViewController.h"

@interface BLSettingViewController : BLTabItemViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
