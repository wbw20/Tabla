//
//  Circle.m
//  Tabla
//
//  Created by William Wettersten on 2/16/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (id)initWithCenter:(CGPoint)center andRadius:(float)radius {
    self = [super init];
    
    if (self) {
        self.center = center;
        self.radius = radius;
    }
    
    return self;
}

/**
 *  Get the Cartesian point on this circle for any radian value
 **/
- (CGPoint) pointOnCircleFor:(float)radians {
    CGPoint point;
    
    point.x = self.center.x + self.radius*cos(radians);
    point.y = self.center.y + self.radius*sin(radians);
    
    return point;
}

@end
