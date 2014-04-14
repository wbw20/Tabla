//
//  SoundModel.m
//  Tabla
//
//  Created by Mike on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "Sound.h"

@implementation Sound

- (id) initWithPath:(NSURL*)filepath {
    if ([super initWithContentsOfFile:[filepath path] byReference:YES]) {
        // nothing for now
    }

    return self;
}

- (id) initWithString:(NSString *)json {
    NSArray* values = [json componentsSeparatedByString:@":"];

    if ([super initWithContentsOfFile:values[1] byReference:YES]) {
        [self setName:values[0]];
    }
    
    return self;
}

- (NSString*) toString {
    return [NSString stringWithFormat:@"%@:%@", [self name], [[self filepath] path]];
}

@end
