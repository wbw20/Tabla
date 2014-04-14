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

- (Sound*)soundFor:(NSInteger)radial andConcentric:(NSInteger)concentric {
    return [self sounds][[self hash:radial andConcentric:concentric]];
}

-(void)addSound:(NSURL *) url atRadial:(NSInteger)radial andContentric:(NSInteger)concentric {
    [self sounds][[self hash:radial andConcentric:concentric]] = [[Sound alloc] initWithPath:url];
}

- (NSString*) hash:(NSInteger)radial andConcentric:(NSInteger)concentric {
    return [NSString stringWithFormat:@"%ld", ((1000 * radial) + concentric)]; // uniquely maps up to 1000 radial zones
}

@end
