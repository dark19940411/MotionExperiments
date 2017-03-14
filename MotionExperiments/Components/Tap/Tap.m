//
//  Tap.m
//  MotionExperiments
//
//  Created by turtle on 2017/2/4.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "Tap.h"

#define MINIMUM_LINE_WIDTH 0.2

#pragma mark -
#pragma mark CAShapeLayer Category
@interface CAShapeLayer (TapExtends)
- (void)makeCirclePathWithRadius:(CGFloat)radius;
- (void)makeTransparentCircleHoleWithRadius:(CGFloat)radius;
@end

@implementation CAShapeLayer (TapExtends)

- (void)makeCirclePathWithRadius:(CGFloat)radius {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGPoint circleCenterPoint = CGPointMake(TAP_MAX_RADIUS, TAP_MAX_RADIUS);
    [bezierPath addArcWithCenter:circleCenterPoint radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    self.path = bezierPath.CGPath;
}

- (void)makeTransparentCircleHoleWithRadius:(CGFloat)radius {
    static CGFloat originalRadius = TAP_MIN_RADIUS - (OUTSIDE_CIRCLE_LINE_WIDTH - MINIMUM_LINE_WIDTH)/2;
    CGPoint circleCenterPoint = CGPointMake(TAP_MAX_RADIUS, TAP_MAX_RADIUS);
    UIBezierPath *subBezierPath = [UIBezierPath bezierPath];
    [subBezierPath addArcWithCenter:circleCenterPoint radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:circleCenterPoint radius:originalRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [bezierPath appendPath:subBezierPath];
    self.path = bezierPath.CGPath;
}

@end

#pragma mark -
#pragma mark Tap Implementation Begin
@interface Tap (){
    CAShapeLayer *_internalLayer;
    CAShapeLayer *_mediumLayer;
    CAShapeLayer *_outsideLayer;
}

@end

@implementation Tap

#pragma mark -
#pragma mark Inheritance
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _internalLayer = [CAShapeLayer layer];
        _internalLayer.lineCap = kCALineCapRound;
        _internalLayer.lineJoin = kCALineJoinRound;
        _internalLayer.lineWidth = OUTSIDE_CIRCLE_LINE_WIDTH;
        _internalLayer.strokeColor = [UIColor whiteColor].CGColor;
        _internalLayer.fillColor = [UIColor whiteColor].CGColor;
        _internalLayer.fillRule = kCAFillRuleEvenOdd;
        _internalLayer.path = [self initializePath].CGPath;
        _mediumLayer = [CAShapeLayer layer];
        _mediumLayer.lineCap = kCALineCapRound;
        _mediumLayer.lineJoin = kCALineJoinRound;
        _mediumLayer.lineWidth = OUTSIDE_CIRCLE_LINE_WIDTH;
        _mediumLayer.strokeColor = [UIColor whiteColor].CGColor;
        _mediumLayer.fillColor = [UIColor clearColor].CGColor;
        _outsideLayer = [CAShapeLayer layer];
        _outsideLayer.lineCap = kCALineCapRound;
        _outsideLayer.lineJoin = kCALineJoinRound;
        _outsideLayer.lineWidth = OUTSIDE_CIRCLE_LINE_WIDTH;
        _outsideLayer.strokeColor = [UIColor whiteColor].CGColor;
        _outsideLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_internalLayer];
        [self.layer addSublayer:_mediumLayer];
        [self.layer addSublayer:_outsideLayer];
    }
    return self;
}

#pragma mark - 
#pragma mark AnimationProcessorDelegate
- (void)updateLayerWithAnimationPercentage:(CGFloat)percentage{
    static const CGFloat radiusOffset = (TAP_MAX_RADIUS - TAP_MIN_RADIUS) / 2;
    CGFloat realPercentage;
    if (percentage < 1.0/3.0){//大圆向内缩小
        realPercentage = percentage * 3;
        CGFloat shrinkRadius = TAP_MAX_RADIUS - (TAP_MAX_RADIUS - TAP_MIN_RADIUS)*(realPercentage);
        [_internalLayer makeCirclePathWithRadius:shrinkRadius];
    }
    else if(percentage < 2.0/3.0){//两个外圆形向外扩散
        CGFloat bigRadius;
        realPercentage = (percentage - 1.0/3.0) * 3;
        bigRadius = TAP_MIN_RADIUS + (TAP_MAX_RADIUS - TAP_MIN_RADIUS) * realPercentage;
        if (bigRadius > (TAP_MIN_RADIUS + radiusOffset)) {
            CGFloat smallRadius = bigRadius - radiusOffset;
            [_mediumLayer makeCirclePathWithRadius:smallRadius];
        }
        [_outsideLayer makeCirclePathWithRadius:bigRadius];
    }
    else {
        realPercentage = (percentage - 2.0/3.0) * 3;
        [self changeLayersOpacity:1 - realPercentage];
        CGFloat changedLineWidth = OUTSIDE_CIRCLE_LINE_WIDTH - realPercentage * (OUTSIDE_CIRCLE_LINE_WIDTH - MINIMUM_LINE_WIDTH);
        [self changeLayersLineWidth:changedLineWidth];
        [_internalLayer makeCirclePathWithRadius:TAP_MIN_RADIUS - changedLineWidth/2];
        [_mediumLayer makeCirclePathWithRadius:TAP_MAX_RADIUS - radiusOffset - changedLineWidth/2];
        [_outsideLayer makeCirclePathWithRadius:TAP_MAX_RADIUS - changedLineWidth/2];
        [_internalLayer makeTransparentCircleHoleWithRadius:(TAP_MIN_RADIUS - (OUTSIDE_CIRCLE_LINE_WIDTH - MINIMUM_LINE_WIDTH)/2) * realPercentage];
    }
    if (percentage == 1) {
        [self.animationProcessor stopAnimating];
        [self removeFromSuperview];
    }
}

#pragma mark -
#pragma mark Privates
- (UIBezierPath *)initializePath{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(TAP_MAX_RADIUS, TAP_MAX_RADIUS) radius:TAP_MAX_RADIUS startAngle:0 endAngle:2 * M_PI clockwise:YES];
    return bezierPath;
}

- (void)changeLayersOpacity:(CGFloat)opacity {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _internalLayer.opacity = opacity;
    _mediumLayer.opacity = opacity;
    _outsideLayer.opacity = opacity;
    [CATransaction commit];
}

- (void)changeLayersLineWidth:(CGFloat)linew {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _internalLayer.lineWidth = linew;
    _mediumLayer.lineWidth = linew;
    _outsideLayer.lineWidth = linew;
    [CATransaction commit];
}

@end
