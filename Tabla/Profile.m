//
//  Profile.m
//  Tabla
//
//  Created by William Wettersten on 2/26/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "Profile.h"

@implementation Profile

- (id) init {
    self = [super init];
    
    if (self) {
        [self setConcentric:1];
        [self setRadial:1];
        [self setSounds:[[NSMutableDictionary alloc] init]];
    }
    
    return self;
}

- (NSSound*) soundFor:(NSNumber*)address {
    return [self.sounds objectForKey:(address)];
}

- (NSInteger) hash:(NSInteger)radial andConcentric:(NSInteger)concentric {
    return (1000 * radial) + concentric; // uniquely maps up to 1000 radial zones
}

-(void)addSound:(NSURL *) url atRadial:(NSInteger)radial andContentric:(NSInteger)concentric {
    [self sounds][@([self hash:radial andConcentric:concentric])] = [[Sound alloc] initWithPath:url];
}

@end
