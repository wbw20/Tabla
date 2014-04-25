//
//  WindowController.h
//  Tabla
//
//  Created by William Wettersten on 4/3/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Profile.h"
#import "Sound.h"

@interface WindowController : NSWindowController {
    NSMutableArray *soundData;
}

@property(nonatomic, retain) Profile *profile;
@property(nonatomic, retain) NSMutableArray *soundData;

- (void)addSound:(Sound *)url;
- (void)insertObject:(Sound *)s inSoundDataAtIndex:(NSInteger)index;
- (void)removeObjectFromSoundDataAtIndex:(NSInteger)index;
- (void)setSoundData:(NSMutableArray *) a;
- (NSArray *)soundData;

/* save and load profiles */
- (BOOL) saveProfile;
- loadFromURL:(NSURL*)url;

@end
