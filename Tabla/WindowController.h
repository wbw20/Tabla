//
// File: WindowController.h
// Authors: William Wetterston and Michael Xu
//
// Main Controller for the entire application
// - adding and removing sounds from library
// - mapping and unmapping sounds from zones
//

#import <Cocoa/Cocoa.h>
#import "Profile.h"
#import "Sound.h"

@interface WindowController : NSWindowController {
    // reference to array controller for sound collection view
    IBOutlet NSArrayController *soundController;
}

// profile data object to manipulate
@property(nonatomic, retain) Profile *profile;
// array of sound data objects that make up the library
@property(nonatomic, retain) NSMutableArray *soundData;

// add a sound to the library
- (BOOL)addSound:(Sound *)s;

// remove a sound from the library
- (void)removeSound:(Sound *)s;

// functions for manipulating the sound array for xcode KV compliance
- (void)insertObject:(Sound *)s inSoundDataAtIndex:(NSInteger)index;
- (void)removeObjectFromSoundDataAtIndex:(NSInteger)index;
- (void)setSoundData:(NSMutableArray *) a;
- (NSArray *)soundData;

/* save and load profiles */
- (BOOL) saveProfile;
- (void)loadProfile:(NSURL*)url;

@end
