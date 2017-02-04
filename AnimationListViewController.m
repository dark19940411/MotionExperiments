//
//  AnimationListViewController.m
//  MotionExperiments
//
//  Created by turtle on 2017/1/30.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "AnimationListViewController.h"
#import "SpinnerPresentationViewController.h"
#import "PlayPauseIconPresentationViewController.h"

NSArray<NSString *> *kAnimationsList = nil;
NSArray *kAnmationsClasses = nil;

@interface AnimationListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *animationsTableview;

@end

@implementation AnimationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _animationsTableview.dataSource = self;
    _animationsTableview.delegate = self;
    
    kAnimationsList = @[@"Spinner",@"Play/Pause Icon Transition"];
    kAnmationsClasses = @[[SpinnerPresentationViewController class], [PlayPauseIconPresentationViewController class]];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kAnimationsList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = kAnimationsList[indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class specificClass = kAnmationsClasses[indexPath.row];
    UIViewController *presentingViewController = [[specificClass alloc] init];
    [self.navigationController pushViewController:presentingViewController animated:YES];
}

@end
