//
//  Profile.h
//  Tabla
//
//  Created by William Wettersten on 2/26/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sound.h"

@interface Profile : NSObject

@property (nonatomic, readonly) NSInteger radial;
@property (nonatomic, readonly) NSInteger concentric;
@property (nonatomic, retain) NSMutableDictionary *sounds;

extern const NSInteger MIN_RADIAL;
extern const NSInteger MAX_RADIAL;
extern const NSInteger MIN_CONCENTRIC;
extern const NSInteger MAX_CONCENTRIC;

- (Sound*)soundFor:(NSInteger)radial andConcentric:(NSInteger)concentric;
- (void) addSound:(NSURL *) url atRadial:(NSInteger)radial andContentric:(NSInteger)concentric;
- (NSString*) json;

@end
