//
//  RadialView.h
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RadialViewController;

@interface RadialView : NSView
{
    IBOutlet RadialViewController *controller;
}
- (NSPoint)center;

@end
