//
// File: WindowController.h
// Authors: William Wetterston and Michael Xu
//
// Main Controller for the entire application
// - adding and removing sounds from library
// - mapping and unmapping sounds from zones
//

#import "WindowController.h"
#import "AppDelegate.h"

@implementation WindowController

// golden ratio angle used for generating unique random colors
#define GOLDEN_RATIO_CONJUGATE 0.618033988749895

@synthesize soundData;
static NSString *DATA_FOLDER = @"/Tabla";
// hue value to use for next color
float hue;

- (id)init {
    if (![super init]) return nil;

    // initialize the profile data
    Profile* model = [[Profile alloc] init];
    [self setProfile:model];
    
    // set initial hue to a random value between 0 and 1
    hue = (float)rand()/RAND_MAX;
    
    // play a sound when a zone is clicked
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"ZoneClicked"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSInteger r = [[[note userInfo] objectForKey:@"radial"] integerValue];
         NSInteger c = [[[note userInfo] objectForKey:@"concentric"] integerValue];
         // look for sound mapped to this zone
         Sound *s = [self.profile soundForConcentric:c andRadial:r];
         // if there's a sound, play it
         if(s != nil) [s play];
     }];
    
    // unmap the sound when a zone is command clicked
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"ZoneCommandClicked"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSInteger c = [[[note userInfo] objectForKey:@"concentric"] integerValue];
         NSInteger r = [[[note userInfo] objectForKey:@"radial"] integerValue];
         // look for sound mapped to this zone
         Sound *s = [self.profile soundForConcentric:c andRadial:r];
         // if there's a sound, remove it
         if(s != nil) [self.profile removeSoundForConcentric:c andRadial:r];
     }];
    
    // listen to notification for dropping a sound on the pad or library
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
         BOOL added = [self addSound:s];
         // if a sound was successfully added, and a zone coordinate is specified
         if(added && r > 0 && c > 0) {
             // assign sound to zone
             [self.profile setSound:s forConcentric:c andRadial:r];
             // save the profile
             [self saveProfile];
         }
     }];
    
    // listen to notification for dropping a color on the pad
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
             // set the sound for specified zone if it matches
             if(dr < 0.00001f && dg < 0.00001f && db < 0.00001f)
                 [self.profile setSound:s forConcentric:c andRadial:r];
         }
     }];
    
    return self;
}

// returns next color in the sequence
- (NSColor *)nextColor {
    // increment hue by the golden ratio
    hue += GOLDEN_RATIO_CONJUGATE;
    // modulo 1 to keep it in range
    hue = fmodf(hue, 1.0f);
    // generate the color in HSB space
    return [NSColor colorWithHue:hue saturation:0.5f brightness:0.8f alpha:1.0f];;
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

// KV compliance methods for modifying the sound array
- (void)insertObject:(Sound *)s inSoundDataAtIndex:(NSInteger)index {
    [soundData insertObject:s atIndex:index];
}

- (void)removeObjectFromSoundDataAtIndex:(NSInteger)index {
    [soundData removeObjectAtIndex:index];
}

- (void)setSoundData:(NSMutableArray *)a {
    soundData = a;
}

// add a sound to the library, returns YES if successful or NO if not
- (BOOL)addSound:(Sound *)s {
    // return NO if a sound already exists for this file
    for(Sound *a in soundData)
        if([a.filepath.absoluteString isEqualToString:s.filepath.absoluteString])
            return NO;
    // insert it into the array
    NSMutableArray *tempData = [NSMutableArray arrayWithArray:soundData];
    [tempData addObject:s];
    [self setSoundData:tempData];
    return YES;
}

// remove a sound from the library
- (void)removeSound:(Sound *)s {
    // unmap all zones with this sound
    [self.profile removeSound:s];
    // remove the sound from library
    [soundData removeObject:s];
    // update the view
    [soundController removeObject:s];
}

- (NSArray *)soundData {
    return soundData;
}

@end
