//
//  SliderControl.h
//  AutoLayoutSlider
//
//  Created by Mark Schultz on 1/8/14.
//  Copyright (c) 2014 QZero Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderControl : UIControl

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *gripColor;
@property (nonatomic, assign) CGFloat value;                                 // default 0.0. this value will be pinned to min/max
@property (nonatomic, assign) CGFloat minimumValue;                          // default 0.0. the current value may change if outside new min value
@property (nonatomic, assign) CGFloat maximumValue;                          // default 1.0. the current value may change if outside new max value


@end
