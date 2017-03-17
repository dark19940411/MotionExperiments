//
//  AnimatableDonutsLayer.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/17.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "AnimatableDonutsLayer.h"
#import "Extensions.h"

#define START_RADIUS 0.1
#define DURATION 1

@implementation AnimatableDonutsLayer {
    CGPoint _centerPoint;
    CGFloat _excRadius;
    CGFloat _inRadius;
    CGFloat _radiusOffset;
    CAShapeLayer *_insideLayer;
}

#pragma mark -
#pragma mark Initialization
+ (AnimatableDonutsLayer *)layerWithCenterPoint:(CGPoint)centerPoint
                                      ExcRadius:(CGFloat)excRadius
                                       inRadius:(CGFloat)inRadius
                                andRadiusOffset:(CGFloat)radiusOffset
{
    CGFloat edge = (excRadius + radiusOffset) * 2;
    AnimatableDonutsLayer *layer = [AnimatableDonutsLayer layerWithCenterPoint:centerPoint size:CGSizeMake(edge, edge)];
    layer->_centerPoint = CGPointMake(edge/2, edge/2);
    layer->_excRadius = excRadius;
    layer->_inRadius = inRadius;
    layer->_radiusOffset = radiusOffset;
    [layer __setupDonutsLayer];
    return layer;
}

- (void)__setupDonutsLayer {
    self.lineWidth = 0;
    self.fillColor = [UIColor blackColor].CGColor;
    self.path = [UIBezierPath circlePathWithCenterPoint:_centerPoint radius:START_RADIUS].CGPath;
}

#pragma mark -
#pragma mark AnimationDelegate
- (void)startAnimation {
    CGFloat extendingTimes = (_excRadius - _inRadius + _radiusOffset)/START_RADIUS;
    CATransform3D extendingTransf = CATransform3DMakeScale(extendingTimes, extendingTimes, 1);
    
    NSValue *fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    NSValue *toValue = [NSValue valueWithCATransform3D:extendingTransf];
    
    CABasicAnimation *extendingAnimation = [CABasicAnimation animationWithKeypath:@"transform"
                                                                         delegate:self
                                                                        fromValue:fromValue
                                                                          toValue:toValue
                                                                         duration:1.0/3.0];
    
    [self addAnimation:extendingAnimation forKey:@"ExtendingAnimation"];
    
}

#pragma mark -
#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
}

#pragma mark -
#pragma mark Configure Animations


@end
