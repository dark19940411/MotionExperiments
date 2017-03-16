//
//  GraphViewController.m
//  MotionExperiments
//
//  Created by turtle on 2017/3/16.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "GraphViewController.h"
#import "Graph.h"

@interface GraphViewController (){
    Graph *_graph;
}

@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _graph = [Graph layer];
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    _graph.frame = CGRectMake(0, (scrSize.height - GRAPH_BG_HEIGHT)/2, scrSize.width, GRAPH_BG_HEIGHT);
    [_graph setPointData:@[@0.27,@0.49,@0.25,@0.4,@0,@0.47,@0.6,@1,@0.59,@0.05]];
    [self.view.layer addSublayer:_graph];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_graph startAnimation];
}

@end
