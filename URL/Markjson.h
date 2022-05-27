//
//  Markjson.h
//  movie
//
//  Created by Ian1 on 2014/6/26.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarkHelp.h"
#import "TFHpple.h"

#define MARK_QUERY_URL @"https://tw.movies.yahoo.com/movie_thisweek.html"

#define MARK_QUERY_URL1 @"https://tw.movies.yahoo.com/movie_comingsoon.html"

#define MARK_QUERY_URL2 @"https://tw.movies.yahoo.com/movie_intheaters.html"

#define MARK_QUERY_URL3 @"https://tw.movies.yahoo.com/theater_list.html"

#define MARK_QUERY_URL4 @"https://tw.movies.yahoo.com/theater_list.html"

#define MARK_QUERY_URL5 @"https://tw.movies.yahoo.com/theater_result.html"

#define MARK_QUERY_URL6 @"https://tw.movies.yahoo.com/movieinfo_main.html"

#define MARK_QUERY_URL7 @"https://tw.movies.yahoo.com/movietime_result.html"

#define MARK_QUERY_URL8 @"https://tw.movies.yahoo.com/movieinfo_trailer.html"

#define MARK_QUERY_URL9 @"https://tw.movies.yahoo.com/movieinfo_main.html"

#define MARK_QUERY_URL10 @"https://tw.movies.yahoo.com/movieinfo_review.html/id="

@interface Markjson : NSObject

+ (Markjson*)sharedManager;

-(void)selectKey:(NSDictionary*)mark;

-(void)selectKey1:(NSDictionary*)mark;

-(void)selectKey2:(NSDictionary*)mark;

-(void)selectKey3:(NSDictionary*)mark;

-(void)selectKey4:(NSDictionary*)mark;

-(void)selectKey5:(NSDictionary*)mark;

-(void)selectKey6:(NSDictionary*)mark;

-(void)selectKey7:(NSDictionary*)mark;

-(void)selectKey8:(NSDictionary*)mark;

-(void)selectKey9:(NSDictionary*)mark;

-(void)selectKey10:(NSDictionary*)mark;

-(void)selectKey11:(NSDictionary*)mark;

@end
