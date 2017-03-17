//
//  UIBezierPath+CommonPath.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/17.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "UIBezierPath+CommonPath.h"

@implementation UIBezierPath (CommonPath)

+ (UIBezierPath *)circlePathWithCenterPoint:(CGPoint)centerPoint radius:(CGFloat)radius {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:centerPoint radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    return bezierPath;
}

@end
