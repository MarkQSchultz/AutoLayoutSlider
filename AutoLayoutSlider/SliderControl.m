//
//  SliderControl.m
//  AutoLayoutSlider
//
//  Created by Mark Schultz on 1/8/14.
//  Copyright (c) 2014 QZero Labs, LLC. All rights reserved.
//

#import "SliderControl.h"
#import "GripView.h"

static CGFloat SliderGripControlLargeSize = 30.0;

@interface SliderControl()

@property (nonatomic, strong) GripView *gripView;
@property (nonatomic, strong) NSLayoutConstraint *gripCenterXConstraint;
@property (nonatomic, assign) CGFloat lastTouchX;

@end

@implementation SliderControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        // Create Grip View
        self.gripView = [GripView new];
        self.gripView.translatesAutoresizingMaskIntoConstraints = NO;
        self.gripView.userInteractionEnabled = NO;
        [self addSubview:self.gripView];
        
        self.gripView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.gripView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        NSDictionary *metrics = @{ @"size" : @(SliderGripControlLargeSize) };
        NSDictionary *views = @{ @"grip" : self.gripView };
        
        [self.gripView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[grip(size)]"
                                                                              options:kNilOptions
                                                                              metrics:metrics
                                                                                views:views]];
        
        [self.gripView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[grip(size)]"
                                                                              options:kNilOptions
                                                                              metrics:metrics
                                                                                views:views]];
        
        // Create, store, and add constraints for moving Grip View
        self.gripCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.gripView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:SliderGripControlLargeSize / 2.0];
        [self addConstraint:self.gripCenterXConstraint];
        
        // Set some default colors
        self.trackColor = [UIColor lightGrayColor];
        self.gripColor = [UIColor darkTextColor];
        self.minimumValue = 0.0;
        self.maximumValue = 1.0;
    }
    return self;
}


- (void)changeValue
{
    CGFloat percentage = [self calculatePercentage];
    [self changeValueFromPercentage:percentage];
}


- (void)changeValueFromPercentage:(CGFloat)percentage
{
    self.value = percentage * (self.maximumValue - self.minimumValue) + self.minimumValue;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (CGFloat)calculatePercentage
{
    CGFloat gripX = self.gripCenterXConstraint.constant;
    CGFloat halfGrip = SliderGripControlLargeSize / 2.0;
    CGFloat width = self.bounds.size.width;
    CGFloat percentage = (gripX - halfGrip) / (width - SliderGripControlLargeSize);
    return percentage;
}


- (void)setBounds:(CGRect)bounds
{
    CGFloat percentage = [self calculatePercentage];
    [super setBounds:bounds];
    
    CGFloat usableWidth = self.bounds.size.width - SliderGripControlLargeSize;
    self.gripCenterXConstraint.constant = percentage * usableWidth + SliderGripControlLargeSize / 2.0;
}



#pragma mark - Touch Tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    CGRect targetRect = self.gripView.frame;
    CGFloat sizeOffset = (50.0 - targetRect.size.width) / 2.0;
    targetRect = CGRectInset(targetRect, -sizeOffset, -sizeOffset);
    if (CGRectContainsPoint(targetRect, touchPoint))
    {
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.gripView layoutIfNeeded];
                             self.gripView.transform = CGAffineTransformIdentity;
                         }];
        self.lastTouchX = touchPoint.x;
        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat width = self.bounds.size.width;
    CGFloat halfGrip = SliderGripControlLargeSize / 2.0;
    CGFloat xDiff = touchPoint.x - self.lastTouchX;
    self.lastTouchX = touchPoint.x;
    if ((touchPoint.x >= halfGrip && xDiff > 0) || (touchPoint.x <= width - halfGrip && xDiff < 0))
    {
        CGFloat currentGripX = self.gripCenterXConstraint.constant;
        CGFloat newGripX = currentGripX + xDiff;
        newGripX = MAX(SliderGripControlLargeSize / 2.0, newGripX);
        newGripX = MIN(width - SliderGripControlLargeSize / 2.0, newGripX);
        self.gripCenterXConstraint.constant = newGripX;
        [self changeValue];
    }
    
    return YES;
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         [self.gripView layoutIfNeeded];
                         self.gripView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                     }];
}



#pragma mark - Property Setters
- (void)setTrackColor:(UIColor *)trackColor
{
    if (![self.trackColor isEqual:trackColor])
    {
        _trackColor = trackColor;
        [self setNeedsDisplay];
    }
}

- (void)setGripColor:(UIColor *)gripColor
{
    if (![self.gripColor isEqual:gripColor])
    {
        _gripColor = gripColor;
        self.gripView.fillColor = self.gripColor;
    }
}


- (void)setMinimumValue:(CGFloat)minimumValue
{
    _minimumValue = minimumValue;
    [self changeValue];
}


- (void)setMaximumValue:(CGFloat)maximumValue
{
    _maximumValue = maximumValue;
    [self changeValue];
}



#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat lineWidth = 10.0;
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, self.trackColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGFloat midY = CGRectGetMidY(rect);
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect) + lineWidth / 2.0, midY);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect) - lineWidth / 2.0, midY);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
}



#pragma mark - Sizing
- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, SliderGripControlLargeSize);
}

@end
