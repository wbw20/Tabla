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
    
    NSLog(@"Init Window Controller");
    
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
    
    // register NSNotificaiton for dropping a color
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"ColorDropped"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSDictionary *ui = [note userInfo];
         NSInteger r = [[ui objectForKey:@"radial"] integerValue];
         NSInteger c = [[ui objectForKey:@"concentric"] integerValue];
         // NSData *data = [[[note userInfo] objectForKey:@"color"] data];
         float red = [[ui objectForKey:@"red"] floatValue];
         float green = [[ui objectForKey:@"green"] floatValue];
         float blue = [[ui objectForKey:@"blue"] floatValue];
         for(Sound *s in soundData) {
             NSColor *sColor = s.color;
             if(sColor.redComponent == red &&
                sColor.greenComponent == green &&
                sColor.blueComponent == blue) {
                 [self.profile setSound:s forConcentric:c andRadial:r];
             }
         }
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
