//
//  CAAnimation+Tools.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/17.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "CAAnimation+Tools.h"

@implementation CABasicAnimation (Tools)

+ (CABasicAnimation *)animationWithKeypath:(NSString *)keypath
                                  delegate:(id<CAAnimationDelegate>)delegate
                                 fromValue:(id)fromValue
                                   toValue:(id)toValue
                                  duration:(CFTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keypath];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = delegate;
    return animation;
}

@end

@implementation CAKeyframeAnimation (Tools)

+ (CAKeyframeAnimation *)animationWithKeypath:(NSString *)keypath
                                     delegate:(id<CAAnimationDelegate>)delegate
                                       values:(NSArray *)values
                                     duration:(CFTimeInterval)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keypath];
    animation.values = values;
    animation.delegate = delegate;
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

@end
