//
//  SpinnerPresentationViewController.m
//  MotionExperiments
//
//  Created by turtle on 2017/1/30.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "SpinnerPresentationViewController.h"
#import "Spinner.h"

#define SPINNER_EDGE_LENGTH 80.0

@interface SpinnerPresentationViewController (){
    Spinner *_spinner;
    AnimationProcessor *_animationProcessor;
}
@end

@implementation SpinnerPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    _spinner = [[Spinner alloc] initWithFrame:CGRectMake((screenBounds.size.width - SPINNER_EDGE_LENGTH)/2, (screenBounds.size.height - SPINNER_EDGE_LENGTH)/2, SPINNER_EDGE_LENGTH, SPINNER_EDGE_LENGTH)];
    _animationProcessor = [[AnimationProcessor alloc] init];
    _spinner.animationProcessor = _animationProcessor;
    _animationProcessor.delegate = _spinner;
    [_animationProcessor setVelocity:0.007];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_spinner];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_animationProcessor startAnimating];
}

@end
