//
//  BLSceneViewController.m
//  BleLights
//
//  Created by 陆振文 on 16/8/11.
//  Copyright © 2016年 pengju. All rights reserved.
//

#import "BLSceneViewController.h"


@interface BLSceneViewController ()
@property(nonatomic, strong) KZColorPickerBrightnessSlider *slider;
@end

@implementation BLSceneViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"场景";
    [self setLayoutCompatible];
    
    CGFloat radius = self.colorsContainer.frame.size.height / 2.0f;
    for (UIView *c in self.colorsContainer.subviews) {
        c.layer.cornerRadius = radius;
    }
    self.slider = [[KZColorPickerBrightnessSlider alloc] initWithFrame:CGRectMake(0, 0, self.brightnessSliderCtr.frame.size.width, 24)];
    [self.slider addTarget:self action:@selector(brightnessChange:) forControlEvents:UIControlEventValueChanged];
    [self.brightnessSliderCtr addSubview:self.slider];
    
    [self.slider setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    CGRect r = self.slider.frame;
//    r.origin.x = (self.brightnessSliderCtr.frame.size.width - r.size.width) * 0.5f;
//    self.slider.frame = r;
//}

-(void)brightnessChange:(KZColorPickerBrightnessSlider *)sender{
    
}

@end
