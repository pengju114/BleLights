//
//  BLSceneViewController.h
//  BleLights
//
//  Created by 陆振文 on 16/8/11.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLTabItemViewController.h"
#import "KZColorPickerBrightnessSlider.h"

@interface BLSceneViewController : BLTabItemViewController
@property (weak, nonatomic) IBOutlet UIView *colorsContainer;
@property (weak, nonatomic) IBOutlet UIView *brightnessSliderCtr;

@end
