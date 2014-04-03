//
//  SoundView.h
//  Tabla
//
//  Created by Mike on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WindowController.h"

@interface SoundView : NSScrollView <NSDraggingDestination> {
    IBOutlet WindowController *windowController;
}

@end
