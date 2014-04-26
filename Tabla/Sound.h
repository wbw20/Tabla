//
//  SoundModel.h
//  Tabla
//
//  Created by Mike on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sound : NSSound

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSURL *filepath;
@property(nonatomic, retain) NSColor *color;

- (id) initWithPath:(NSURL*)url;
- (id) initWithPath:(NSURL*)url andColor:(NSColor*)color;
- (NSString*) toString;

@end
