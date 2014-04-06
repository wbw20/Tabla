//
//  RadialViewController.h
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WindowController.h"

@interface PadViewController : NSViewController {
    IBOutlet WindowController *windowController;
}

-(void)addSound:(NSURL *) url atRadial:(NSInteger)radial andContentric:(NSInteger)concentric;

// I'm not a huge fan of this
- (NSInteger) radial;
- (void) setRadial:(NSInteger)radial;
- (NSInteger) concentric;
- (void) setConcentric:(NSInteger)concentric;
// END I'm not a huge fan of this

@end
