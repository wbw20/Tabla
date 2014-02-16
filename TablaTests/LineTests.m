//
//  LineTests.m
//  Tabla
//
//  Created by William Wettersten on 2/16/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "LineTests.h"
#import "Line.h"

@implementation LineTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSlope
{
    CGPoint start = CGPointMake(0.0f, 0.0f);
    CGPoint end = CGPointMake(10.0f, 10.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    
    XCTAssert([line slope] == 1.0f, @"Slope test failed.");
}

@end
