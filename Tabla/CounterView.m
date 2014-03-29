//
//  CounterView.m
//  Tabla
//
//  Created by William Wettersten on 3/24/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "CounterView.h"

@interface UpView : NSView
@end

static NSColor *darkColor = nil;

@implementation UpView

// runs on class load
__attribute__((constructor))
static void initialize_navigationBarImages() {
    darkColor = [NSColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [darkColor set];
    [NSBezierPath fillRect: [self bounds]];
}

@end

@implementation CounterView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
