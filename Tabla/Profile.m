//
// File: Profile.m
// Authors: William Wetterston and Michael Xu
//
// Model for sound profile data
// Specifies the number of concentric rings and radial slices
// Contains a dictionary mapping sounds to zones
//

#import "Profile.h"

@implementation Profile

const NSInteger MIN_RADIAL = 1;
const NSInteger MAX_RADIAL = 8;
const NSInteger MIN_CONCENTRIC = 1;
const NSInteger MAX_CONCENTRIC = 4;

- (id)init {
    self = [super init];
    if(!self) return nil;
    
    // initialize variables
    self.concentric = 1;
    self.radial = 1;
    self.sounds = [[NSMutableDictionary alloc] init];
    
    // executes when user attempts to increment radial
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"TryIncrementRadial"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         // bounds check
         if(self.radial < MAX_RADIAL)
             // increment the value
             self.radial = self.radial + 1;
     }];
    
    // executes when user attempts to decrement radial
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"TryDecrementRadial"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         // bounds check
         if(self.radial > MIN_RADIAL)
             // decrement the value
             self.radial = self.radial - 1;
     }];
    
    // executes when user attempts to increment concentric
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"TryIncrementConcentric"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         // bounds check
         if(self.concentric < MAX_CONCENTRIC)
             // increment the value
             self.concentric = self.concentric + 1;
     }];
    
    // executes when user attempts to decrement concentric
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"TryDecrementConcentric"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         // bounds check
         if(self.concentric > MIN_CONCENTRIC)
             // decrement the value
             self.concentric = self.concentric - 1;
     }];
    
    return self;
}

// setter for concentric
- (void)setConcentric:(NSInteger)concentric {
    _concentric = concentric;
    // post a notification that concentric has been updated with the new value
    NSDictionary *userInfo = @{@"concentric": [NSNumber numberWithInteger:_concentric]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateConcentric"
     object:self
     userInfo:userInfo];
}

// setter for radial
- (void)setRadial:(NSInteger)radial {
    _radial = radial;
    // post a notification that radial has been updated with the new value
    NSDictionary *userInfo = @{@"radial": [NSNumber numberWithInteger:_radial]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateRadial"
     object:self
     userInfo:userInfo];
}

// returns the sound mapped to the zone
- (Sound *)soundForConcentric:(NSInteger)c andRadial:(NSInteger)r {
    return [self.sounds objectForKey:[self getHashForConcentric:c andRadial:r]];
}

// map the sound to the zone
- (void)setSound:(Sound *)s forConcentric:(NSInteger)c andRadial:(NSInteger)r {
    [self.sounds setObject:s forKey:[self getHashForConcentric:c andRadial:r]];
    // send a notification that a sound has been mapped to this zone
    // include the zone coordinates and RGB components of the color associated with the sound
    NSDictionary *userInfo = @{@"concentric": [NSNumber numberWithInteger:c],
                               @"radial": [NSNumber numberWithInteger:r],
                               @"red": [NSNumber numberWithFloat:s.color.redComponent],
                               @"green": [NSNumber numberWithFloat:s.color.greenComponent],
                               @"blue": [NSNumber numberWithFloat:s.color.blueComponent]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SetZone"
     object:self
     userInfo:userInfo];
}

// unmap sound from the zone
- (void)removeSoundForConcentric:(NSInteger)c andRadial:(NSInteger)r {
    [self.sounds removeObjectForKey:[self getHashForConcentric:c andRadial:r]];
    // send a notification that this zone has been cleared
    // include the zone coordinates
    NSDictionary *userInfo = @{@"concentric": [NSNumber numberWithInteger:c],
                               @"radial": [NSNumber numberWithInteger:r]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ClearZone"
     object:self
     userInfo:userInfo];
}

// unmap the sound from all zones
- (void)removeSound:(Sound *)sound {
    // loop through all possible zones
    for(int c = 1; c <= MAX_CONCENTRIC; c++) {
        for(int r = 1; r <= MAX_RADIAL; r++) {
            // check if sound matches the one to be removed
            if([self soundForConcentric:c andRadial:r].filepath == sound.filepath)
                [self removeSoundForConcentric:c andRadial:r];
        }
    }
}

// returns the a hash fro the zone
- (NSString *)getHashForConcentric:(NSInteger)c andRadial:(NSInteger)r {
    // uniquely maps up to 1000 radial zones
    return [NSString stringWithFormat:@"%ld", 1000 * c + r];
}

// returns a JSON representation of the profile data
- (NSString *) json {
    NSMutableDictionary* copy = [[NSMutableDictionary alloc] init];
    
    for (NSString* key in [self sounds]) {
        copy[key] = [[self sounds][key] toString];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:copy options:NSJSONWritingPrettyPrinted error:NULL];
    
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return NULL;
}

@end
