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

@synthesize soundData;
static NSString *DATA_FOLDER = @"/Tabla";

- (id)init {
    Profile* model = [[Profile alloc] init];

    if ([super init]) {
        [self setProfile:model];
    }
    
    // register NSNotification for playing a sound
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"ZoneClicked"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSInteger radial = [[[note userInfo] objectForKey:@"radial"] integerValue];
         NSInteger concentric = [[[note userInfo] objectForKey:@"concentric"] integerValue];
         Sound *s = [self.profile soundFor:radial andConcentric:concentric];
         if(s != nil) [s play];
     }];
    
    // register NSNotification for dropping a sound
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"SoundDropped"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSInteger r = [[[note userInfo] objectForKey:@"radial"] integerValue];
         NSInteger c = [[[note userInfo] objectForKey:@"concentric"] integerValue];
         NSURL *f = [NSURL URLWithString:[[note userInfo] objectForKey:@"file"]];
         // create new sound from file
         Sound *s = [[Sound alloc] initWithPath:f];
         // add sound to the library
         [self addSound:s];
         // assign sound to zone
         [self.profile setSound:s forConcentric:c andRadial:r];
         // save the profile
         [self saveProfile];
     }];
    
    return self;
}

- (id)initWithProfile:(Profile*)model {
    if ([super init]) {
        [self setProfile:model];
    }

    return self;
}

/*
 *  If ~/Library/Application Support/Tabla does not exist, it creates it and returns the name
 */
- (NSString*)findOrCreateDataFolder {
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

- (BOOL)saveProfile {
    return [[[self profile] json] writeToFile:[[self findOrCreateDataFolder] stringByAppendingPathComponent:@"test.json"] atomically:YES
                       encoding:NSUTF8StringEncoding error:NULL];
}

- loadFromURL:(NSURL*)url {
    return NULL;
}

#pragma mark - Sound Library

- (void)insertObject:(Sound *)s inSoundDataAtIndex:(NSInteger)index {
    [soundData insertObject:s atIndex:index];
}

- (void)removeObjectFromSoundDataAtIndex:(NSInteger)index {
    [soundData removeObjectAtIndex:index];
}

- (void)setSoundData:(NSMutableArray *)a {
    soundData = a;
}

- (void)addSound:(Sound *)s {
    NSMutableArray *tempData = [NSMutableArray arrayWithArray:soundData];
    [tempData addObject:s];
    [self setSoundData:tempData];
}

- (NSArray *)soundData {
    return soundData;
}

@end
