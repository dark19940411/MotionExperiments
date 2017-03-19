
//
//  CALayer+Tools.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/17.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "CALayer+Tools.h"

@implementation CALayer (Tools)

+ (instancetype)layerWithCenterPoint:(CGPoint)point size:(CGSize)size {
    CALayer *layer = [[self class] layer];
    CGPoint orginPoint = CGPointMake(point.x - size.width/2, point.y - size.height/2);
    layer.frame = CGRectMake(orginPoint.x, orginPoint.y, size.width, size.height);
    return layer;
}

@end
