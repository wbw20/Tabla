//
//  CounterView.m
//  Tabla
//
//  Created by William Wettersten on 3/24/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "CounterView.h"

static NSColor *darkColor = nil;

//bounds
static int RADIAL_LOWER_BOUND = 1;
static int RADIAL_UPPER_BOUND = 8;
static int CONCENTRIC_LOWER_BOUND = 1;
static int CONCENTRIC_UPPER_BOUND = 4;

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

- (void)displayValue:(NSInteger)value {
    [[self label] setStringValue:@(value).stringValue];
}

@end

@interface RadialCounterView : CounterView
    @property (nonatomic) IBOutlet PadView* pad;
@end

@implementation RadialCounterView

- (void)up {
    if ([[super controller] radial] >= RADIAL_UPPER_BOUND) { return; } // bounds check
    [[super controller] setRadial:[[super controller] radial] + 1];
    [super displayValue:[[super controller] radial]];
    [[self pad] redraw];
}

- (void)down {
    if ([[super controller] radial] <= RADIAL_LOWER_BOUND) { return; } // bounds check
    [[super controller] setRadial:[[super controller] radial] - 1];
    [super displayValue:[[super controller] radial]];
    [[self pad] redraw];
}

@end

@interface ConcentricCounterView : CounterView
    @property (nonatomic) IBOutlet PadView* pad;
@end

@implementation ConcentricCounterView

- (void)up {
    if ([[super controller] concentric] >= CONCENTRIC_UPPER_BOUND) { return; } // bounds check
    [[super controller] setConcentric:[[super controller] concentric] + 1];
    [super displayValue:[[super controller] concentric]];
    [[self pad] redraw];
}

- (void)down {
    if ([[super controller] concentric] <= CONCENTRIC_LOWER_BOUND) { return; } // bounds check
    [[super controller] setConcentric:[[super controller] concentric] - 1];
    [super displayValue:[[super controller] concentric]];
    [[self pad] redraw];
}

@end

