//
//  MotionExperimentsUITests.m
//  MotionExperimentsUITests
//
//  Created by turtle on 2017/1/30.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Graph.h"

@interface MotionExperimentsUITests : XCTestCase{
    Graph *_graph;
}

@end

@implementation MotionExperimentsUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    _graph = [[Graph alloc] init];
    _graph.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, GRAPH_BG_HEIGHT);
    [_graph setPointData:@[@0.27,@0.49,@0.25,@0.4,@0,@0.47,@0.6,@1,@0.59,@0.05]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [_graph startAnimation];
    
}

@end
