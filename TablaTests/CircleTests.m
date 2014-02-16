//
//  CircleTests.m
//  Tabla
//
//  Created by William Wettersten on 2/16/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "CircleTests.h"
#import "Circle.h"

@implementation CircleTests

/**
 *
 *  - (CGPoint) pointOnCircleFor:(float)radians;
 *
 **/

- (void)testPointOnCircleAtZeroRadians {
    Circle *circle = [[Circle alloc] initWithCenter:CGPointMake(50.0f, 50.0f) andRadius:10.0f];
    CGPoint correct = CGPointMake(60.0f, 50.0f);
    
    XCTAssert(CGPointEqualToPoint([circle pointOnCircleFor:0.0f], correct), @"Point on circle failed for radian 0.");
}

@end
