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

#define GOLDEN_RATIO_CONJUGATE 0.618033988749895

@synthesize soundData;
static NSString *DATA_FOLDER = @"/Tabla";
float hue;

- (id)init {
    Profile* model = [[Profile alloc] init];
    
    if ([super init]) {
        [self setProfile:model];
    }
    
    // set initial hue to a random value between 0 and 1
    hue = (float)rand()/RAND_MAX;
    
    // play a sound when a zone is clicked
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"ZoneClicked"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSInteger radial = [[[note userInfo] objectForKey:@"radial"] integerValue];
         NSInteger concentric = [[[note userInfo] objectForKey:@"concentric"] integerValue];
         // look for sound mapped to this zone
         Sound *s = [self.profile soundFor:radial andConcentric:concentric];
         // if there's a sound, play it
         if(s != nil) [s play];
     }];
    
    // unmap the sound when a zone is command clicked
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"ZoneCommandClicked"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSInteger radial = [[[note userInfo] objectForKey:@"radial"] integerValue];
         NSInteger concentric = [[[note userInfo] objectForKey:@"concentric"] integerValue];
         // look for sound mapped to this zone
         Sound *s = [self.profile soundFor:radial andConcentric:concentric];
         // if there's a sound, remove it
         if(s != nil) [self.profile removeSoundForConcentric:concentric andRadial:radial];
     }];
    
    // register NSNotification for dropping a sound on the pad or library
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"SoundDropped"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSInteger r = [[[note userInfo] objectForKey:@"radial"] integerValue];
         NSInteger c = [[[note userInfo] objectForKey:@"concentric"] integerValue];
         NSURL *f = [NSURL URLWithString:[[note userInfo] objectForKey:@"file"]];
         // create new sound from file
         Sound *s = [[Sound alloc] initWithPath:f andColor:[self nextColor]];
         // add sound to the library
         [self addSound:s];
         // if a zone coordinate is specified
         if(r > 0 && c > 0) {
             // assign sound to zone
             [self.profile setSound:s forConcentric:c andRadial:r];
             // save the profile
             [self saveProfile];
         }
     }];
    
    // register NSNotificaiton for dropping a color on the pad
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"ColorDropped"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSDictionary *ui = [note userInfo];
         NSInteger r = [[ui objectForKey:@"radial"] integerValue];
         NSInteger c = [[ui objectForKey:@"concentric"] integerValue];
         float red = [[ui objectForKey:@"red"] floatValue];
         float green = [[ui objectForKey:@"green"] floatValue];
         float blue = [[ui objectForKey:@"blue"] floatValue];
         // find the sound with matching color
         for(Sound *s in soundData) {
             NSColor *sColor = s.color;
             float dr = fabsf(red - sColor.redComponent);
             float dg = fabsf(green - sColor.greenComponent);
             float db = fabsf(blue - sColor.blueComponent);
             // set the sound for specified zone
             if(dr < 0.00001f && dg < 0.00001f && db < 0.00001f)
                 [self.profile setSound:s forConcentric:c andRadial:r];
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

- (void)closeSound:(Sound *)s {
    // unmap all zones with this sound
    [self.profile removeSound:s];
    // remove the sound from library
    [soundData removeObject:s];
    [soundController removeObject:s];
}

// returns next color in the sequence
- (NSColor *)nextColor {
    hue += GOLDEN_RATIO_CONJUGATE;
    hue = fmodf(hue, 1.0f);
    NSColor *hsb = [NSColor colorWithHue:hue saturation:0.3f brightness:0.99f alpha:1.0f];
    NSColor *rgb = [NSColor colorWithRed:hsb.redComponent green:hsb.greenComponent blue:hsb.blueComponent alpha:1.0f];
    return rgb;
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
