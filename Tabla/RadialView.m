//
//  RadialView.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "RadialView.h"

#define RADIUS 200

@implementation RadialView

- (id)initWithFrame:(NSRect)rect
{
    if (![super initWithFrame:rect])
        return nil;
    
    NSPoint center = [self center];
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, 10, 500);
    CGContextAddArc(context, center.x, center.y, RADIUS, M_PI * 2, M_PI, 0);
    CGContextStrokePath(context);

    
    // Seed the random number generator
    srandom((int)time(NULL));
    
    // Create a path object
    path = [[NSBezierPath alloc] init];
    [path setLineWidth:3.0];
    NSPoint p = NSMakePoint(0.0, 0.0);
    [path moveToPoint:p];
    int i;
    for (i = 0; i < 500; i+= 100) {
        p = NSMakePoint(i, i + 43);
        [path lineToPoint:p];
    }
    [path closePath];
    
    NSBezierPath* aPath = [NSBezierPath bezierPath];
    [aPath setLineWidth:3.0];
    
    [aPath moveToPoint:NSMakePoint(0.0, 0.0)];
    [aPath lineToPoint:NSMakePoint(100.0, 100.0)];
    [aPath curveToPoint:NSMakePoint(108.0, 210.0)
          controlPoint1:NSMakePoint(60.0, 20.0)
          controlPoint2:NSMakePoint(280.0, 100.0)];
    [aPath stroke];

    
    return self;
}

/**
 *  Returns the center of the view
 **/
- (NSPoint)center
{
    NSPoint center;
    NSRect box = [self bounds];

    center.x = box.size.width;
    center.y = box.size.height;
    return center;
}

- (void)drawRect:(NSRect)rect
{
    NSRect bounds = [self bounds];
    
    // Fill the view with green
    [[NSColor blueColor] set];
    [NSBezierPath fillRect: bounds];
    
    // Draw the path in white
    [[NSColor whiteColor] set];
    [path stroke];
}

@end
