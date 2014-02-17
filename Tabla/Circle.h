//
//  Circle.h
//  Tabla
//
//  Created by William Wettersten on 2/16/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Circle : NSObject

@property CGPoint center;
@property float radius;

- (id)initWithCenter:(CGPoint)center andRadius:(float)radius;
- (CGPoint) pointOnCircleFor:(float)radians;

@end
