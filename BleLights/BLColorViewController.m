//
//  FirstViewController.m
//  BleLights
//
//  Created by 陆振文 on 16/8/9.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLColorViewController.h"
#import "DOPDropDownMenu.h"
#import "BLDevice.h"
#import "BLDeviceManager.h"


@interface BLColorViewController () <DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
@property(nonatomic, strong) DOPDropDownMenu *itemsMenu;
@property(nonatomic, strong) NSArray  *devices;
@end

@implementation BLColorViewController

@synthesize itemsMenu;
@synthesize colorPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"调色";
    
    self.devices = [[BLDeviceManager shareManager] connectedDevicies];
    
    CGRect rect = self.itemsContainer.bounds;
    rect.size.height = 32;
    self.itemsMenu = [[DOPDropDownMenu alloc] initWithFrame:rect];
    self.itemsMenu.backgroundColor = [UIColor clearColor];
    self.itemsMenu.dataSource = self;
    self.itemsMenu.delegate = self;
    [self.itemsContainer addSubview:self.itemsMenu];
    
    self.colorPicker = [[KZColorPicker alloc] initWithFrame:self.pickerContainer.bounds];
    self.colorPicker.selectedColor = [UIColor whiteColor];
    [self.colorPicker addTarget:self action:@selector(colorDidPicked:) forControlEvents:UIControlEventValueChanged];
    self.colorPicker.backgroundColor = [UIColor clearColor];
    [self.pickerContainer addSubview:self.colorPicker];
    
    [self.colorPicker setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.itemsMenu setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    self.itemsMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.colorPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.itemsMenu.dataSource = self;
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return 1;
}

/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    return self.devices.count;
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    BLDevice *d = [self.devices objectAtIndex:indexPath.row];
    return d.name;
}

-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)colorDidPicked:(id)picker{
//    self.colorPicker.backgroundColor = [picker selectedColor];
}

@end
