//
//  WindowController.m
//  Tabla
//
//  Created by William Wettersten on 4/3/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "WindowController.h"
#import "AppDelegate.h"

@implementation WindowController

static NSString *DATA_FOLDER = @"/Tabla";

/*
 *  Default constructor uses a new profile
 */
- (id) init {
    Profile* model = [[Profile alloc] init];

    if ([super init]) {
        [self setProfile:model];
    }
    
    return self;
}

- (id) initWithProfile:(Profile*)model {
    if ([super init]) {
        [self setProfile:model];
    }

    return self;
}

- (void)addSound:(NSURL *) url atRadial:(NSInteger)radial andContentric:(NSInteger)concentric {
    [[self profile] addSound:url atRadial:radial andContentric:concentric];
    [self saveProfile];
}

- (BOOL)playSoundForRadial:(NSInteger)radial andConcentric:(NSInteger)concentric {
    return [[[self profile] soundFor:radial andConcentric:concentric] play];
}

- (NSInteger) radial {
    return [[self profile] radial];
}

- (void) setRadial:(NSInteger)radial {
    [[self profile] setRadial:radial];
    NSLog(@"Set Radial");
    NSDictionary *userInfo = @{@"radial": [NSNumber numberWithInteger:radial]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateRadialNotification" object:self userInfo:userInfo];
}

- (NSInteger) concentric {
    return [[self profile] concentric];
}

- (void) setConcentric:(NSInteger)concencric {
    [[self profile] setConcentric:concencric];
}

/*
 *  If ~/Library/Application Support/Tabla does not exist, it creates it and returns the name
 */
- (NSString*) findOrCreateDataFolder {
    NSString *folder = [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                        stringByAppendingString:DATA_FOLDER];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];

        if (error) {
            return NULL;
        }
    }
    
    return folder;
}

- (BOOL) saveProfile {
    return [[[self profile] json] writeToFile:[[self findOrCreateDataFolder] stringByAppendingPathComponent:@"test.json"] atomically:YES
                       encoding:NSUTF8StringEncoding error:NULL];
}

- loadFromURL:(NSURL*)url {
    return NULL;
}

@end
