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
#define RINGS 2

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
        [self drawLinesFrom:start to:end forZone:1];
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
 *  Get the Cartesian point on a circle for any radian value and circle index
 **/
- (CGPoint)getPointOnCircleAt:(float)radians for:(int)index {
    NSPoint center = [self center];
    NSPoint point;
    
    // get the radius of the concentric circle for the given index
    float radius = [self getRadiusFor:index];
    
    point.x = center.x + radius*cos(radians);
    point.y = center.x + radius*sin(radians);
    
    NSLog(@"%f", point.x);
    NSLog(@"%f", point.y);
    NSLog(@"\n");
    
    return CGPointMake(center.x, center.y);
}

/**
 *  Translates a line downwards with respect to the kerf
 **/
- (float)translateDownwardsByKerf:(float)kerf {
    return 0.0f;
}

/**
 *  Return the radius for concentric circle with a given index.  Indexes
 *  start with 0 and go from the outside in.
 **/
- (float)getRadiusFor:(int)index {
    return (RADIUS * (ZONES - index) / ZONES) - [self arcTrim];
}

/**
 *  Draws the straight lines for a given zone
 **/
- (void)drawLinesFrom:(float)start to:(float)end forZone:(int)zone {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 2);
    [[NSColor grayColor] setStroke];
    
    //Get the cartesian point in the center of the kerf for this circle
    CGPoint right[] = {[self getPointOnCircleAt:start for:zone], [self getPointOnCircleAt:start for:zone + 1]};
    CGContextAddLines(context, right, 2);
    CGContextStrokePath(context);
}

/**
 *  Finds the line length for any zone
 **/
- (float)linelength {
    return (RADIUS / ZONES) - 2*KERF;
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
