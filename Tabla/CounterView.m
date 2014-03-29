//
//  CounterView.m
//  Tabla
//
//  Created by William Wettersten on 3/24/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "CounterView.h"

static NSColor *darkColor = nil;

// runs on class load
__attribute__((constructor))
static void initialize_navigationBarImages() {
    darkColor = [NSColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f];
}

@implementation UpView

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [darkColor set];
    [NSBezierPath fillRect: [self bounds]];
}

- (void) mouseUp:(NSEvent *)event {
    [[self parent] up];
}

@end

@implementation DownView

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [darkColor set];
    [NSBezierPath fillRect: [self bounds]];
}

- (void) mouseUp:(NSEvent *)event {
    [[self parent] down];
}

@end

@implementation CounterView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setValue:0];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)up {
    [self setValue:[self value] + 1];
    [[self label] setStringValue:[NSString stringWithFormat:@"%d", [self value]]];
}

- (void)down {
    [self setValue:[self value] - 1];
    [[self label] setStringValue:[NSString stringWithFormat:@"%d", [self value]]];
}

@end

@interface RadialCounterView : CounterView
@end

@implementation RadialCounterView

- (void)up {
    [super up];
    [[self pad] setRadial:[[self pad] radial] + 1];
    [[self pad] drawZones];
}

- (void)down {
    [super up];
    [[self pad] setRadial:[[self pad] radial] - 1];
    [[self pad] drawZones];
}

@end

@interface ConcentricCounterView : CounterView
@end

@implementation ConcentricCounterView

- (void)up {
    [super up];
    [[self pad] setConcentric:[[self pad] concentric] + 1];
    [[self pad] drawZones];
}

- (void)down {
    [super up];
    [[self pad] setConcentric:[[self pad] concentric] - 1];
    [[self pad] drawZones];
}

@end

