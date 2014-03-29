//
//  CounterView.h
//  Tabla
//
//  Created by William Wettersten on 3/24/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "RadialView.h"

@interface CounterView : NSImageView
    @property int value;
    @property (nonatomic, retain) IBOutlet NSTextField* label;
    @property (nonatomic) IBOutlet RadialView* pad;

    - (void) up;
    - (void) down;
@end

@interface UpView : NSView
    @property (nonatomic, retain) IBOutlet CounterView* parent;
@end

@interface DownView : NSView
    @property (nonatomic, retain) IBOutlet CounterView* parent;
@end
