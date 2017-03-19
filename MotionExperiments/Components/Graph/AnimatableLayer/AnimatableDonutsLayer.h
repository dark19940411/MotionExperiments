//
//  AnimatableDonutsLayer.h
//  MotionExperiments
//
//  Created by turtle on 2017/3/17.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "PublicAnimationLayer.h"

@interface AnimatableDonutsLayer : PublicAnimationShapeLayer

+ (AnimatableDonutsLayer *)layerWithCenterPoint:(CGPoint)centerPoint
                                      ExcRadius:(CGFloat)excRadius
                                       inRadius:(CGFloat)inRadius
                                andRadiusOffset:(CGFloat)radiusOffset
                                    parentLayer:(CALayer *)parentLayer;

@end
