//
//  FirstViewController.h
//  BleLights
//
//  Created by 陆振文 on 16/8/9.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTabItemViewController.h"
#import "KZColorPicker.h"

@interface BLColorViewController : BLTabItemViewController
@property (weak, nonatomic) IBOutlet UIView *itemsContainer;
@property (weak, nonatomic) IBOutlet UIView *pickerContainer;
@property (strong, nonatomic)  KZColorPicker *colorPicker;


@end

