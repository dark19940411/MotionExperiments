//
//  Spinner.m
//  Spinner
//
//  Created by turtle on 2017/1/24.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "Spinner.h"

#define ULTIMATE_LINE_WIDTH 5.f

@interface Spinner (){
    CAShapeLayer *_spinnerBackLayer;
    CGFloat _radius;
}
@end

@implementation Spinner

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _spinnerBackLayer = [CAShapeLayer layer];
        _spinnerBackLayer.lineCap = kCALineCapSquare;
        _spinnerBackLayer.lineJoin = kCALineJoinRound;
        _spinnerBackLayer.lineWidth = 0;
        _spinnerBackLayer.strokeColor = [UIColor blackColor].CGColor;
        _spinnerBackLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_spinnerBackLayer];
        _radius = frame.size.width/2 - 5.0f;
    }
    return self;
}

- (void)updateLayerWithAnimationPercentage:(CGFloat)percentage{
    CGFloat realPercentInCircle;
    CGFloat angle;
    CGRect frame = self.frame;
    CGPoint circleCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (percentage <= 1.0/3.0f) {       //第一圈
        realPercentInCircle = percentage/(1.0/3.0);
        angle = 2 * M_PI * realPercentInCircle;
        if (angle <= 2 * M_PI / 3) { //笔画粗细变化
            CGFloat percentForLineWidth = angle / (2 * M_PI / 3);
            CGFloat lineWidth = ULTIMATE_LINE_WIDTH * percentForLineWidth;
            _spinnerBackLayer.lineWidth = lineWidth;
        }else {
            _spinnerBackLayer.lineWidth = ULTIMATE_LINE_WIDTH;
        }
        [self addASpinCycleToPath:bezierPath currentAngle:angle realPercentInCircle:realPercentInCircle];
    } else if(percentage <= 2.0/3.0) {         //第二圈
        realPercentInCircle = (percentage - 1.0/3.0)/(1.0/3.0);
        angle = 2 * M_PI * realPercentInCircle;
        if (realPercentInCircle <= 1.0/24.0) {
            [bezierPath addArcWithCenter:circleCenter radius:_radius startAngle:3 * M_PI_2 + angle - M_PI/12 endAngle:3 * M_PI_2 + angle clockwise:YES];
        }
        else {
            [self addASpinCycleToPath:bezierPath currentAngle:angle realPercentInCircle:realPercentInCircle];
        }
    } else {            //第三圈
        realPercentInCircle = (percentage - 2.0/3.0)/(1.0/3.0);
        angle = 2 * M_PI * realPercentInCircle;
        if (angle >= 2 * M_PI / 3) {
            if (percentage + 0.007 > 1) {
                _spinnerBackLayer.lineWidth = 0;
                [_animationProcessor stopAnimating];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_animationProcessor startAnimating];
                });
            }
            else {
                CGFloat lineWidth = (1-((realPercentInCircle - (1.0/3.0))/(2.0/3.0))) * ULTIMATE_LINE_WIDTH;
                _spinnerBackLayer.lineWidth = lineWidth;
            }
        }
        if (realPercentInCircle <= 1.0/24.0) {
            [bezierPath addArcWithCenter:circleCenter radius:_radius startAngle:3 * M_PI_2 + angle - M_PI/12 endAngle:3 * M_PI_2 + angle clockwise:YES];
        }
        else {
            [self addASpinCycleToPath:bezierPath currentAngle:angle realPercentInCircle:realPercentInCircle];
        }
    }
    _spinnerBackLayer.path = bezierPath.CGPath;
}

//因为每圈里圆弧的旋转包括弧长伸缩那些都一样，所以写成一个方法
- (void)addASpinCycleToPath:(UIBezierPath *)bezierPath currentAngle:(CGFloat)angle realPercentInCircle:(CGFloat)realPercentInCircle{
    CGPoint circleCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    if (angle <= 4 * M_PI / 3) {
        [bezierPath addArcWithCenter:circleCenter radius:_radius startAngle:angle/2 + 3 * M_PI_2 endAngle:angle + 3 * M_PI_2 clockwise:YES];
    }else {
        CGFloat intersectionAngle = (1-((realPercentInCircle - (2.f/3.f))/(1.f/3.f))) * (2 * M_PI/3);
        if (intersectionAngle >= M_PI/12) {
            [bezierPath addArcWithCenter:circleCenter radius:_radius startAngle:3 * M_PI_2 + angle - intersectionAngle endAngle:3 * M_PI_2 + angle clockwise:YES];
        }
        else {
            [bezierPath addArcWithCenter:circleCenter radius:_radius startAngle:3 * M_PI_2 + angle - M_PI/12 endAngle:3 * M_PI_2 + angle clockwise:YES];
        }
    }
}

@end
