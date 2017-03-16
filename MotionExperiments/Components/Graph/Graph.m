//
//  Graph.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/16.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "Graph.h"

#define GRAPH_HEIGHT (GRAPH_BG_HEIGHT/2.0)
#define CONTENT_OFFSET 20.0
#define EXC_RADIUS 5.0
#define INT_RADIUS 4.0
#define RADIUS_OFFSET 2.0

@implementation Graph {
    NSArray<NSNumber *> *_rawPointData;    //用来装每个点的y值的数组，值在[0,1]区间内取
    NSArray<NSValue *> *_processedPointData; //经过处理的点数据，可以被用于动画
    NSArray<NSNumber *> *_segmentLengths;    //点与点之间的距离
    CAShapeLayer *_curveBackLayer;
    CGFloat _totalCurveLength;
}

#pragma mark -
#pragma mark Inheritance
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark Public
- (void)setPointData:(NSArray *)pointData {
    _rawPointData = pointData;
    [self __calculatePointDataToDraw];
    [self __setupCurveBackLayer];
}

#pragma mark -
#pragma mark Private
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
}

#pragma mark -
#pragma mark AnimationDelegate
- (void)startAnimation {
    
}

@end
