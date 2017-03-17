//
//  SearchIconViewController.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/15.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "SearchIconViewController.h"
#import "SeachIcon.h"

@interface SearchIconViewController (){
    SeachIcon *_searchIcon;
}

@end

@implementation SearchIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    _searchIcon = [[SeachIcon alloc] initWithFrame:CGRectMake((scrSize.width - SI_BG_WIDTH)/2, (scrSize.height - SI_BG_HEIGHT)/2, SI_BG_WIDTH, SI_BG_HEIGHT)];
    [self.view addSubview:_searchIcon];
}

@end
