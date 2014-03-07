//
//  SoundModel.h
//  Tabla
//
//  Created by Mike on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sound : NSObject {
    NSString * name;
    NSURL * filepath;
}
@property(retain, readwrite) NSString * name;
@property(retain, readwrite) NSURL * filepath;
@end
