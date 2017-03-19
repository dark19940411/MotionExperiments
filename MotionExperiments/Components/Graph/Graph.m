//
//  Graph.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/16.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "Graph.h"
#import "AnimatableDonutsLayer.h"
#import "Extensions.h"

#define GRAPH_HEIGHT (GRAPH_BG_HEIGHT/2.0)
#define CONTENT_OFFSET 20.0
#define EXC_RADIUS 4.0
#define INT_RADIUS 2.0
#define RADIUS_OFFSET 2.0
#define SEG_DURATION 1.0/8.0
#define LINE_HEIGHT 1.0

@implementation Graph {
    NSArray<NSNumber *> *_rawPointData;    //用来装每个点的y值的数组，值在[0,1]区间内取
    NSArray<NSValue *> *_processedPointData; //经过处理的点数据，可以被用于动画
    NSArray<NSNumber *> *_segmentLengths;    //点与点之间的距离
    NSArray<NSNumber *> *_strokeEnds;        //每个点对应的strokEnd，之所以需要这个是因为动画需要一段段的去生成，每次触发AnimatableDonutsLayer的动画
    NSArray<CALayer *> *_lineLayers;         //三条线的存储
    CAShapeLayer *_curveBackLayer;
    CGFloat _totalCurveLength;
    NSInteger _endPointIndex;                //当前动画所处的点对应的index
}

#pragma mark -
#pragma mark Inheritance
- (instancetype)init {
    self = [super init];
    if (self) {
        self.masksToBounds = YES;
        [self __setupGreyLines];
    }
    return self;
}

#pragma mark -
#pragma mark Public
- (void)setPointData:(NSArray *)pointData {
    _rawPointData = pointData;
    _endPointIndex = 0;
    [self __calculatePointDataToDraw];
    [self __setupCurveBackLayer];
}

#pragma mark -
#pragma mark Setup
- (void)__setupGreyLines {
    CGFloat y1 = (GRAPH_BG_HEIGHT - GRAPH_HEIGHT)/2;
    CGFloat y2 = (GRAPH_BG_HEIGHT - GRAPH_HEIGHT)/2 + 0.5 * GRAPH_HEIGHT;
    CGFloat y3 = (GRAPH_BG_HEIGHT - GRAPH_HEIGHT)/2 + GRAPH_HEIGHT;
    
    CGFloat scrWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIColor *greyColor = RGBA(30, 30, 30, 1);
    
    CALayer *line1 = [CALayer layer];
    line1.frame = CGRectMake(scrWidth, y1, scrWidth, LINE_HEIGHT);
    line1.backgroundColor = greyColor.CGColor;
    
    CALayer *line2 = [CALayer layer];
    line2.frame = CGRectMake(scrWidth, y2, scrWidth, LINE_HEIGHT);
    line2.backgroundColor = greyColor.CGColor;
    
    CALayer *line3 = [CALayer layer];
    line3.frame = CGRectMake(scrWidth, y3, scrWidth, LINE_HEIGHT);
    line3.backgroundColor = greyColor.CGColor;
    
    NSMutableArray *lines = [NSMutableArray array];
    [lines addObject:line1];
    [lines addObject:line2];
    [lines addObject:line3];
    
    for (CALayer *line in lines) {
        [self addSublayer:line];
    }
    
    _lineLayers = [lines copy];
}

- (void)__setupCurveBackLayer {
    _curveBackLayer = [CAShapeLayer layer];
    
    _curveBackLayer.frame = self.bounds;
    _curveBackLayer.lineCap = kCALineCapSquare;
    _curveBackLayer.lineJoin = kCALineJoinRound;
    _curveBackLayer.lineWidth = 3.0;
    _curveBackLayer.strokeEnd = 0;
    _curveBackLayer.strokeColor = [UIColor blackColor].CGColor;
    
    _curveBackLayer.path = [self __createCurvePath].CGPath;
    
    [self addSublayer:_curveBackLayer];
}

#pragma mark -
#pragma mark Calculation
- (void)__calculatePointDataToDraw {
    CGSize size = self.bounds.size;
    CGFloat xGap = (size.width - 2 * CONTENT_OFFSET)/(_rawPointData.count - 1);
    
    NSMutableArray *processedPointData = [NSMutableArray array];
    [_rawPointData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = CONTENT_OFFSET + idx * xGap;
        CGFloat y = (GRAPH_BG_HEIGHT - GRAPH_HEIGHT)/2 + (1 - [obj floatValue]) * GRAPH_HEIGHT;
        CGPoint processedPoint = CGPointMake(x, y);
        [processedPointData addObject:[NSValue valueWithCGPoint:processedPoint]];
    }];
    
    _processedPointData = [processedPointData copy];
    [self __calculateCurveLength];
}

- (UIBezierPath *)__createCurvePath {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:[_processedPointData[0] CGPointValue]];
    for (int idx = 1; idx < _processedPointData.count; ++idx) {
        [bezierPath addLineToPoint:[_processedPointData[idx] CGPointValue]];
        [bezierPath moveToPoint:[_processedPointData[idx] CGPointValue]];
    }
    return bezierPath;
}

- (void)__calculateCurveLength {        //计算点与点之间的线段长度以及线段总长
    CGFloat totalLength = 0;
    NSMutableArray *segmentLengths = [NSMutableArray array];
    
    for (int idx = 1; idx < _processedPointData.count; ++idx) {
        CGPoint point1 = [_processedPointData[idx - 1] CGPointValue];
        CGPoint point2 = [_processedPointData[idx] CGPointValue];
        CGFloat tx = point2.x - point1.x;
        CGFloat ty = point2.y - point1.y;
    
        CGFloat len = sqrtf(tx * tx + ty * ty);
        totalLength += len;
        [segmentLengths addObject:[NSNumber numberWithFloat:len]];
    }
    _totalCurveLength = totalLength;
    _segmentLengths = [segmentLengths copy];
    [self __calculateStrokeEnds];
}

- (void)__calculateStrokeEnds {     //计算每个点所处的strokeEnd
    __block CGFloat pileLength = 0;
    NSMutableArray *strokeEnds = [NSMutableArray array];
    [_segmentLengths enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat len = [obj floatValue];
        pileLength += len;
        [strokeEnds addObject:[NSNumber numberWithFloat:pileLength/_totalCurveLength]];
    }];
    [strokeEnds insertObject:[NSNumber numberWithFloat:0] atIndex:0];
    _strokeEnds = [strokeEnds copy];
}

#pragma mark -
#pragma mark AnimationDelegate
- (void)startAnimation {
    if (_processedPointData == nil || _processedPointData.count == 0) {
        return;
    }
    [self __triggerTheNextSegAnimationInMiddle];
}

#pragma mark -
#pragma mark Animation Driver
- (void)__triggerTheNextSegAnimationInMiddle {
    CGPoint point = _processedPointData[_endPointIndex].CGPointValue;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeypath:@"strokeEnd" delegate:self fromValue:_strokeEnds[_endPointIndex] toValue:_strokeEnds[++_endPointIndex] duration:SEG_DURATION];
    
    [_curveBackLayer addAnimation:anim forKey:@"Curve_drawing_animation"];
    
    AnimatableDonutsLayer *donutsLayer = [AnimatableDonutsLayer layerWithCenterPoint:point ExcRadius:EXC_RADIUS inRadius:INT_RADIUS andRadiusOffset:RADIUS_OFFSET parentLayer:self];
    [donutsLayer startAnimation];
}

- (void)__trigerTheLastSegAnimation {
    CGPoint point = _processedPointData[_endPointIndex].CGPointValue;
    
    AnimatableDonutsLayer *donutsLayer = [AnimatableDonutsLayer layerWithCenterPoint:point ExcRadius:EXC_RADIUS inRadius:INT_RADIUS andRadiusOffset:RADIUS_OFFSET parentLayer:self];
    [donutsLayer startAnimation];
    
    _endPointIndex = 0;
    
//    [self removeAllAnimations];
//    [self __removeAllDonutsLayer];
//    
//    [self __triggerTheNextSegAnimationInMiddle];
    
}

- (void)__removeAllDonutsLayer {
    for (int idx = 0; idx < self.sublayers.count; idx++) {
        if ([self.sublayers[idx] isKindOfClass:[AnimatableDonutsLayer class]]) {
            [self.sublayers[idx] removeFromSuperlayer];
        }
    }
}

#pragma mark -
#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    
    if (_endPointIndex == _strokeEnds.count - 1) {
        [self __trigerTheLastSegAnimation];
    } else {
        [self __triggerTheNextSegAnimationInMiddle];
    }
}

@end
