//
//  AnimationProcessor.m
//  MotionExperiments
//
//  Created by turtle on 2017/1/30.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "AnimationProcessor.h"
#import <objc/runtime.h>

static char key;

@implementation UIView (AnimationProcessorExtends)

@dynamic animationProcessor;

- (void)setAnimationProcessor:(AnimationProcessor *)animationProcessor {
    AnimationProcessor *processor = [[AnimationProcessor alloc] init];
    objc_setAssociatedObject(self, &key, processor, OBJC_ASSOCIATION_RETAIN);
}

- (AnimationProcessor *)AnimationProcessor {
    return objc_getAssociatedObject(self, &key);
}

@end

@interface AnimationProcessor (){
    CGFloat _velocity;
    CGFloat _percentage;
    CADisplayLink *_displayLink;
}

@end

@implementation AnimationProcessor

#pragma mark -
#pragma mark inheritance
- (instancetype)init {
    self = [super init];
    if (self) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePercentage:)];
        _percentage = 0;
    }
    return self;
}

#pragma mark - 
#pragma mark public
- (void)setVelocity:(CGFloat)velocity {
    _velocity = velocity;
}

- (void)startAnimating {
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimating {
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark -
#pragma mark private
- (void)updatePercentage:(CADisplayLink *)displaylink {
    _percentage += _velocity;
    if (_percentage > 1) {
        _percentage = 0;
    }
    [_delegate updateLayerWithAnimationPercentage:_percentage];
}

@end
