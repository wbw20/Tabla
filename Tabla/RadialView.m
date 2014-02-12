//
//  RadialView.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "RadialView.h"

@implementation RadialView

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *aPath = [NSBezierPath bezierPath];
    
    [aPath moveToPoint:NSMakePoint(0.0, 0.0)];
    [aPath lineToPoint:NSMakePoint(10.0, 10.0)];
    [aPath curveToPoint:NSMakePoint(18.0, 21.0)
          controlPoint1:NSMakePoint(6.0, 2.0)
          controlPoint2:NSMakePoint(28.0, 10.0)];
    
    [aPath appendBezierPathWithRect:NSMakeRect(2.0, 16.0, 8.0, 5.0)];

}

@end
