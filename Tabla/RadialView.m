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
    
    return self;
}

/**
 *  Returns the center of the view
 **/
- (NSPoint)center
{
    NSPoint center;
    NSRect box = [self bounds];

    center.x = box.size.width / 2;
    center.y = box.size.height / 2;
    return center;
}

- (void)drawRect:(NSRect)rect
{
    NSRect bounds = [self bounds];
    
    // Fill the view with green
    [[NSColor blueColor] set];
    [NSBezierPath fillRect: bounds];
}

@end
