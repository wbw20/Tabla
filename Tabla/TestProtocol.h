//
//  TestProtocol.h
//  Tabla
//
//  Created by Mike on 2/4/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestProtocol <NSObject>

@required
- (void)someMethod;

@optional
- (void)optionalMethod;

@end

[objectA someMethod];
