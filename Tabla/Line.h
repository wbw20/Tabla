//
//  Line.h
//  Tabla
//
//  Created by William Wettersten on 2/16/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject

@property NSPoint start;
@property NSPoint end;

- (id)initWithStart:(NSPoint)start andEnd:(NSPoint)end;
- (float)slope;

@end
