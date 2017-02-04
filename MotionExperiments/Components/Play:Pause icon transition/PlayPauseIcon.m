//
//  PlayPauseIcon.m
//  MotionExperiments
//
//  Created by turtle on 2017/1/31.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "PlayPauseIcon.h"

//This component is seperated into three part. The edge length of each is 90pt

static const CGFloat kRadiusOfPauseIconCorner = 3.0;
static const CGFloat kMaxWidthOfPauseVerticalLine = 0.4 * EACH_COMPONENT_WIDTH;
static const CGFloat kCapBetweenTwoPauseVerticalLines = 0.2 * EACH_COMPONENT_WIDTH;


@interface PlayPauseIcon (){
    CAShapeLayer *_pauseIconBackLayer;
    CAShapeLayer *_playIconBackLayer;
    BOOL _isPlaying;
    CGFloat _widthOfTriangle;
}

@end

@implementation PlayPauseIcon

#pragma mark - 
#pragma mark UIKit Inheritance
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isPlaying = NO;
        _widthOfTriangle = sqrtf(3.0)/2 * EACH_COMPONENT_WIDTH;
        _pauseIconBackLayer = [CAShapeLayer layer];
        _pauseIconBackLayer.lineCap = kCALineCapRound;
        _pauseIconBackLayer.lineJoin = kCALineJoinRound;
        _pauseIconBackLayer.lineWidth = 2;
        _pauseIconBackLayer.fillColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:180.0/255.0 alpha:1].CGColor;
        _pauseIconBackLayer.strokeColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:180.0/255.0 alpha:1].CGColor;
        _playIconBackLayer = [CAShapeLayer layer];
        _playIconBackLayer.lineCap = kCALineCapRound;
        _playIconBackLayer.lineJoin = kCALineJoinRound;
        _playIconBackLayer.lineWidth = 2;
        _playIconBackLayer.fillColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:180.0/255.0 alpha:1].CGColor;
        _playIconBackLayer.strokeColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:180.0/255.0 alpha:1].CGColor;
        _playIconBackLayer.path = [self initializesPath].CGPath;
        [self.layer addSublayer:_pauseIconBackLayer];
        [self.layer addSublayer:_playIconBackLayer];
    }
    return self;
}

#pragma mark -
#pragma mark AnimationProcessorDelegate
- (void)updateLayerWithAnimationPercentage:(CGFloat)percentage {
    if (_isPlaying) {
        [self startPauseAnimationWithPercentage:percentage];
    }
    else {
        [self startPlayAnimationWithPercentage:percentage];
    }
}

#pragma mark -
#pragma mark private
- (UIBezierPath *)initializesPath {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGFloat widthOfTriangle = _widthOfTriangle;
    [bezierPath moveToPoint:CGPointMake((EACH_COMPONENT_WIDTH - widthOfTriangle)/2 + EACH_COMPONENT_WIDTH + COMPONENT_CAP, 0)];
    [bezierPath addLineToPoint:CGPointMake((EACH_COMPONENT_WIDTH - widthOfTriangle)/2 + EACH_COMPONENT_WIDTH + COMPONENT_CAP, EACH_COMPONENT_HEIGHT)];
    [bezierPath addLineToPoint:CGPointMake((EACH_COMPONENT_WIDTH - widthOfTriangle)/2 + EACH_COMPONENT_WIDTH + COMPONENT_CAP + widthOfTriangle, EACH_COMPONENT_HEIGHT/2)];
    [bezierPath closePath];
    return bezierPath;
}

- (void)startPlayAnimationWithPercentage:(CGFloat)percentage {
    CGFloat pauseIconStartX = percentage * (EACH_COMPONENT_WIDTH + COMPONENT_CAP);
    CGFloat playIconStartX = pauseIconStartX + EACH_COMPONENT_WIDTH + COMPONENT_CAP;
    CGFloat realWidthOfPauseVerticalLine = percentage * kMaxWidthOfPauseVerticalLine;
    CGFloat eachDistanceFromTopAndBottom = percentage * EACH_COMPONENT_HEIGHT / 2;
    [self updatePauseIconWithPauseIconStartX:pauseIconStartX realWidthOfPauseVerticalLine:realWidthOfPauseVerticalLine percentage:percentage];
    _pauseIconBackLayer.opacity = percentage;
    [self updatePlayIconWithPlayIconStartX:playIconStartX eachDistanceFromTopAndBottom:eachDistanceFromTopAndBottom  percentage:percentage];
    _playIconBackLayer.opacity = 1 - percentage;
    if (percentage == 1) {
        [self.animationProcessor stopAnimating];
        [_delegate enableTapGestureRecognizer];
        _isPlaying = YES;
    }
}

- (void)startPauseAnimationWithPercentage:(CGFloat)percentage {
    CGFloat pauseIconStartX = (1 - percentage) * (EACH_COMPONENT_WIDTH + COMPONENT_CAP);
    CGFloat playIconStartX = pauseIconStartX + EACH_COMPONENT_WIDTH +COMPONENT_CAP;
    CGFloat realWidthOfPauseVerticalLine = (1 - percentage) * kMaxWidthOfPauseVerticalLine;
    CGFloat eachDistanceFromTopAndBottom = (1 - percentage) * EACH_COMPONENT_HEIGHT / 2;
    [self updatePauseIconWithPauseIconStartX:pauseIconStartX realWidthOfPauseVerticalLine:realWidthOfPauseVerticalLine percentage:percentage];
    _pauseIconBackLayer.opacity = 1 - percentage;
    [self updatePlayIconWithPlayIconStartX:playIconStartX eachDistanceFromTopAndBottom:eachDistanceFromTopAndBottom percentage:percentage];
    _playIconBackLayer.opacity = percentage;
    if (percentage == 1) {
        [self.animationProcessor stopAnimating];
        [_delegate enableTapGestureRecognizer];
        _isPlaying = NO;
    }
}

- (void)updatePauseIconWithPauseIconStartX:(CGFloat)pauseIconStartX
              realWidthOfPauseVerticalLine:(CGFloat)realWidthOfPauseVerticalLine
                                percentage:(CGFloat)percentage{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (realWidthOfPauseVerticalLine <= kRadiusOfPauseIconCorner) {
        [bezierPath moveToPoint:CGPointMake(pauseIconStartX, realWidthOfPauseVerticalLine/2)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine/2, realWidthOfPauseVerticalLine/2) radius:realWidthOfPauseVerticalLine/2 startAngle:M_PI endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine, EACH_COMPONENT_HEIGHT - realWidthOfPauseVerticalLine/2)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine/2, EACH_COMPONENT_HEIGHT - realWidthOfPauseVerticalLine/2) radius:realWidthOfPauseVerticalLine/2 startAngle:0 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX, realWidthOfPauseVerticalLine/2)];
        [bezierPath moveToPoint:CGPointMake(pauseIconStartX + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, realWidthOfPauseVerticalLine/2)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine/2 + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, realWidthOfPauseVerticalLine/2) radius:realWidthOfPauseVerticalLine/2 startAngle:M_PI endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, EACH_COMPONENT_HEIGHT - realWidthOfPauseVerticalLine/2)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine/2 + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, EACH_COMPONENT_HEIGHT - realWidthOfPauseVerticalLine/2) radius:realWidthOfPauseVerticalLine/2 startAngle:0 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, realWidthOfPauseVerticalLine/2)];
    }
    else {
        [bezierPath moveToPoint:CGPointMake(pauseIconStartX, kRadiusOfPauseIconCorner)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + kRadiusOfPauseIconCorner, kRadiusOfPauseIconCorner) radius:kRadiusOfPauseIconCorner startAngle:M_PI endAngle:3 * M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine - kRadiusOfPauseIconCorner, 0)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine - kRadiusOfPauseIconCorner, kRadiusOfPauseIconCorner) radius:kRadiusOfPauseIconCorner startAngle:3 * M_PI_2 endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine, EACH_COMPONENT_HEIGHT - kRadiusOfPauseIconCorner)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine - kRadiusOfPauseIconCorner, EACH_COMPONENT_HEIGHT - kRadiusOfPauseIconCorner) radius:kRadiusOfPauseIconCorner startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX + kRadiusOfPauseIconCorner, EACH_COMPONENT_HEIGHT)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + kRadiusOfPauseIconCorner, EACH_COMPONENT_HEIGHT - kRadiusOfPauseIconCorner) radius:kRadiusOfPauseIconCorner startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX, kRadiusOfPauseIconCorner)];
        
        [bezierPath moveToPoint:CGPointMake(pauseIconStartX + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, kRadiusOfPauseIconCorner)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + kRadiusOfPauseIconCorner + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, kRadiusOfPauseIconCorner) radius:kRadiusOfPauseIconCorner startAngle:M_PI endAngle:3 * M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine - kRadiusOfPauseIconCorner + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, 0)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine - kRadiusOfPauseIconCorner + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, kRadiusOfPauseIconCorner) radius:kRadiusOfPauseIconCorner startAngle:3 * M_PI_2 endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, EACH_COMPONENT_HEIGHT - kRadiusOfPauseIconCorner)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + realWidthOfPauseVerticalLine - kRadiusOfPauseIconCorner + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, EACH_COMPONENT_HEIGHT - kRadiusOfPauseIconCorner) radius:kRadiusOfPauseIconCorner startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX + kRadiusOfPauseIconCorner + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, EACH_COMPONENT_HEIGHT)];
        [bezierPath addArcWithCenter:CGPointMake(pauseIconStartX + kRadiusOfPauseIconCorner + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, EACH_COMPONENT_HEIGHT - kRadiusOfPauseIconCorner) radius:kRadiusOfPauseIconCorner startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(pauseIconStartX + kMaxWidthOfPauseVerticalLine + kCapBetweenTwoPauseVerticalLines, kRadiusOfPauseIconCorner)];
    }
    _pauseIconBackLayer.path = bezierPath.CGPath;
}

- (void)updatePlayIconWithPlayIconStartX:(CGFloat)playIconStartX
             eachDistanceFromTopAndBottom:(CGFloat)eachDistanceFromTopAndBottom
                               percentage:(CGFloat)percentage
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGFloat widthOfTriangle = _widthOfTriangle;
    [bezierPath moveToPoint:CGPointMake(playIconStartX + (EACH_COMPONENT_WIDTH - widthOfTriangle)/2, eachDistanceFromTopAndBottom)];
    [bezierPath addLineToPoint:CGPointMake(playIconStartX + (EACH_COMPONENT_WIDTH - widthOfTriangle)/2 + widthOfTriangle, EACH_COMPONENT_HEIGHT/2)];
    [bezierPath addLineToPoint:CGPointMake(playIconStartX + (EACH_COMPONENT_WIDTH - widthOfTriangle)/2, EACH_COMPONENT_HEIGHT - eachDistanceFromTopAndBottom)];
    _playIconBackLayer.path = bezierPath.CGPath;
}

@end
