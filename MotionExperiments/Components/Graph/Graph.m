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
    NSArray *_rawPointData;    //用来装每个点的y值的数组，值在[0,1]区间内取
    NSArray *_processedPointData; //经过处理的点数据，可以被用于动画
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
}

#pragma mark -
#pragma mark Private
- (void)__calculatePointDataToDraw {
    
}

#pragma mark -
#pragma mark AnimationDelegate
- (void)startAnimation {
    
}

@end
