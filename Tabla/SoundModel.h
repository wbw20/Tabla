//
//  SoundModel.h
//  Tabla
//
//  Created by Mike on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundModel : NSObject {
    NSString * name;
    NSURL * filepath;
}
@property(retain, readwrite) NSString * name;
@property(retain, readwrite) NSURL * filepath;
@end
