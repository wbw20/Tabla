//
//  Line.m
//  Tabla
//
//  Created by William Wettersten on 2/16/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "Line.h"

@implementation Line

- (id)initWithStart:(NSPoint)start andEnd:(NSPoint)end {
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
    return (self.end.y - self.start.y) / (self.end.x - self.start.x);
}

@end
