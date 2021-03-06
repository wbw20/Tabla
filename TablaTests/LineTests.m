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
 *  + (float)getTranslationLineFor:(Line*)line andKerf:(float)kerf
 *
 **/

- (void)testNoKerf
{
    CGPoint start = CGPointMake(0.0f, 0.0f);
    CGPoint end = CGPointMake(10.0f, 0.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    
    XCTAssert([Line getTranslationFor:line andKerf:0.0f] == 0.0f, @"Kerf translation failed for no kerf.");
}

- (void)testKerfWithFlatLine
{
    CGPoint start = CGPointMake(0.0f, 0.0f);
    CGPoint end = CGPointMake(10.0f, 0.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    
    XCTAssert([Line getTranslationFor:line andKerf:1.0f] == 1.0f, @"Kerf translation failed for a flat line.");
}

- (void)testKerfWithDiagonalLine
{
    CGPoint start = CGPointMake(0.0f, 0.0f);
    CGPoint end = CGPointMake(10.0f, 10.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    
    XCTAssert([Line getTranslationFor:line andKerf:1.0f] > 1.41421f, @"Kerf translation failed for a diagonal line.");
    XCTAssert([Line getTranslationFor:line andKerf:1.0f] < 1.41422f, @"Kerf translation failed for a diagonal line.");
}

/**
 *
 *  + (Line*)getTranslatedLineFor:(Line*)line andTranslation:(float)translation
 *
 **/

- (void)testLineTranslationWithZero
{
    CGPoint start = CGPointMake(0.0f, 0.0f);
    CGPoint end = CGPointMake(10.0f, 10.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    Line *translated = [Line getTranslatedLineFor:(line) andTranslation:(0.0f)];
    
    XCTAssert([translated offset] == 0.0f, @"Line translation failed for zero translation.");
}

- (void)testLineTranslationFromOrigin
{
    CGPoint start = CGPointMake(0.0f, 0.0f);
    CGPoint end = CGPointMake(10.0f, 10.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    Line *translated = [Line getTranslatedLineFor:(line) andTranslation:(4.0f)];
    
    XCTAssert([translated offset] == 4.0f, @"Line translation failed for positive translation from origin.");
}

- (void)testLineTranslationFromPositive
{
    CGPoint start = CGPointMake(0.0f, 5.0f);
    CGPoint end = CGPointMake(10.0f, 10.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    Line *translated = [Line getTranslatedLineFor:(line) andTranslation:(4.0f)];
    
    XCTAssert([translated offset] == 9.0f, @"Line translation failed for positive translation from positive offset.");
}

- (void)testNegativeLineTranslationFromPositive
{
    CGPoint start = CGPointMake(0.0f, 5.0f);
    CGPoint end = CGPointMake(10.0f, 10.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    Line *translated = [Line getTranslatedLineFor:(line) andTranslation:(-4.0f)];
    
    XCTAssert([translated offset] == 1.0f, @"Line translation failed for negative translation from positie offset.");
}

- (void)testPositiveLineTranslationWithNegativeSlope
{
    CGPoint start = CGPointMake(-10.0f, 10.0f);
    CGPoint end = CGPointMake(0.0f, 5.0f);
    Line *line = [[Line alloc] initWithStart:(start) andEnd:(end)];
    Line *translated = [Line getTranslatedLineFor:(line) andTranslation:(4.0f)];
    
    XCTAssert([translated offset] == 9.0f, @"Line translation failed for positive translation of a negative sloped line.");
}

/**
 *
 *  - (float)slope
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
