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

- (void)testPointOnCircleAtPiOver2Radians {
    Circle *circle = [[Circle alloc] initWithCenter:CGPointMake(50.0f, 50.0f) andRadius:10.0f];
    CGPoint correct = CGPointMake(50.0f, 60.0f);
    
    NSLog(@"%f", [circle pointOnCircleFor:M_PI/2].x);
        NSLog(@"%f", [circle pointOnCircleFor:M_PI/2].y);
    
    NSLog(@"%f", correct.x);
    NSLog(@"%f", correct.y);
    
    XCTAssert(CGPointEqualToPoint([circle pointOnCircleFor:M_PI/2], correct), @"Point on circle failed for radian pi/2.");
}

@end
