//
//  PlayPauseIconPresentationViewController.m
//  MotionExperiments
//
//  Created by turtle on 2017/1/31.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "PlayPauseIconPresentationViewController.h"
#import "PlayPauseIcon.h"

@interface PlayPauseIconPresentationViewController ()<UIGestureRecognizerDelegate, PlayPauseIconDelegate> {
    PlayPauseIcon *_playPauseIcon;
    AnimationProcessor *_animationProcessor;
    UITapGestureRecognizer *_tapGestureRecognizer;
}

@end

@implementation PlayPauseIconPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat iconWidth = 3 * EACH_COMPONENT_WIDTH + 2 * COMPONENT_CAP;
    _playPauseIcon = [[PlayPauseIcon alloc] initWithFrame:CGRectMake((screenBounds.size.width - iconWidth)/2, (screenBounds.size.height - EACH_COMPONENT_HEIGHT)/2, iconWidth, EACH_COMPONENT_HEIGHT)];
    _animationProcessor = [[AnimationProcessor alloc] init];
    [_animationProcessor setVelocity:ANIMATION_VELOCITY];
    _playPauseIcon.animationProcessor = _animationProcessor;
    _playPauseIcon.delegate = self;
    _animationProcessor.delegate = _playPauseIcon;
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(EACH_COMPONENT_WIDTH + COMPONENT_CAP, 0, EACH_COMPONENT_WIDTH, EACH_COMPONENT_HEIGHT)];
    tapView.backgroundColor = [UIColor clearColor];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToTriggerPlayPauseTransition:)];
    [tapView addGestureRecognizer:_tapGestureRecognizer];
    self.view.backgroundColor = [UIColor whiteColor];
    [_playPauseIcon addSubview:tapView];
    [self.view addSubview:_playPauseIcon];
}

- (void)tapToTriggerPlayPauseTransition:(id)sender {
    [_animationProcessor startAnimating];
    _tapGestureRecognizer.enabled = NO;
}

- (void)enableTapGestureRecognizer {
    _tapGestureRecognizer.enabled = YES;
}

@end
