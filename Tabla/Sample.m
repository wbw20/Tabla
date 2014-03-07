//
//  Sample.m
//  Tabla
//
//  Created by William Wettersten on 2/26/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "Sample.h"

@implementation Sample

- (id)initWithPath:(NSString*)path {
    self = [super init];
    
    if (self) {
        [self setPath:path];
    }

    return self;
}

@end
