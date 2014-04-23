//
//  WindowController.h
//  Tabla
//
//  Created by William Wettersten on 4/3/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Profile.h"

@interface WindowController : NSWindowController

@property Profile *profile;

- (void)addSound:(NSURL *) url atRadial:(NSInteger)radial andContentric:(NSInteger)concentric;

/* save and load profiles */
- (BOOL) saveProfile;
- loadFromURL:(NSURL*)url;

@end
