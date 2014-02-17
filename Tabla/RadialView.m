//
//  RadialView.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "math.h"

#import "Line.h"
#import "Circle.h"
#import "RadialView.h"
#import "RadialViewController.h"

#define RADIUS 200.0f
#define KERF 20.0f
#define ZONES 5
#define RINGS 3 // rings are indexed from the inside out

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
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    
    [controller test];
}

/**
 *  Draws zones to the graphics context
 **/
- (void)drawZones {
    // draw innermost zone
    [self drawArcFrom:0.0f to:2*M_PI withRadius:[self getRadiusFor:(1)]];
    
    for (int zone = 2; zone <= RINGS; zone++) {
        float start = 0.0f;
        while (start < 2*M_PI) {
            start += [self arcTrim];
            float end = start + [self arclength];
            [self drawLineFor:(start) andZone:zone];
            [self drawLineFor:(end) andZone:zone];
            [self drawArcFrom:start to:end withRadius:[self getRadiusFor:(zone)] + KERF/2];
            [self drawArcFrom:start to:end withRadius:[self getRadiusFor:(zone)] - KERF/2];
            start = end + [self arcTrim];
        }
    }
}

/**
 *  Draws an arc from a start radian to an end radian
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
 *  Return the radius for concentric circle with a given index.  Indexes
 *  start with 0 and go from the inside out.
 **/
- (float)getRadiusFor:(int)index {
    float width = RADIUS / (RINGS); // the width of a ring
    return width * (index);
}

/**
 *  Draws a line for a concentric zone at a given radial mark
 **/
- (void)drawLineFor:(float)radial andZone:(int)zone {
    if (zone == 1) return; // innermost circle has no radial lines

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 2);
    [[NSColor grayColor] setStroke];

    Circle *inner = [[Circle alloc] initWithCenter:[self center] andRadius:[self getRadiusFor:(zone - 1)]];
    Circle *outer = [[Circle alloc] initWithCenter:[self center] andRadius:[self getRadiusFor:(zone)]];

    CGPoint right[] = {[inner pointOnCircleFor:(radial)], [outer pointOnCircleFor:(radial)]};
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
