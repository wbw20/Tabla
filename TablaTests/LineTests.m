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

/**
 *
 *  Slope()
 *
 **/

- (void)testZero
{
    CGPoint start = CGPointMake(0.0f, 0.0f);
    CGPoint end = CGPointMake(0.0f, 0.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    
    XCTAssert([line slope] == 0.0f, @"Slope failed for zero slope.");
}

- (void)testOriginToQuadrantOne
{
    CGPoint start = CGPointMake(0.0f, 0.0f);
    CGPoint end = CGPointMake(10.0f, 10.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    
    XCTAssert([line slope] == 1.0f, @"Slope failed for first quadrant.");
}

- (void)testQuadrantOneToQuadrantOne
{
    CGPoint start = CGPointMake(5.0f, 0.0f);
    CGPoint end = CGPointMake(10.0f, 10.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    
    XCTAssert([line slope] == 2.0f, @"Slope failed for first quadrant.");
}

- (void)testNegativeSlope
{
    CGPoint start = CGPointMake(5.0f, 0.0f);
    CGPoint end = CGPointMake(-5.0f, 10.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    
    XCTAssert([line slope] == -1.0f, @"Slope failed for negative slope.");
}

@end
