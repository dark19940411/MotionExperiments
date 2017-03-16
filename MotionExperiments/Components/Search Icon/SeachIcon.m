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
    CALayer *_circleLayer;          //搜索的圆圈的layer
    CALayer *_handleLayer;          //放大镜的柄layer
}

#pragma mark -
#pragma mark Inheritance
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _searching = NO;
    }
    return self;
}



@end
