//
// File: SoundView.h
// Authors: Michael Xu
//
// View containing the sound library
//

#import <Cocoa/Cocoa.h>
#import "WindowController.h"

@interface SoundView : NSScrollView <NSDraggingDestination> {
    IBOutlet WindowController *windowController;
}

@end
