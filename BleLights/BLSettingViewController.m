//
//  BLSettingViewController.m
//  BleLights
//
//  Created by 陆振文 on 16/8/11.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLSettingViewController.h"
#import "BLDevice.h"
#import "BLDeviceManager.h"

@interface BLSettingViewController ()
@property(nonatomic, strong) NSMutableArray *array;
@end

@implementation BLSettingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"设置";
    self.array = [NSMutableArray arrayWithCapacity:8];
    [self.array addObjectsFromArray:[[BLDeviceManager shareManager] allDevicies]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"所有灯";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellID = @"cid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    
    [self setCellStyle:cell];
    
    BLDevice *d = [self.array objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = d.name;
    
    return cell;
}

-(void)setCellStyle:(UITableViewCell *)cell{
    UIColor *c = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    if ([cell respondsToSelector:@selector(tintColor)]) {
        cell.tintColor = c;
        cell.tintColor = c;
    }
    
    cell.contentView.backgroundColor = c;
    cell.backgroundView.backgroundColor = c;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundColor = c;
    
    UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    cell.selectedBackgroundView = bgView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
