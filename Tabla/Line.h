//
//  Line.h
//  Tabla
//
//  Created by William Wettersten on 2/16/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject

@property CGPoint start;
@property CGPoint end;

+ (float)getTranslationFor:(Line*)line andKerf:(float)kerf;
+ (Line*)getTranslatedLineFor:(Line*)line andTranslation:(float)translation;

- (id)initWithStart:(NSPoint)start andEnd:(NSPoint)end;
- (float)slope;
- (float)offset;
- (BOOL)equals:(Line*)other;

@end
