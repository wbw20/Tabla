//
//  RadialView.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "math.h"
#import "PadView.h"

#define KERF 2.0f

@implementation PadView

NSString *kPrivateDragUTI = @"com.tabla.radialDnD";
NSInteger concentric;           // number of concentric rings
NSInteger radial;               // number of radial slices
NSInteger hoverRadial;          // radial index of zone under the mouse
NSInteger hoverConcentric;      // concentric index of zone under the mouse
NSMutableDictionary *colors;    // mapping of zones to colors
NSInteger maxRadius;            // maximum radius of the entire pad
NSPoint center;                 // center coordinate of the view
float rd;                       // radial width of each zone
float theta;                    // angle of each zone

- (id)initWithFrame:(NSRect)rect {
    if (![super initWithFrame:rect]) return nil;
        
    concentric = 1;
    radial = 1;
    hoverRadial = 0;
    hoverConcentric = 0;
    colors = [[NSMutableDictionary alloc] init];
    // set the radius of the entire pad
    maxRadius = self.frame.size.width * .4;
    // locate the center of the view
    center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    theta = 2 * M_PI / radial;
    rd = maxRadius / concentric;
    
    // execute when radial is updated
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"UpdateRadial"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         radial = [[[note userInfo] objectForKey:@"radial"] integerValue];
         theta = 2 * M_PI / radial;
         [self setNeedsDisplay:YES];
     }];
    
    // execute when concentric is updated
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"UpdateConcentric"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         concentric = [[[note userInfo] objectForKey:@"concentric"] integerValue];
         rd = maxRadius / concentric;
         [self setNeedsDisplay:YES];
     }];
    
    // execute when a sound gets mapped to a zone
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"SetZone"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSDictionary *ui = note.userInfo;
         NSInteger c = [[ui objectForKey:@"concentric"] integerValue];
         NSInteger r = [[ui objectForKey:@"radial"] integerValue];
         float red = [[ui objectForKey:@"red"] floatValue];
         float green = [[ui objectForKey:@"green"] floatValue];
         float blue = [[ui objectForKey:@"blue"] floatValue];
         NSColor *color = [NSColor colorWithRed:red green:green blue:blue alpha:1.0f];
         [self setColor:color ForConcentric:c Radial:r];
         [self setNeedsDisplay:YES];
     }];
    
    // execute when a sound is cleared from a zone
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"ClearZone"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSInteger c = [[[note userInfo] objectForKey:@"concentric"] integerValue];
         NSInteger r = [[[note userInfo] objectForKey:@"radial"] integerValue];
         [self removeColorForConcentric:c Radial:r];
         [self setNeedsDisplay:YES];
     }];
    
    // register file URL drag type
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, NSColorPboardType, nil]];
    
    return self;
}

- (void)mouseUp:(NSEvent *)event {
    // get mouse location
    NSPoint mouseLoc = [self.window mouseLocationOutsideOfEventStream];
    mouseLoc = [self convertPoint:mouseLoc fromView:nil];
    // locate the corresponding zone
    int concentric = [self getConcentric:mouseLoc];
    int radial = [self getRadial:mouseLoc];
    if(radial != 0 && concentric != 0) {
        NSDictionary *userInfo = @{@"radial": [NSNumber numberWithInt:radial],
                                   @"concentric": [NSNumber numberWithInt:concentric]};
        // determine if command key is down during event
        NSString *note = [event modifierFlags] & NSCommandKeyMask ? @"ZoneCommandClicked" : @"ZoneClicked";
        [[NSNotificationCenter defaultCenter]
         postNotificationName:note
         object:self
         userInfo:userInfo];
    }
}

#pragma mark - Dragging Operations

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender { }

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    // get mouse location
    NSPoint mouseLoc = [self.window mouseLocationOutsideOfEventStream];
    mouseLoc = [self convertPoint:mouseLoc fromView:nil];
    // locate the corresponding zone
    int concentric = [self getConcentric:mouseLoc];
    int radial = [self getRadial:mouseLoc];
    
    if(concentric > 0 && radial > 0) {
        // check if data is a URL
        NSURL* fileURL = [NSURL URLFromPasteboard:[sender draggingPasteboard]];
        if(fileURL != nil) {
            // send a notification that a sound has been dropped
            NSDictionary *userInfo = @{@"radial": [NSNumber numberWithInt:radial],
                                       @"concentric": [NSNumber numberWithInt:concentric],
                                       @"file": [fileURL absoluteString]};
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SoundDropped"
             object:self
             userInfo:userInfo];
            return YES;
        }
        // check if data is a color
        NSColor *color = [NSColor colorFromPasteboard:[sender draggingPasteboard]];
        if(color != nil) {
            // send a notification that a color has been dropped
            // NSData *data = [NSArchiver archivedDataWithRootObject:color];
            NSDictionary *userInfo = @{@"radial": [NSNumber numberWithInt:radial],
                                       @"concentric": [NSNumber numberWithInt:concentric],
                                       //@"color": data};
                                       @"red": [NSNumber numberWithFloat:color.redComponent],
                                       @"green": [NSNumber numberWithFloat:color.greenComponent],
                                       @"blue": [NSNumber numberWithFloat:color.blueComponent]};
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ColorDropped"
             object:self
             userInfo:userInfo];
            return YES;
        }
    }
    return NO;
}

#pragma mark - Hit Tests

// returns the concentric index of loc, or 0 if it's not in a zone
- (int)getConcentric:(NSPoint)loc {
    // translate center of view to 0,0
    loc.x -= center.x;
    loc.y -= center.y;
    // convert to circular radius
    float r = sqrt(pow(loc.x, 2) + pow(loc.y, 2));
    // get the concentric zone index
    int cIndex = floor(r / rd);
    // get distance from inner edge
    float d = r - cIndex * rd;
    // exact boundary test
    if(cIndex == 0 || (d >= KERF && cIndex < concentric))
        return cIndex + 1;
    return 0;
}

// returns the radial index of loc, or 0 if it's not in a zone
- (int)getRadial:(NSPoint)loc {
    // translate center of view to 0,0
    loc.x -= center.x;
    loc.y -= center.y;
    // convert to circular coordinates
    float r = sqrt(pow(loc.x, 2) + pow(loc.y, 2));
    // special case for the center zone
    if(r <= rd) return 1;
    float angle = atanf(loc.y / loc.x);
    if(loc.x < 0) angle += M_PI;
    else if(loc.x > 0 && loc.y < 0) angle += 2 * M_PI;
    // get the radial zone index
    int rIndex = floor(angle / theta);
    // get kerf angle for this radius
    float kerfAngle = [self getKerfAngleForRadius:r];
    // get angular distance from start
    float d = angle - rIndex * theta;
    // exact boundary test
    if(d >= kerfAngle && d <= theta - kerfAngle)
        return rIndex + 1;
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
    int r = [self getConcentric:loc];
    int z = [self getRadial:loc];
    if(r != hoverConcentric || z != hoverRadial) {
        hoverConcentric = r;
        hoverRadial = z;
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

/**
 *  Draws zones to the graphics context
 **/
- (void)drawZones {
    //NSLog(@"Draw zones");
    [self drawCenterZone];
    for(int c = 2; c <= concentric; c++)
        for(int r = 1; r <= radial; r++)
            [self drawZoneAtConcentric:c Radial:r];
}

- (void)drawCenterZone {
    //NSLog(@"Draw center zone");
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    [[self getColorForConcentric:1 Radial:1] setFill];
    
    CGContextAddArc(context, center.x, center.y, rd, 0, 2 * M_PI, 0);
    CGContextFillPath(context);
}

- (void)drawZoneAtConcentric:(int)c Radial:(int)r {
    //NSLog(@"Draw zone c:%d, r:%d", c, r);
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    [[self getColorForConcentric:c Radial:r] setFill];
    
    float r1 = rd * (c - 1) + KERF * 2; // inner radius
    float r2 = rd * c;                  // outer radius
    
    float theta1 = theta * (r - 1);     // start angle
    float theta2 = theta * r;           // end angle
    
    float r1theta = [self getKerfAngleForRadius:r1];
    float r2theta = [self getKerfAngleForRadius:r2];
    
    CGContextAddArc(context, center.x, center.y, r1,
                    theta1 + r1theta, theta2 - r1theta, 0);
    CGContextAddArc(context, center.x, center.y, r2,
                    theta2 - r2theta, theta1 + r2theta, 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)setColor:(NSColor*)color ForConcentric:(NSInteger)c Radial:(NSInteger)r {
    NSData *data = [NSArchiver archivedDataWithRootObject:color];
    [colors setObject:data forKey:[self getHashForConcentric:c Radial:r]];
}

- (void)removeColorForConcentric:(NSInteger)c Radial:(NSInteger)r {
    [colors removeObjectForKey:[self getHashForConcentric:c Radial:r]];
}

- (NSColor*)getColorForConcentric:(int)c Radial:(int)r {
    // retrive entry from dictionary
    NSData *data = [colors objectForKey:[self getHashForConcentric:c Radial:r]];
    // if nil, just use grey
    NSColor *color = data == nil ? [NSColor colorWithWhite:0.5 alpha:1] : [NSUnarchiver unarchiveObjectWithData:data];
    // if this zone is hovered over, blend with system highlight color
    if(hoverConcentric == c && hoverRadial == r)
        color = [color highlightWithLevel:0.5f];
    return color;
}

- (NSString*)getHashForConcentric:(NSInteger)c Radial:(NSInteger)r {
    // hash allows up to 1000 radial slices per concentric ring
    return [NSString stringWithFormat:@"%ld", 1000 * c + r];
}

- (float)getKerfAngleForRadius:(float)r {
    return radial > 1 ? atanf(KERF / r) : 0;
}

@end
