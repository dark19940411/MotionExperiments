//
//  NewtonCradleViewController.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/14.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "NewtonCradleViewController.h"
#import "NewtonCradle.h"

@interface NewtonCradleViewController (){
    NewtonCradle *_cradleLayer;
}
@end

@implementation NewtonCradleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cradleLayer = [NewtonCradle layer];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _cradleLayer.frame = CGRectMake((screenSize.width - NEWTON_CRADLE_BG_WIDTH)/2, (screenSize.height - NEWTON_CRADLE_BG_HEIGHT)/2, NEWTON_CRADLE_BG_WIDTH, NEWTON_CRADLE_BG_HEIGHT);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view.layer addSublayer:_cradleLayer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_cradleLayer startAnimation];
}

@end
