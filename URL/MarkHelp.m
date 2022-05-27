//
//  MarkHelp.m
//  Mark
//
//  Created by User on 13/9/8.
//  Copyright (c) 2013年 classroomM. All rights reserved.
//

#import "MarkHelp.h"

@implementation MarkHelp

+(NSString *)URLEncodedString:(NSString *)str
{
    NSString *result = ( NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              CFSTR("!*();+$,%#[] "),
                                                              kCFStringEncodingUTF8));
    return result;
}

@end
