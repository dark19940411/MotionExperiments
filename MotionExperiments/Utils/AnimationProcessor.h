//
//  AnimationProcessor.h
//  MotionExperiments
//
//  Created by turtle on 2017/1/30.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AnimationProcessor;

@protocol AnimationProcessorDelegate <NSObject>

- (void)updateLayerWithAnimationPercentage:(CGFloat)percentage;

@end

@interface UIView (AnimationProcessorExtends)

@property (nonatomic, strong)AnimationProcessor *animationProcessor;

@end

@interface AnimationProcessor : NSObject

@property (nonatomic, weak) id<AnimationProcessorDelegate> delegate;

- (void)setVelocity:(CGFloat)velocity;//百分比增加的速度
- (void)startAnimating;
- (void)stopAnimating;

@end
