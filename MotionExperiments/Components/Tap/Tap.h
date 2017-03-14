//
//  Tap.h
//  MotionExperiments
//
//  Created by turtle on 2017/2/4.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationProcessor.h"

#define TAP_MAX_RADIUS 40.0
#define TAP_MIN_RADIUS 20.0
#define OUTSIDE_CIRCLE_LINE_WIDTH 4.0
#define ANIMATION_VELOCITY 0.02

@interface Tap : UIView<AnimationProcessorDelegate>

@end
