//
//  RadialView.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "RadialView.h"

@implementation RadialView

- (void)drawRect:(NSRect)dirtyRect {
  CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
  CGContextSetRGBFillColor (myContext, 1, 0, 0, 1);
}

@end
