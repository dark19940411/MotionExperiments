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
    self.view.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:37.0/255.0 blue:41.0/255.0 alpha:1.0];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    
}

- (void)tapHandler:(id)sender {
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)sender;
    CGPoint tapLocation = [recognizer locationInView:self.view];
    _tap = [[Tap alloc] initWithFrame:CGRectMake(tapLocation.x - TAP_MAX_RADIUS - OUTSIDE_CIRCLE_LINE_WIDTH/2, tapLocation.y - TAP_MAX_RADIUS - OUTSIDE_CIRCLE_LINE_WIDTH/2, TAP_MAX_RADIUS*2 + OUTSIDE_CIRCLE_LINE_WIDTH/2, TAP_MAX_RADIUS*2 + OUTSIDE_CIRCLE_LINE_WIDTH/2)];
    _animationProcessor = [[AnimationProcessor alloc] init];
    [_animationProcessor setVelocity:ANIMATION_VELOCITY];
    _tap.animationProcessor = _animationProcessor;
    _animationProcessor.delegate = _tap;
    [_animationProcessor startAnimating];
    [self.view addSubview:_tap];
}

@end
