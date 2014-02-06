//
//  AppDelegate.m
//  Tabla
//
//  Created by William Wettersten on 1/31/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "AppDelegate.h"

#define aConstant 5

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    char *cString = "A C String";
    NSString *objString = @"Objective C String";
    
    NSString *objStringFromCString = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
    
    // String string1 = new String();
    // string1.someMethod(1, "some strimg");
    
    
    
//    NSString *string1 = [NSString alloc];
//    string1 = [string1 init];
//    
//    NSString *string2 = [NSString new];

    NSString *someString = [self someString];
    NSLog(@"someString: %@", someString);
    
    NSString *stringFromInt __unused = [self stringWithInt:1];
    
    NSString *anotherStringFromInt = [self performSelector:@selector(anotherMethod)];
    NSString *stringFromIntAndFloat __unused = [self stringWithInt:1 floatValue:1.5];
}

- (NSString *)someString {
    return @"some string";
}

- (NSString *)stringWithInt:(NSInteger)integerValue {
    NSString *string = [NSString stringWithFormat:@"%ld", integerValue];
    return string;
}

- (NSString *)stringWithInt:(NSInteger)integerValue floatValue:(float)floatValue {
    return [NSString stringWithFormat:@"%ld %f", integerValue, floatValue];
    
    // stringWithInt:float:
    
    // - = instance method
    // (NSString *) - return type
    // stringWithInt:float: - method name
    // float: parameter name
    
    
}

@end
