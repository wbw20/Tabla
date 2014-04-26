//
//  Profile.m
//  Tabla
//
//  Created by William Wettersten on 2/26/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "Profile.h"

@implementation Profile

const NSInteger MIN_RADIAL = 1;
const NSInteger MAX_RADIAL = 8;
const NSInteger MIN_CONCENTRIC = 1;
const NSInteger MAX_CONCENTRIC = 4;

- (id) init {
    self = [super init];
    if(!self) return nil;
    
    self.concentric = 1;
    self.radial = 1;
    self.sounds = [[NSMutableDictionary alloc] init];
    
    // register NSNotification for trying to update radial
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"TryIncrementRadial"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         if(self.radial < MAX_RADIAL)
             self.radial = self.radial + 1;
     }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"TryDecrementRadial"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         if(self.radial > MIN_RADIAL)
             self.radial = self.radial - 1;
     }];
    
    // register NSNotifications for trying to update concentric
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"TryIncrementConcentric"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         if(self.concentric < MAX_CONCENTRIC)
             self.concentric = self.concentric + 1;
     }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"TryDecrementConcentric"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         if(self.concentric > MIN_CONCENTRIC)
             self.concentric = self.concentric - 1;
     }];

    return self;
}

- (void)setConcentric:(NSInteger)concentric {
    _concentric = concentric;
    // send a notification that concentric has been updated and the new value
    NSDictionary *userInfo = @{@"concentric": [NSNumber numberWithInteger:_concentric]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateConcentric"
     object:self
     userInfo:userInfo];
}

- (void)setRadial:(NSInteger)radial {
    _radial = radial;
    // send a notification that radial has been updated and the new value
    NSDictionary *userInfo = @{@"radial": [NSNumber numberWithInteger:_radial]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateRadial"
     object:self
     userInfo:userInfo];
}

- (Sound*)soundFor:(NSInteger)r andConcentric:(NSInteger)c {
    return [self.sounds objectForKey:[self getHashForConcentric:c andRadial:r]];
}

- (void)setSound:(Sound *)s forConcentric:(NSInteger)c andRadial:(NSInteger)r {
    [self.sounds setObject:s forKey:[self getHashForConcentric:c andRadial:r]];
    // send a notification that a sound has been mapped to this zone
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

- (void)removeSoundForConcentric:(NSInteger)c andRadial:(NSInteger)r {
    [self.sounds removeObjectForKey:[self getHashForConcentric:c andRadial:r]];
    // send a notification that this zone has been cleared
    NSDictionary *userInfo = @{@"concentric": [NSNumber numberWithInteger:c],
                               @"radial": [NSNumber numberWithInteger:r]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ClearZone"
     object:self
     userInfo:userInfo];
}

- (void)removeSound:(Sound *)sound {
    // loop through all possible zones
    for(int c = 1; c <= MAX_CONCENTRIC; c++) {
        for(int r = 1; r <= MAX_RADIAL; r++) {
            // check if sound matches the one to be removed
            if([self soundFor:r andConcentric:c].filepath == sound.filepath)
                [self removeSoundForConcentric:c andRadial:r];
        }
    }
}

- (NSString*)getHashForConcentric:(NSInteger)c andRadial:(NSInteger)r {
    // uniquely maps up to 1000 radial zones
    return [NSString stringWithFormat:@"%ld", 1000 * c + r];
}

- (NSString*) json {
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
