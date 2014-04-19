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
#import "PadView.h"

#define KERF 8.0f

@implementation PadView

//@TODO: move state to controller
NSString *kPrivateDragUTI = @"com.tabla.radialDnD";
NSInteger hoverZone = 0;
NSInteger hoverRing = 0;
NSInteger maxRadius;
NSPoint center;

- (id)initWithFrame:(NSRect)rect {
    if (![super initWithFrame:rect])
        return nil;
    if (self)
        // register file URL drag type
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
    // set the radius of the entire pad
    maxRadius = self.frame.size.width * .4;
    // locate the center of the view
    center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    return self;
}

- (void) mouseUp:(NSEvent *)event {
    // get mouse location
    NSPoint mouseLoc = [self.window mouseLocationOutsideOfEventStream];
    mouseLoc = [self convertPoint:mouseLoc fromView:nil];
    // locate the corresponding zone
    int concentric = [self getRing:mouseLoc];
    int radial = [self getZone:mouseLoc];
    [controller playSoundForRadial:radial andConcentric:concentric];
}

#pragma mark - Dragging Operations

-(NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

-(void) draggingExited:(id<NSDraggingInfo>)sender { }

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSURL* fileURL = [NSURL URLFromPasteboard: [sender draggingPasteboard]];
    if(fileURL != NULL) {
        // get mouse location
        NSPoint mouseLoc = [self.window mouseLocationOutsideOfEventStream];
        mouseLoc = [self convertPoint:mouseLoc fromView:nil];
        // locate the corresponding zone
        int concentric = [self getRing:mouseLoc];
        int radial = [self getZone:mouseLoc];
        NSLog(@"%@ dropped at (%.2f,%.2f)", [fileURL absoluteString], mouseLoc.x, mouseLoc.y);
        NSLog(@"Located in ring %d zone %d", concentric, radial);
        if(concentric > 0 && radial > 0) {
            [controller addSound:fileURL atRadial:radial andContentric:concentric];
            return YES;
        }
    }
    return NO;
}

-(int)getRing:(NSPoint)loc {
    loc.x -= center.x;
    loc.y -= center.y;
    float r = sqrt(pow(loc.x, 2) + pow(loc.y, 2));
    float ringSize = [self radius] / [controller concentric];
    int ringNum = floor(r / ringSize);
    float ringMod = r - (ringNum * ringSize);
    if(ringNum == 0 || (ringMod >= KERF && ringNum < [controller concentric]))
        return ringNum + 1;
    return 0;
}

-(int)getZone:(NSPoint)loc {
    loc.x -= center.x;
    loc.y -= center.y;
    float rad = atanf(loc.y / loc.x);
    if(loc.x < 0) rad += M_PI;
    else if(loc.x > 0 && loc.y < 0) rad += 2.0f * M_PI;
    float zoneSize = 2.0f * M_PI / [controller radial];
    int zoneNum = floor(rad / zoneSize);
    float zoneMod = rad - (zoneNum * zoneSize);
    if(zoneMod >= [self arcTrim] && zoneMod <= [self arcTrim] + [self arclength])
        return zoneNum + 1;
    return 0;
}

#pragma mark - Mouse Events

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if(trackingArea) {
        [self removeTrackingArea: trackingArea];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow | NSTrackingMouseMoved;
    trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseMoved:(NSEvent *)e {
    NSPoint loc = [self convertPoint:[e locationInWindow] fromView:nil];
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
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextClearRect(context, [self frame]);

    NSRect bounds = [self bounds];
    [[NSColor windowBackgroundColor] set];
    [NSBezierPath fillRect: bounds];
    [self drawZones];
}

- (void)redraw {
    [self setNeedsDisplay:YES];
}

/**
 *  Draws zones to the graphics context
 **/
- (void)drawZones {
    for(int concentric = 2; concentric <= controller.concentric; concentric++) {
        for(int radial = 1; radial <= controller.radial; radial++) {
            [self drawZoneAtConcentric:concentric Radial:radial];
        }
    }
}

- (void)drawZoneAtConcentric:(int)c Radial:(int)r {
    // get the current graphics context
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    [[NSColor blueColor] setFill];
    CGContextSetLineWidth(context, 2);
    // radius of this zone
    float rd = maxRadius / controller.concentric;
    float r1 = rd * (c - 1) + 5;
    float r2 = rd * c;
    // angle in radians
    float theta =  2 * M_PI / controller.radial;
    float theta1 = theta * (r - 1);
    float theta2 = theta * r;
    if(controller.radial > 1) theta2 -= 0.05;
    
    NSLog(@"Arc from %f to %f", theta1, theta2);
    
    CGContextAddArc(context, center.x, center.y, r1, theta1, theta2, 0);
    CGContextAddArc(context, center.x, center.y, r2, theta2, theta1, 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

/**
 *  Draws an arc from a start radian to an end radian
 **/
- (void)drawArcFrom:(float)start to:(float)end withRadius:(float)radius {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context, center.x, center.y, radius, start, end, 0);
    CGContextStrokePath(context);
}

/**
 *  Get the arclength in radians for any zone
 **/
- (float)arclength {
    float arc = 2.0f*M_PI/[controller radial];
    
    //we will remove some of the arc to account for the rounded corners
    return arc - 2*[self arcTrim];
}

/**
 *  Return the amount of arc to trim for a given rounded corner
 **/
- (float)arcTrim {
    return asinf(KERF/[self radius]);
}

/*
 *  Get global radius
 **/
- (float)radius {
    return [self frame].size.width * 0.4;
}

/**
 *  Return the radius for concentric circle with a given index.  Indexes
 *  start with 0 and go from the inside out.
 **/
- (float)getRadiusFor:(int)index {
    NSInteger rings = [controller concentric] == 0 ? 1: [controller concentric];
    float width = [self radius] / rings; // the width of a ring
    return width * (index);
}

/**
 *  Draws a line for a concentric zone at a given radial mark
 **/
- (void)drawLineFor:(float)radial andZone:(int)zone {
    if (zone == 1) return; // innermost circle has no radial lines

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 2);
    Circle *inner = [[Circle alloc] initWithCenter:center andRadius:[self getRadiusFor:(zone - 1)] + KERF];
    Circle *outer = [[Circle alloc] initWithCenter:center andRadius:[self getRadiusFor:(zone)]];

    CGPoint right[] = {[inner pointOnCircleFor:(radial)], [outer pointOnCircleFor:(radial)]};
    CGContextAddLines(context, right, 2);
    CGContextStrokePath(context);
}

/**
 *  Finds the line length for any zone
 **/
- (float)linelength {
    return ([self radius] / [controller radial]) - 2 * KERF;
}

@end
