//
//  RadialView.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "RadialView.h"
#import "RadialViewController.h"

@implementation RadialView

- (id)initWithFrame:(NSRect)rect
{
    if (![super initWithFrame:rect])
        return nil;
    
    // Start with a single, full-circle zone
    [self drawCircleWithCenter:[self center] andRadius:self.frame.size.width/2];


    return self;
}

- (void)drawRect:(NSRect)rect
{
    NSRect bounds = [self bounds];
    
    // Fill the view with green
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect: bounds];
}

/**
 *  Responds to click events
 */
- (void)mouseUp: (NSEvent *)event {
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    
    [controller test];
}

/**
 *  Draws a circle to the current graphics context
 */
- (void)drawCircleWithCenter:(NSPoint)center andRadius:(int)radius {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 2);
    [[NSColor grayColor] setStroke];
    CGContextAddArc(context, center.x, center.y, radius, 0, 2 * M_PI, 0);
    CGContextStrokePath(context);
}

/**
 *  Returns the center of the view
 **/
- (NSPoint)center
{
    NSPoint center;
    
//    center.x = (self.frame.origin.x + (self.frame.size.width / 2));
//    center.y = (self.frame.origin.y + (self.frame.size.height / 2));
    
    // hard coded for now :(
    center.x = 105 + 250;
    center.y = 98 + 250;

    return center;
}

@end
