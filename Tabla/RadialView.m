//
//  RadialView.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "RadialView.h"

@implementation RadialView

- (id)initWithFrame:(NSRect)rect
{
    if (![super initWithFrame:rect])
        return nil;
    
    NSRect test = [self bounds];
    
    NSLog(@"Height: %f", test.size.height);
    NSLog(@"Width: %f", test.size.width);
    
    // Seed the random number generator
    srandom((int)time(NULL));
    
    // Create a path object
    path = [[NSBezierPath alloc] init];
    [path setLineWidth:3.0];
    NSPoint p = NSMakePoint(0.0, 0.0);
    [path moveToPoint:p];
    int i;
    for (i = 0; i < 500; i+= 100) {
        p = NSMakePoint(i, i + 43);
        [path lineToPoint:p];
    }
    [path closePath];
    return self;
}

// randomPoint returns a random point inside the view
- (NSPoint)randomPoint
{
    NSPoint result;
    NSRect r = [self bounds];
    result.x = r.origin.x + random() % (int)r.size.width;
    result.y = r.origin.y + random() % (int)r.size.height;
    return result;
}

- (void)drawRect:(NSRect)rect
{
    NSRect bounds = [self bounds];
    
    // Fill the view with green
    [[NSColor blueColor] set];
    [NSBezierPath fillRect: bounds];
    
    // Draw the path in white
    [[NSColor whiteColor] set];
    [path stroke];
}

@end
