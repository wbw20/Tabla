//
//  RadialView.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "math.h"

#import "RadialView.h"

#define RADIUS 200.0f
#define KERF 20.0f
#define ZONES 5

@implementation RadialView

- (id)initWithFrame:(NSRect)rect
{
    if (![super initWithFrame:rect])
        return nil;
    
    // Start with a single, full-circle zone
    [self drawZones];


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
    NSPoint eventLocation = [event locationInWindow];
    NSPoint center = [self convertPoint:eventLocation fromView:nil];
    
    NSLog(@"%f", center.x);
}

/**
 *  Draws zones to the graphics context
 **/
- (void)drawZones {
    float start = 0.0f;
    while (start < 2*M_PI) {
        start += [self arcTrim];
        float end = start + [self arclength];
        [self drawArcFrom:start to:end withRadius:RADIUS];
        [self drawLinesFrom:start to:end forCircle:1];
        start = end + [self arcTrim];
    }
}

/**
 *  Draws an arcs from a start radian to an end radian
 **/
- (void)drawArcFrom:(float)start to:(float)end withRadius:(float)radius {
    NSPoint center = [self center];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 2);
    [[NSColor grayColor] setStroke];
    CGContextAddArc(context, center.x, center.y, radius, start, end, 0);
    CGContextStrokePath(context);
}

/**
 *  Draws the straight lines for a given zone
 **/
- (void)drawLinesFrom:(float)start to:(float)end forCircle:(int)circle {
    NSPoint center = [self center];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 2);
    [[NSColor grayColor] setStroke];
    CGPoint points[] = {CGPointMake(center.x + RADIUS*cos(start), center.y + RADIUS*sin(start)), CGPointMake(center.x + RADIUS*cos(end), center.y + RADIUS*sin(end))};
    CGContextAddLines(context, points, 2);
    CGContextStrokePath(context);
}

/**
 *  Get the arclength in radians for any zone
 **/
- (float)arclength {
    float arc = 2.0f*M_PI/ZONES;
    
    //we will remove some of the arc to account for the rounded corners
    return arc - 2*[self arcTrim];
}

/**
 *  Return the amount of arc to trim for a given rounded corner
 **/
- (float)arcTrim {
    return asinf(KERF/RADIUS);
}

/**
 *  Draws a circle to the current graphics context
 */
- (void)drawCircleWithCenter:(NSPoint)center andRadius:(float)radius {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 2);
    [[NSColor grayColor] setStroke];
    CGContextAddArc(context, center.x, center.y, radius, 0, [self arclength], 0);
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
