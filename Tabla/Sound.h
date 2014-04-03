//
//  SoundModel.h
//  Tabla
//
//  Created by Mike on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sound : NSObject

@property NSString * name;
@property NSURL * filepath;

- (id) initWithPath:(NSURL*)path;

@end
