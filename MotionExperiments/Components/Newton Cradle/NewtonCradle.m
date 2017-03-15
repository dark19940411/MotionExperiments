//
//  NewtonCradle.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/14.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "NewtonCradle.h"

#define SCALE_ARG 0.8
#define MAX_RADIUS 8.0
#define VIBE (2 * MAX_RADIUS)
#define DURATION_ONE_DRIBBLE 1

@interface CAAnimationGroup (NewtonCradleExtends)

+ (CAAnimationGroup *)groupWithAnimations:(NSArray<CAKeyframeAnimation *> *)anims andDuration:(CFTimeInterval)duration;

@end

@implementation CAAnimationGroup (NewtonCradleExtends)

+ (CAAnimationGroup *)groupWithAnimations:(NSArray<CAKeyframeAnimation *> *)anims andDuration:(CFTimeInterval)duration {
    CAAnimationGroup *group = [CAAnimationGroup new];
    group.animations = anims;
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    return group;
}

@end

@interface NewtonCradle ()<CAAnimationDelegate>

@end

@implementation NewtonCradle {
    NSMutableArray<CAShapeLayer *> *_cradles;
    CAAnimationGroup *_firstAnimation;
    CAAnimationGroup *_lcAnimation;
    CAAnimationGroup *_rcAnimation;
}

#pragma mark -
#pragma mark Inheritance
- (instancetype)init {
    self = [super init];
    if (self) {
        [self __setupCradles];
    }
    return self;
}

- (void)setOpacity:(float)opacity {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [super setOpacity:opacity];
    [CATransaction commit];
}

#pragma mark -
#pragma mark AnimationDelegate
- (void)startAnimation {
    [self __setupRightCradleFirstAnimation];
    
}

#pragma mark -
#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self __setupLoopAnimation];
}

#pragma mark -
#pragma mark privates
- (void)__setupCradles {
    _cradles = [NSMutableArray array];
    CAShapeLayer *leftCradle = [CAShapeLayer layer];
    CAShapeLayer *centerCradle = [CAShapeLayer layer];
    CAShapeLayer *rightCradle = [CAShapeLayer layer];
    CGFloat x, y;
    x = (NEWTON_CRADLE_BG_WIDTH - MAX_RADIUS)/2;
    y = (NEWTON_CRADLE_BG_HEIGHT - MAX_RADIUS)/2;
    centerCradle.frame = CGRectMake(x, y, 2 * MAX_RADIUS, 2 * MAX_RADIUS);
    leftCradle.frame = CGRectMake(x - 2 * MAX_RADIUS, y, 2 * MAX_RADIUS, 2 * MAX_RADIUS);
    rightCradle.frame = CGRectMake(x + 2 * MAX_RADIUS + VIBE, y, 2 * MAX_RADIUS, 2 * MAX_RADIUS);
    
    CGColorRef blackColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){3/255.0,3/255.0,3/255.0,1});
    leftCradle.fillColor = centerCradle.fillColor = rightCradle.fillColor = blackColor;
    CGColorRelease(blackColor);
    
    leftCradle.lineCap = centerCradle.lineCap = rightCradle.lineCap = kCALineCapRound;
    leftCradle.lineJoin = centerCradle.lineJoin = rightCradle.lineJoin = kCALineJoinRound;
    leftCradle.lineWidth = centerCradle.lineWidth = rightCradle.lineWidth = 0.1f;
    
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:CGPointMake(MAX_RADIUS, MAX_RADIUS) radius:MAX_RADIUS startAngle:0 endAngle:2 * M_PI clockwise:YES];
    centerCradle.path = leftCradle.path = rightCradle.path = circlePath.CGPath;
    
    rightCradle.transform = CATransform3DMakeScale(SCALE_ARG, SCALE_ARG, 1.0);
    [self addSublayer:leftCradle];
    [self addSublayer:centerCradle];
    [self addSublayer:rightCradle];
    [_cradles addObject:leftCradle];
    [_cradles addObject:centerCradle];
    [_cradles addObject:rightCradle];
}

- (void)__setupLoopAnimation {
    [self __setupLeftCradleAnimation];
    [self __setupRightCradleAnimation];
    [self __setupRotationAnimation];
}

- (void)__setupLeftCradleAnimation {
    CAShapeLayer *leftCradle = _cradles[0];
    CGFloat oldPointX = leftCradle.position.x;
    CGFloat newPointX = oldPointX - VIBE;
    NSArray *xValues = [NSArray arrayWithObjects:
                       [NSNumber numberWithFloat:oldPointX],
                       [NSNumber numberWithFloat:newPointX],
                       [NSNumber numberWithFloat:oldPointX], nil];
    CAKeyframeAnimation *xAnim = [self __buildPositionXAnimationWithValues:xValues];
    
    CATransform3D oldTransf = CATransform3DIdentity;
    CATransform3D newTransf = CATransform3DMakeScale(SCALE_ARG, SCALE_ARG, 1.0);
    NSArray *tValues = [NSArray arrayWithObjects:
                        [NSValue valueWithCATransform3D:oldTransf],
                        [NSValue valueWithCATransform3D:newTransf],
                        [NSValue valueWithCATransform3D:oldTransf], nil];
    CAKeyframeAnimation *tAnim = [self __buildTransformAnimationWithValues:tValues];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup groupWithAnimations:[NSArray arrayWithObjects:xAnim, tAnim, nil]
                                                            andDuration:DURATION_ONE_DRIBBLE * 2];
    animGroup.repeatCount = HUGE_VAL;
    
    [leftCradle addAnimation:animGroup forKey:@"LCAnimation"];
    
}

- (void)__setupRightCradleFirstAnimation {
    CGFloat movedX = _cradles[2].position.x - VIBE;//之所以要+个MAX_RADIUS，是因为animation的anchorPoint在layer的中心，下同
    
    CAKeyframeAnimation *xAnim = [self __buildPositionXAnimationWithValues:
                                  [NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:_cradles[2].position.x],
                                   [NSNumber numberWithFloat:movedX], nil]];
    
    CAKeyframeAnimation *scaleAnim = [self __buildTransformAnimationWithValues:
                                      [NSArray arrayWithObjects:
                                       [NSValue valueWithCATransform3D:_cradles[2].transform],
                                       [NSValue valueWithCATransform3D:CATransform3DIdentity], nil]];
    
    xAnim.duration = DURATION_ONE_DRIBBLE/2;
    scaleAnim.duration = DURATION_ONE_DRIBBLE/2;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup groupWithAnimations:[NSArray arrayWithObjects:xAnim, scaleAnim, nil]
                                                            andDuration:DURATION_ONE_DRIBBLE/2];
    animGroup.delegate = self;
    
    [_cradles[2] addAnimation:animGroup forKey:@"RCFirstAnimation"];
    _firstAnimation = animGroup;
}

- (void)__setupRightCradleAnimation {
    CAShapeLayer *rightCradle = _cradles[2];
    CGFloat oldPointX = rightCradle.position.x - VIBE;
    CGFloat newPointX = rightCradle.position.x;
    NSArray *xValues = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:oldPointX],
                        [NSNumber numberWithFloat:newPointX],
                        [NSNumber numberWithFloat:oldPointX], nil];
    CAKeyframeAnimation *xAnim = [self __buildPositionXAnimationWithValues:xValues];
    
    CATransform3D oldTransf = CATransform3DIdentity;
    CATransform3D newTransf = CATransform3DMakeScale(SCALE_ARG, SCALE_ARG, 1.0);
    NSArray *tValues = [NSArray arrayWithObjects:
                        [NSValue valueWithCATransform3D:oldTransf],
                        [NSValue valueWithCATransform3D:newTransf],
                        [NSValue valueWithCATransform3D:oldTransf], nil];
    CAKeyframeAnimation *tAnim = [self __buildTransformAnimationWithValues:tValues];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup groupWithAnimations:[NSArray arrayWithObjects:xAnim, tAnim, nil]
                                                            andDuration:DURATION_ONE_DRIBBLE * 2];
    animGroup.repeatCount = HUGE_VAL;
    animGroup.beginTime = CACurrentMediaTime()+DURATION_ONE_DRIBBLE;
    
    [rightCradle addAnimation:animGroup forKey:@"RCAnimation"];
}

- (void)__setupRotationAnimation {
    CGPoint centerPosition = _cradles[1].position;
    CGPoint anchorPoint = CGPointMake(centerPosition.x/self.frame.size.width, centerPosition.y/self.frame.size.height);
    self.anchorPoint = anchorPoint;
    
    CGFloat oldAngle = 0;
    CGFloat newAngle = 2 * M_PI;
    NSArray *tValues = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:oldAngle],
                        [NSNumber numberWithFloat:newAngle],
                        [NSNumber numberWithFloat:oldAngle], nil];

    CAKeyframeAnimation *tAnim = [self __spinAnimationWithduration:8 * DURATION_ONE_DRIBBLE values:tValues repeat:HUGE_VAL];
    
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.5 :0.7 :1];
    NSArray *timingFunctions = [NSArray arrayWithObjects:timingFunction, timingFunction, nil];
    tAnim.timingFunctions = timingFunctions;
    
    [self addAnimation:tAnim forKey:@"RotationAnimation"];
}

#pragma mark -
#pragma mark helpers
- (CAKeyframeAnimation *)__buildPositionXAnimationWithValues:(NSArray *)values {
    CAKeyframeAnimation *xAnim = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    xAnim.values = values;
    xAnim.fillMode = kCAFillModeForwards;
    xAnim.removedOnCompletion = NO;
    xAnim.duration = DURATION_ONE_DRIBBLE;
    return xAnim;
}

- (CAKeyframeAnimation *)__buildTransformAnimationWithValues:(NSArray *)values {
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnim.values = values;
    scaleAnim.fillMode = kCAFillModeForwards;
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.duration = DURATION_ONE_DRIBBLE;
    return scaleAnim;
}

- (CAKeyframeAnimation *)__spinAnimationWithduration:(CGFloat)duration values:(NSArray *)values repeat:(float)repeat
{
    CAKeyframeAnimation* rotationAnimation;
    rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = values;
    rotationAnimation.duration = duration;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = repeat;
    
    return rotationAnimation;
}

@end
