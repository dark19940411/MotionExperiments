//
//  PlayPauseIcon.h
//  MotionExperiments
//
//  Created by turtle on 2017/1/31.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationProcessor.h"

#define EACH_COMPONENT_WIDTH 70.0
#define EACH_COMPONENT_HEIGHT 90.0
#define COMPONENT_CAP 5.0
#define ANIMATION_VELOCITY 0.06

@protocol PlayPauseIconDelegate <NSObject>

- (void)enableTapGestureRecognizer;

@end

@interface PlayPauseIcon : UIView <AnimationProcessorDelegate>

@property (nonatomic, weak) id<PlayPauseIconDelegate> delegate;

@end
