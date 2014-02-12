//
//  RadialView.h
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RadialView : NSView
{
    NSBezierPath *path;
}
- (NSPoint)center;

@end
