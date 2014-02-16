//
//  Line.m
//  Tabla
//
//  Created by William Wettersten on 2/16/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "Line.h"

@implementation Line

/**
 *  Return the scalar distance that a line must be translated for a
 *  given kerf value.
 **/
+ (float)getTranslationFor:(Line*)line andKerf:(float)kerf {
    float angle = (M_PI/2) - atan(line.slope);
    return kerf / sin(angle);
}

- (id)initWithStart:(CGPoint)start andEnd:(CGPoint)end {
    self = [super init];
    
    if (self) {
        self.start = start;
        self.end = end;
    }

    return self;
}

/**
 *  Returns the slope of this line
 **/
- (float)slope {
    if ([self pointsEqual]) { return 0.0f; }
    return (self.end.y - self.start.y) / (self.end.x - self.start.x);
}

/**
 *  Checks if the end points of the line are the same
 **/
- (BOOL)pointsEqual {
    return self.start.x == self.end.x && self.start.y == self.end.y;
}

@end
