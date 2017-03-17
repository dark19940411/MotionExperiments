//
//  PublicAnimationLayer.h
//  MotionExperiments
//
//  Created by turtle on 2017/3/14.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationDelegate.h"

@interface PublicAnimationLayer : CALayer <AnimationDelegate, CAAnimationDelegate> //这是一个抽象类=。=

@end

@interface PublicAnimationShapeLayer : CAShapeLayer <AnimationDelegate, CAAnimationDelegate>   //这也是一个抽象类

@end
