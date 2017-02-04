//
//  TapPresentationViewController.m
//  MotionExperiments
//
//  Created by turtle on 2017/2/4.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "TapPresentationViewController.h"
#import "Tap.h"

@interface TapPresentationViewController ()<UIGestureRecognizerDelegate>{
    Tap *_tap;
    AnimationProcessor *_animationProcessor;
    UITapGestureRecognizer *_tapGestureRecognizer;
}

@end

@implementation TapPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
