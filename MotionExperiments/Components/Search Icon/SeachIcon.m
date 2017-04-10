//
//  SeachIcon.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/15.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "SeachIcon.h"

#define CIRCLE_RADIUS_OFF_SEARCHING (SI_BG_WIDTH/3.0)
#define CIRCLE_RADIUS_IN_SEARCHING (SI_BG_WIDTH*2.0/5.0)

@implementation SeachIcon {
    BOOL _searching;
    CAShapeLayer *_circleLayer;          //搜索的圆圈的layer
    CAShapeLayer *_handleLayer;          //放大镜的柄layer
}

#pragma mark -
#pragma mark Inheritance
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _searching = NO;
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        _circleLayer.backgroundColor = [UIColor blackColor].CGColor;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.lineWidth = 5.0;
        maskLayer.lineJoin = kCALineJoinRound;
        maskLayer.lineCap = kCALineCapRound;
        maskLayer.path = [self __createCirclePathWithRadius:SI_BG_WIDTH/2 -25].CGPath;
        _circleLayer.mask = maskLayer;
        
        [self.layer addSublayer:_circleLayer];
    }
    return self;
}

- (UIBezierPath *)__createCirclePathWithRadius:(CGFloat)radius {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(SI_BG_WIDTH/2, SI_BG_HEIGHT/2) radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    return bezierPath;
}

@end
