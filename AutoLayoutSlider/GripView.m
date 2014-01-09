//
//  GripView.m
//  AutoLayoutSlider
//
//  Created by Mark Schultz on 1/8/14.
//  Copyright (c) 2014 QZero Labs, LLC. All rights reserved.
//

#import "GripView.h"

@interface GripView()

@property (nonatomic, strong) CAShapeLayer *layer;

@end

@implementation GripView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.layer.path = CGPathCreateWithEllipseInRect(bounds, nil);
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    self.layer.fillColor = self.fillColor.CGColor;
}

@end
