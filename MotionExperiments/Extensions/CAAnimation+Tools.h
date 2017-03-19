//
//  CAAnimation+Tools.h
//  MotionExperiments
//
//  Created by turtle on 2017/3/17.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CABasicAnimation (Tools)
+ (CABasicAnimation *)animationWithKeypath:(NSString *)keypath
                                  delegate:(id<CAAnimationDelegate>)delegate
                                 fromValue:(id)fromValue
                                   toValue:(id)toValue
                                  duration:(CFTimeInterval)duration;
@end
