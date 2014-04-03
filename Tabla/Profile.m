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
    }
    
    return self;
}

- (NSSound*) soundFor:(NSNumber*)address {
    return [self.samples objectForKey:(address)];
}

-(void)addSound:(NSURL *) url {
    Sound *s = [[Sound alloc] initWithPath:url];
}

@end
