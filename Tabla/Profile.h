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

@property NSInteger radial;
@property NSInteger concentric;
@property (nonatomic, retain) NSMutableDictionary *sounds;

-(void)addSound:(NSURL *) url atRadial:(NSInteger)radial andContentric:(NSInteger)concentric;

@end
