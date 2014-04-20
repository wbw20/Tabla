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

#define KERF 2.0f

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
    // register file URL drag type
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"UpdateRadialNotification"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSLog(@"Radial Updated!");
     }];
    // set the radius of the entire pad
    maxRadius = self.frame.size.width * .4;
    // locate the center of the view
    center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    return self;
}

- (void)mouseUp:(NSEvent *)event {
    // get mouse location
    NSPoint mouseLoc = [self.window mouseLocationOutsideOfEventStream];
    mouseLoc = [self convertPoint:mouseLoc fromView:nil];
    // locate the corresponding zone
    int concentric = [self getRing:mouseLoc];
    int radial = [self getZone:mouseLoc];
    [controller playSoundForRadial:radial andConcentric:concentric];
}

#pragma mark - Dragging Operations

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender { }

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

- (int)getRing:(NSPoint)loc {
    loc.x -= center.x;
    loc.y -= center.y;
    float r = sqrt(pow(loc.x, 2) + pow(loc.y, 2));
    float ringSize = maxRadius / [controller concentric];
    int ringNum = floor(r / ringSize);
    float ringMod = r - (ringNum * ringSize);
    if(ringNum == 0 || (ringMod >= KERF && ringNum < [controller concentric]))
        return ringNum + 1;
    return 0;
}

- (int)getZone:(NSPoint)loc {
    loc.x -= center.x;
    loc.y -= center.y;
    float rad = atanf(loc.y / loc.x);
    if(loc.x < 0) rad += M_PI;
    else if(loc.x > 0 && loc.y < 0) rad += 2.0f * M_PI;
    float zoneSize = 2.0f * M_PI / [controller radial];
    int zoneNum = floor(rad / zoneSize);
//    float zoneMod = rad - (zoneNum * zoneSize);
//    if(zoneMod >= [self arcTrim] && zoneMod <= [self arcTrim] + [self arclength])
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
//        if(hoverRing != 0 && hoverZone != 0 && (r == 0 || z == 0))
//            NSLog(@"-(r:%ld, z:%ld)", (long) hoverRing, (long) hoverZone);
//        else if(r > 0 && z > 0)
//            NSLog(@"+(r:%d, z:%d)", r, z);
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
    [self drawCenterZone];
    for(int concentric = 2; concentric <= controller.concentric; concentric++) {
        for(int radial = 1; radial <= controller.radial; radial++) {
            [self drawZoneAtConcentric:concentric Radial:radial];
        }
    }
}

- (void)drawCenterZone {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    if(hoverRing == 1 && hoverZone == 1)
        [[NSColor blueColor] setFill];
    else
        [[NSColor colorWithWhite:0.5 alpha:1] setFill];
    
    float r1 = maxRadius / controller.concentric;
    CGContextAddArc(context, center.x, center.y, r1, 0, 2 * M_PI, 0);
    CGContextFillPath(context);
}

- (void)drawZoneAtConcentric:(int)c Radial:(int)r {
    // get the current graphics context
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    if(hoverRing == c && hoverZone == r)
        [[NSColor blueColor] setFill];
    else
        [[NSColor colorWithWhite:0.5 alpha:1] setFill];
    
    // radius of this zone
    float rd = maxRadius / controller.concentric;
    float r1 = rd * (c - 1) + KERF * 2;
    float r2 = rd * c;
    // angle in radians
    float theta =  2 * M_PI / controller.radial;
    float theta1 = theta * (r - 1);
    float theta2 = theta * r;
    
    float r1theta = controller.radial > 1 ? atanf(KERF / r1) : 0;
    float r2theta = controller.radial > 1 ? atanf(KERF / r2) : 0;
    
    CGContextAddArc(context, center.x, center.y, r1,
                    theta1 + r1theta, theta2 - r1theta, 0);
    CGContextAddArc(context, center.x, center.y, r2,
                    theta2 - r2theta, theta1 + r2theta, 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@end
