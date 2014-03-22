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
#define KERF 8.0f
#define ZONES 8     // zones are indexed counter-clockwise
#define RINGS 4     // rings are indexed from the inside out

@implementation RadialView

//@TODO: move state to controller
static int concentric = RINGS;
static int radial = ZONES;
NSString *kPrivateDragUTI = @"com.tabla.radialDnD";
NSInteger hoverZone = 0;
NSInteger hoverRing = 0;

- (id)initWithFrame:(NSRect)rect {
    if (![super initWithFrame:rect])
        return nil;
    if(self) {
        // register file URL drag type
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
    }
    return self;
}

#pragma mark - Dragging Operations

-(NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

-(void) draggingExited:(id<NSDraggingInfo>)sender {
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSURL* fileURL = [NSURL URLFromPasteboard: [sender draggingPasteboard]];
    if(fileURL != NULL) {
        // get mouse location
        NSPoint mouseLoc = [self.window mouseLocationOutsideOfEventStream];
        mouseLoc = [self convertPoint:mouseLoc fromView:nil];
        mouseLoc.x -= 250;
        mouseLoc.y -= 250;
        // locate the corresponding zone
        int ring = [self getRing:mouseLoc];
        int zone = [self getZone:mouseLoc];
        NSLog(@"%@ dropped at (%.2f,%.2f)", [fileURL absoluteString], mouseLoc.x, mouseLoc.y);
        NSLog(@"Located in ring %d zone %d", ring, zone);
        if(ring > 0 && zone > 0) {
            [controller addSound:fileURL];
            return YES;
        }
    }
    return NO;
}

-(int)getRing:(NSPoint)loc {
    float r = sqrt(pow(loc.x, 2) + pow(loc.y, 2));
    float ringSize = RADIUS / concentric;
    int ringNum = floor(r / ringSize);
    float ringMod = r - (ringNum * ringSize);
    if(ringNum == 0 || (ringMod >= KERF && ringNum < concentric))
        return ringNum + 1;
    return 0;
}

-(int)getZone:(NSPoint)loc {
    float rad = atanf(loc.y / loc.x);
    if(loc.x < 0) rad += M_PI;
    else if(loc.x > 0 && loc.y < 0) rad += 2.0f * M_PI;
    float zoneSize = 2.0f * M_PI / radial;
    int zoneNum = floor(rad / zoneSize);
    float zoneMod = rad - (zoneNum * zoneSize);
    if(zoneMod >= [self arcTrim] && zoneMod <= [self arcTrim] + [self arclength])
        return zoneNum + 1;
    return 0;
}

#pragma mark - Mouse Events

/**
 *  Responds to click events
 */
- (void)mouseUp: (NSEvent *)event {
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    location.x -= 250;
    location.y -= 250;
    int r = [self getRing:location];
    int z = [self getZone:location];
    if(r > 0 && z > 0) {
        if(r == 1) z = 1;
        NSLog(@"Located in ring %d zone %d", r, z);
    } else {
        NSLog(@"Not located in a zone");
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if(trackingArea) {
        [self removeTrackingArea: trackingArea];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow | NSTrackingMouseMoved;
    trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)e {
    NSLog(@"Enter");
}

- (void)mouseExited:(NSEvent *)e {
    NSLog(@"Exit");
}

- (void)mouseMoved:(NSEvent *)e {
    NSPoint loc = [self convertPoint:[e locationInWindow] fromView:nil];
    loc.x -= 250;
    loc.y -= 250;
    int r = [self getRing:loc];
    int z = [self getZone:loc];
    if(r != hoverRing || z != hoverZone) {
        if(hoverRing != 0 && hoverZone != 0 && (r == 0 || z == 0))
            NSLog(@"-(r:%ld, z:%ld)", (long) hoverRing, (long) hoverZone);
        else if(r > 0 && z > 0)
            NSLog(@"+(r:%d, z:%d)", r, z);
        hoverRing = r;
        hoverZone = z;
        [self setNeedsDisplay:YES];
    }
}

#pragma mark - Drawing Operations

- (void)drawRect:(NSRect)rect
{
    NSRect bounds = [self bounds];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect: bounds];
    [self drawZones];
}

/**
 *  Draws zones to the graphics context
 **/
- (void)drawZones {
    // draw innermost zone
    if(1 == hoverRing)
        [[NSColor redColor] setStroke];
    else
        [[NSColor grayColor] setStroke];
    [self drawArcFrom:0.0f to:2*M_PI withRadius:[self getRadiusFor:(1)]];
    
    // draw zones
    for (int ring = 2; ring <= RINGS; ring++) {
        float start = 0.0f;
        int zone = 1;
        while (start < 2 * M_PI - [self arcTrim]) {
            start += [self arcTrim];
            float end = start + [self arclength];
            if(zone == hoverZone && ring == hoverRing) {
                [[NSColor redColor] setStroke];
            } else {
                [[NSColor grayColor] setStroke];
            }
            [self drawLineFor:(start) andZone:ring];
            [self drawLineFor:(end) andZone:ring];
            [self drawArcFrom:start to:end withRadius:[self getRadiusFor:(ring -1)] + KERF];
            [self drawArcFrom:start to:end withRadius:[self getRadiusFor:(ring)]];
            start = end + [self arcTrim];
            zone++;
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
    Circle *inner = [[Circle alloc] initWithCenter:[self center] andRadius:[self getRadiusFor:(zone - 1)] + KERF];
    Circle *outer = [[Circle alloc] initWithCenter:[self center] andRadius:[self getRadiusFor:(zone)]];

    CGPoint right[] = {[inner pointOnCircleFor:(radial)], [outer pointOnCircleFor:(radial)]};
    CGContextAddLines(context, right, 2);
    CGContextStrokePath(context);
}

/**
 *  Finds the line length for any zone
 **/
- (float)linelength {
    return (RADIUS / ZONES) - 2 * KERF;
}

/**
 *  Draws a circle to the current graphics context
 */
- (void)drawCircleWithCenter:(NSPoint)center andRadius:(float)radius {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context, center.x, center.y, radius, 0, [self arclength], 0);
    CGContextStrokePath(context);
}

/**
 *  Returns the center of the view
 **/
- (NSPoint)center
{
    NSPoint center;
    center.x = 250;
    center.y = 250;
    return center;
}

@end
