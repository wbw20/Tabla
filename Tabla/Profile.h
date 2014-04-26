//
// File: Profile.h
// Authors: William Wetterston and Michael Xu
//
// Model for sound profile data
// Specifies the number of concentric rings and radial slices
// Contains a dictionary mapping sounds to zones
//

#import <Foundation/Foundation.h>

#import "Sound.h"

@interface Profile : NSObject

@property (nonatomic, readonly) NSInteger concentric;
@property (nonatomic, readonly) NSInteger radial;
@property (nonatomic, retain) NSMutableDictionary *sounds;

extern const NSInteger MIN_CONCENTRIC;
extern const NSInteger MAX_CONCENTRIC;
extern const NSInteger MIN_RADIAL;
extern const NSInteger MAX_RADIAL;

// returns the sound mapped to the zone
- (Sound*)soundForConcentric:(NSInteger)c andRadial:(NSInteger)r;

// maps the sound to the zone
- (void)setSound:(Sound *)s forConcentric:(NSInteger)c andRadial:(NSInteger)r;

// unmap the sound from the zone
- (void)removeSoundForConcentric:(NSInteger)c andRadial:(NSInteger)r;

// unmap the sound from all zones
- (void)removeSound:(Sound *)sound;

// converts profile data into a JSON representation
- (NSString*)json;

@end
