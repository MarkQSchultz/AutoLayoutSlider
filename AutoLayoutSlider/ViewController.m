//
//  ViewController.m
//  AutoLayoutSlider
//
//  Created by Mark Schultz on 1/8/14.
//  Copyright (c) 2014 QZero Labs, LLC. All rights reserved.
//

#import "ViewController.h"
#import "SliderControl.h"

@interface ViewController ()

@property (nonatomic, strong) SliderControl *slider;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.slider = [SliderControl new];
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    self.slider.minimumValue = 3.0;
    self.slider.maximumValue = 8.0;
    [self.view addSubview:self.slider];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.slider
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.slider
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.slider
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.8
                                                           constant:0.0]];
    
    self.label = [UILabel new];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self sliderChanged];
    [self.view addSubview:self.label];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[slider]-50-[label]"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:@{ @"slider" : self.slider,
                                                                                 @"label" : self.label }]];
}


- (void)sliderChanged
{
    self.label.text = [NSString stringWithFormat:@"%f", self.slider.value];
}

@end
