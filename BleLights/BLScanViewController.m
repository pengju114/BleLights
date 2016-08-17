//
//  NSMainViewController.m
//  BleLights
//
//  Created by 陆振文 on 16/8/9.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLScanViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "UIViewController+UIUtility.h"
#import "ZWBLEScanner.h"
#import "BLDevice.h"

#define kScanStateOn  1
#define kScanStateOff 0

@interface BLScanViewController () <ZWScannerDelegate, BLDeviceStateObserver>
@property(nonatomic, strong) NSMutableArray *lights;
@property(nonatomic, strong) ZWBLEScannerObserver *scanner;
@end

@implementation BLScanViewController
@synthesize lights;
@synthesize scanner;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lights = [NSMutableArray arrayWithCapacity:8];
    self.scanner = [[ZWBLEScannerObserver alloc] init];
    self.scanner.outsideDelegate = self;
    self.scanner.allowDuplicatePeripheral = NO;
    self.scanner.dispatchToMainQueue = YES;
    self.scanner.timeout = 20;
    [[ZWBLEScanner shareScanner] addScanObserver:self.scanner];
    
    self.scannButton.tag = kScanStateOff;
    
    [self setLayoutCompatible];
}

-(IBAction)startScan{
    [[ZWBLEScanner shareScanner] startScan:self.scanner];
}
-(void)stopScan{
    [[ZWBLEScanner shareScanner] stopScan:self.scanner];
}

- (void)centralManagerDidUpdateState:(CBCentralManager*)central{
    switch ([central state]) {
        case CBCentralManagerStateUnsupported:
            [self showMessage:@"提示" message:@"您的手机不支持蓝牙"];
            break;
        case CBCentralManagerStatePoweredOff:
            [self showMessage:@"提示" message:@"请打开蓝牙"];
            break;
        
        default:
            break;
    }
}

- (void)centralManagerDidStartDiscover:(CBCentralManager*)mgr{
    [self.lights removeAllObjects];
    [self.tableView reloadData];
    [self showNavagationBarProgress];
}

- (void)centralManagerDidEndDiscover:(CBCentralManager*)mgr{
    [self hideNavagationBarProgress];
}
- (void)centralManagerDidTimeout:(CBCentralManager*)mgr{
    [self hideNavagationBarProgress];
}

- (void)didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI{
    BLDevice *l = [[BLDevice alloc] initWithPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    
    [self.lights addObject:l];
    [self.tableView reloadData];
}

-(IBAction)toggleScan:(id)sender{
    UIBarButtonItem *item = sender;
    if ([item tag] == kScanStateOff) {
        [self startScan];
    }else{
        [item setTag:kScanStateOff];
        [self stopScan];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lights.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *lightID = @"LightCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lightID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:lightID];
    }
    
    [self setCellStyle:cell];
    
    BLDevice *l = [self.lights objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",l.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"信号强度 %d",[l.RSSI intValue]];
    
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
    [self stopScan];
    [self connect:[self.lights objectAtIndex:indexPath.row]];
}

-(void)connect:(BLDevice *)light{
    [self stopScan];
    [light addStateObserver:self];
    [light connect];
}

-(void)device:(BLDevice *)d stateDidChange:(BLDeviceState)s{
    if (s == BLDeviceConnected) {
        UIViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
