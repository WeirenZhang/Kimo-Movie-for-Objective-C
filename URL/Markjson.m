//
//  Markjson.m
//  movie
//
//  Created by Ian1 on 2014/6/26.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "Markjson.h"

@implementation Markjson

static Markjson *sharedManager = nil;

+ (Markjson*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)selectKey:(NSDictionary*)mark
{
    NSURL *url = [NSURL URLWithString:[MARK_QUERY_URL stringByAppendingFormat:@"?page=%@", [mark objectForKey:@"currentPage"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    // set GET or POST method
    [request setHTTPMethod:@"GET"];
    // adding keys with values
    //NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"p=%@", [mark objectForKey:@"currentPage"]]];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   
                                   NSString* newStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@""withString:@""];
                                   //NSLog(@"字串==%@",newStr);
                                   
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   
                                   NSString *contributorsXpathQueryString = @"//ul[@class='release_list']/li";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   NSLog(@"movie_thisweek array count==%lu",(unsigned long)contributorsNodes.count);
                                   for (TFHppleElement *element in contributorsNodes) {
                                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                       
                                       NSArray *AElements = [element searchWithXPathQuery:@"//img"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           if ([child objectForKey:@"src"] != nil) {
                                               [parameters setObject:[child objectForKey:@"src"] forKey:@"image"];
                                               NSLog(@"%@", [child objectForKey:@"src"]);
                                           } else {
                                               [parameters setObject:[child objectForKey:@"data-src"] forKey:@"image"];
                                               NSLog(@"%@", [child objectForKey:@"data-src"]);
                                           }
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//a"];
                                       for (TFHppleElement *child in AElements) {
                                           NSArray *myWords = [[child objectForKey:@"href"] componentsSeparatedByString:@"-"];
                                           NSLog(@"%@", [myWords objectAtIndex:(myWords.count - 1)]);
                                           [parameters setObject:[myWords objectAtIndex:(myWords.count - 1)] forKey:@"id"];
                                           
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           //[parameters setObject:[child objectForKey:@"href"] forKey:@"image"];
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                           break;
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='release_movie_name']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           NSLog(@"%@", [[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]);
                                           [parameters setObject:[[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:@"chinese_name"];
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='en']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           if ([child text] != nil) {
                                               NSLog(@"%@", [[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]);
                                               [parameters setObject:[[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:@"english_name"];
                                           }
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='release_movie_time']"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           NSLog(@"%@", [child text]);
                                           [parameters setObject:[self convertHTML:child.raw] forKey:@"release_date"];
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       /*
                                        NSArray *AElements1 = [element searchWithXPathQuery:@"//h5/a"];
                                        for (TFHppleElement *child1 in AElements1) {
                                        NSString *english_name;
                                        if ([child1 text] == nil) {
                                        english_name = @"";
                                        } else {
                                        english_name = [child1 text];
                                        }
                                        [parameters setObject:english_name forKey:@"english_name"];
                                        }
                                        NSArray *AElements2 = [element searchWithXPathQuery:@"//span/span"];
                                        for (TFHppleElement *child2 in AElements2) {
                                        //NSLog(@"%@", [child2 text]);
                                        [parameters setObject:[child2 text] forKey:@"release_date"];
                                        }
                                        
                                        NSArray *AElements3 = [element searchWithXPathQuery:@"//ul[@class='links clearfix']/li/a"];
                                        NSString* string;
                                        int i = 0;
                                        for (TFHppleElement *child3 in AElements3) {
                                        if ([[child3 text] isEqual: @"預告片"]) {
                                        [parameters setObject:[child3 objectForKey:@"href"] forKey:@"trailer_url"];
                                        }
                                        if (i == 0) {
                                        string = [child3 text];
                                        } else {
                                        string = [NSString stringWithFormat:@"%@&%@",string,[child3 text]];
                                        }
                                        i++;
                                        }
                                        [parameters setObject:string forKey:@"menu"];
                                        //NSLog(@"%@", string);
                                        */
                                       
                                       [list addObject:parameters];
                                   }
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification"
                                                                                       object: list];
                                   
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification"                                                            object: nil];
                               }
                           }];
}

-(void)selectKey1:(NSDictionary*)mark
{
    NSURL *url = [NSURL URLWithString:[MARK_QUERY_URL1 stringByAppendingFormat:@"?page=%@", [mark objectForKey:@"currentPage"]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    // set GET or POST method
    [request setHTTPMethod:@"GET"];
    // adding keys with values
    //NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"p=%@", [mark objectForKey:@"currentPage"]]];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   
                                   NSString* newStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@""withString:@""];
                                   //NSLog(@"字串==%@",newStr);
                                   
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   
                                   NSString *contributorsXpathQueryString = @"//ul[@class='release_list']/li";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   NSLog(@"movie_thisweek array count==%lu",(unsigned long)contributorsNodes.count);
                                   for (TFHppleElement *element in contributorsNodes) {
                                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                       
                                       NSArray *AElements = [element searchWithXPathQuery:@"//img"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           if ([child objectForKey:@"src"] != nil) {
                                               [parameters setObject:[child objectForKey:@"src"] forKey:@"image"];
                                               NSLog(@"%@", [child objectForKey:@"src"]);
                                           } else {
                                               [parameters setObject:[child objectForKey:@"data-src"] forKey:@"image"];
                                               NSLog(@"%@", [child objectForKey:@"data-src"]);
                                           }
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//a"];
                                       for (TFHppleElement *child in AElements) {
                                           NSArray *myWords = [[child objectForKey:@"href"] componentsSeparatedByString:@"-"];
                                           NSLog(@"%@", [myWords objectAtIndex:(myWords.count - 1)]);
                                           [parameters setObject:[myWords objectAtIndex:(myWords.count - 1)] forKey:@"id"];
                                           
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           //[parameters setObject:[child objectForKey:@"href"] forKey:@"image"];
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                           break;
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='release_movie_name']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           NSLog(@"%@", [[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]);
                                           [parameters setObject:[[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:@"chinese_name"];
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='en']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           if ([child text] != nil) {
                                               NSLog(@"%@", [[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]);
                                               [parameters setObject:[[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:@"english_name"];
                                           }
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='release_movie_time']"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           NSLog(@"%@", [child text]);
                                           [parameters setObject:[self convertHTML:child.raw] forKey:@"release_date"];
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       /*
                                        NSArray *AElements1 = [element searchWithXPathQuery:@"//h5/a"];
                                        for (TFHppleElement *child1 in AElements1) {
                                        NSString *english_name;
                                        if ([child1 text] == nil) {
                                        english_name = @"";
                                        } else {
                                        english_name = [child1 text];
                                        }
                                        [parameters setObject:english_name forKey:@"english_name"];
                                        }
                                        NSArray *AElements2 = [element searchWithXPathQuery:@"//span/span"];
                                        for (TFHppleElement *child2 in AElements2) {
                                        //NSLog(@"%@", [child2 text]);
                                        [parameters setObject:[child2 text] forKey:@"release_date"];
                                        }
                                        
                                        NSArray *AElements3 = [element searchWithXPathQuery:@"//ul[@class='links clearfix']/li/a"];
                                        NSString* string;
                                        int i = 0;
                                        for (TFHppleElement *child3 in AElements3) {
                                        if ([[child3 text] isEqual: @"預告片"]) {
                                        [parameters setObject:[child3 objectForKey:@"href"] forKey:@"trailer_url"];
                                        }
                                        if (i == 0) {
                                        string = [child3 text];
                                        } else {
                                        string = [NSString stringWithFormat:@"%@&%@",string,[child3 text]];
                                        }
                                        i++;
                                        }
                                        [parameters setObject:string forKey:@"menu"];
                                        //NSLog(@"%@", string);
                                        */
                                       
                                       [list addObject:parameters];
                                   }
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification1"
                                                                                       object: list];
                                   
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification1"                                                            object: nil];
                               }
                           }];
}

-(void)selectKey2:(NSDictionary*)mark
{
    NSURL *url = [NSURL URLWithString:[MARK_QUERY_URL2 stringByAppendingFormat:@"?page=%@", [mark objectForKey:@"currentPage"]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    // set GET or POST method
    [request setHTTPMethod:@"GET"];
    // adding keys with values
    //NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"p=%@", [mark objectForKey:@"currentPage"]]];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   
                                   NSString* newStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@""withString:@""];
                                   //NSLog(@"字串==%@",newStr);
                                   
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   
                                   NSString *contributorsXpathQueryString = @"//ul[@class='release_list']/li";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   NSLog(@"movie_thisweek array count==%lu",(unsigned long)contributorsNodes.count);
                                   for (TFHppleElement *element in contributorsNodes) {
                                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                       
                                       NSArray *AElements = [element searchWithXPathQuery:@"//img"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           if ([child objectForKey:@"src"] != nil) {
                                               [parameters setObject:[child objectForKey:@"src"] forKey:@"image"];
                                               NSLog(@"%@", [child objectForKey:@"src"]);
                                           } else {
                                               [parameters setObject:[child objectForKey:@"data-src"] forKey:@"image"];
                                               NSLog(@"%@", [child objectForKey:@"data-src"]);
                                           }
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//a"];
                                       for (TFHppleElement *child in AElements) {
                                           NSArray *myWords = [[child objectForKey:@"href"] componentsSeparatedByString:@"-"];
                                           NSLog(@"%@", [myWords objectAtIndex:(myWords.count - 1)]);
                                           [parameters setObject:[myWords objectAtIndex:(myWords.count - 1)] forKey:@"id"];
                                           
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           //[parameters setObject:[child objectForKey:@"href"] forKey:@"image"];
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                           break;
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='release_movie_name']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           NSLog(@"%@", [[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]);
                                           [parameters setObject:[[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:@"chinese_name"];
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='en']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           if ([child text] != nil) {
                                               NSLog(@"%@", [[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]);
                                               [parameters setObject:[[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:@"english_name"];
                                           }
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='release_movie_time']"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"%@", [child objectForKey:@"src"]);
                                           //NSLog(@"%@", [child objectForKey:@"title"]);
                                           
                                           NSLog(@"%@", [child text]);
                                           [parameters setObject:[self convertHTML:child.raw] forKey:@"release_date"];
                                           
                                           //[parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
                                           //NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                           //NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           //NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                           //NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                           //[parameters setObject:ichar1 forKey:@"id"];
                                       }
                                       
                                       /*
                                        NSArray *AElements1 = [element searchWithXPathQuery:@"//h5/a"];
                                        for (TFHppleElement *child1 in AElements1) {
                                        NSString *english_name;
                                        if ([child1 text] == nil) {
                                        english_name = @"";
                                        } else {
                                        english_name = [child1 text];
                                        }
                                        [parameters setObject:english_name forKey:@"english_name"];
                                        }
                                        NSArray *AElements2 = [element searchWithXPathQuery:@"//span/span"];
                                        for (TFHppleElement *child2 in AElements2) {
                                        //NSLog(@"%@", [child2 text]);
                                        [parameters setObject:[child2 text] forKey:@"release_date"];
                                        }
                                        
                                        NSArray *AElements3 = [element searchWithXPathQuery:@"//ul[@class='links clearfix']/li/a"];
                                        NSString* string;
                                        int i = 0;
                                        for (TFHppleElement *child3 in AElements3) {
                                        if ([[child3 text] isEqual: @"預告片"]) {
                                        [parameters setObject:[child3 objectForKey:@"href"] forKey:@"trailer_url"];
                                        }
                                        if (i == 0) {
                                        string = [child3 text];
                                        } else {
                                        string = [NSString stringWithFormat:@"%@&%@",string,[child3 text]];
                                        }
                                        i++;
                                        }
                                        [parameters setObject:string forKey:@"menu"];
                                        //NSLog(@"%@", string);
                                        */
                                       
                                       [list addObject:parameters];
                                   }
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification2"
                                                                                       object: list];
                                   
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification2"                                                            object: nil];
                               }
                           }];
}

/*
 -(void)selectKey1:(NSDictionary*)mark
 {
 NSURL *url = [NSURL URLWithString:MARK_QUERY_URL1];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
 // set GET or POST method
 [request setHTTPMethod:@"POST"];
 // adding keys with values
 NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"p=%@", [mark objectForKey:@"currentPage"]]];
 NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
 NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
 [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
 [request setHTTPBody:postData];
 [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
 [NSURLConnection sendAsynchronousRequest:request
 queue:[NSOperationQueue currentQueue]
 completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
 
 if (data != nil && error == nil)
 {
 NSMutableArray* list = [[NSMutableArray alloc] init];
 TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
 
 NSString *contributorsXpathQueryString = @"//div[@class='row-container']";
 NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
 
 NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
 for (TFHppleElement *element in contributorsNodes) {
 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
 NSArray *AElements = [element searchWithXPathQuery:@"//img"];
 for (TFHppleElement *child in AElements) {
 //NSLog(@"%@", [child objectForKey:@"src"]);
 //NSLog(@"%@", [child objectForKey:@"title"]);
 [parameters setObject:[child objectForKey:@"src"] forKey:@"image"];
 [parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
 NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
 NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
 NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
 NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
 [parameters setObject:ichar1 forKey:@"id"];
 }
 NSArray *AElements1 = [element searchWithXPathQuery:@"//h5/a"];
 for (TFHppleElement *child1 in AElements1) {
 NSString *english_name;
 if ([child1 text] == nil) {                                           english_name = @"";
 } else {
 english_name = [child1 text];
 }
 [parameters setObject:english_name forKey:@"english_name"];
 }
 NSArray *AElements2 = [element searchWithXPathQuery:@"//span/span"];
 for (TFHppleElement *child2 in AElements2) {
 //NSLog(@"%@", [child2 text]);
 [parameters setObject:[child2 text] forKey:@"release_date"];
 }
 
 NSArray *AElements3 = [element searchWithXPathQuery:@"//ul[@class='links clearfix']/li/a"];
 NSString* string;
 int i = 0;
 for (TFHppleElement *child3 in AElements3) {
 if ([[child3 text] isEqual: @"預告片"]) {
 [parameters setObject:[child3 objectForKey:@"href"] forKey:@"trailer_url"];
 }
 if (i == 0) {
 string = [child3 text];
 } else {
 string = [NSString stringWithFormat:@"%@&%@",string,[child3 text]];
 }
 i++;
 }
 [parameters setObject:string forKey:@"menu"];
 //NSLog(@"%@", string);
 [list addObject:parameters];
 }
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification1"
 object: list];
 }
 else
 {
 // There was an error, alert the user
 [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification1"                                                            object: nil];
 }
 }];
 }
 
 -(void)selectKey2:(NSDictionary*)mark
 {
 NSURL *url = [NSURL URLWithString:MARK_QUERY_URL2];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
 // set GET or POST method
 [request setHTTPMethod:@"POST"];
 // adding keys with values
 NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"p=%@", [mark objectForKey:@"currentPage"]]];
 NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
 NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
 [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
 [request setHTTPBody:postData];
 [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
 [NSURLConnection sendAsynchronousRequest:request
 queue:[NSOperationQueue currentQueue]
 completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
 
 if (data != nil && error == nil)
 {
 NSMutableArray* list = [[NSMutableArray alloc] init];
 TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
 
 NSString *contributorsXpathQueryString = @"//div[@class='row-container']";
 NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
 
 NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
 for (TFHppleElement *element in contributorsNodes) {
 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
 NSArray *AElements = [element searchWithXPathQuery:@"//img"];
 for (TFHppleElement *child in AElements) {
 //NSLog(@"%@", [child objectForKey:@"src"]);
 //NSLog(@"%@", [child objectForKey:@"title"]);
 [parameters setObject:[child objectForKey:@"src"] forKey:@"image"];
 [parameters setObject:[child objectForKey:@"title"] forKey:@"chinese_name"];
 NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
 NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
 NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
 NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
 [parameters setObject:ichar1 forKey:@"id"];
 }
 NSArray *AElements1 = [element searchWithXPathQuery:@"//h5/a"];
 for (TFHppleElement *child1 in AElements1) {
 NSString *english_name;
 if ([child1 text] == nil) {                                           english_name = @"";
 } else {
 english_name = [child1 text];
 }
 [parameters setObject:english_name forKey:@"english_name"];
 }
 NSArray *AElements2 = [element searchWithXPathQuery:@"//span/span"];
 for (TFHppleElement *child2 in AElements2) {
 //NSLog(@"%@", [child2 text]);
 [parameters setObject:[child2 text] forKey:@"release_date"];
 }
 
 NSArray *AElements3 = [element searchWithXPathQuery:@"//ul[@class='links clearfix']/li/a"];
 NSString* string;
 int i = 0;
 for (TFHppleElement *child3 in AElements3) {
 if ([[child3 text] isEqual: @"預告片"]) {
 [parameters setObject:[child3 objectForKey:@"href"] forKey:@"trailer_url"];
 }
 if (i == 0) {
 string = [child3 text];
 } else {
 string = [NSString stringWithFormat:@"%@&%@",string,[child3 text]];
 }
 i++;
 }
 [parameters setObject:string forKey:@"menu"];
 //NSLog(@"%@", string);
 [list addObject:parameters];
 }
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification2"
 object: list];
 }
 else
 {
 // There was an error, alert the user
 [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification2"                                                            object: nil];
 }
 }];
 }
 */

-(void)selectKey3:(NSDictionary*)mark
{
    NSURL *url = [NSURL URLWithString:MARK_QUERY_URL3];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   
                                   NSString *contributorsXpathQueryString = @"//select[@id='theater_area']/option";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                   
                                   int taipei_count = contributorsNodes.count;
                                   int num = 0;
                                   
                                   for (TFHppleElement *element in contributorsNodes) {
                                       if (![[element text] isEqualToString:@"全部"]) {
                                           NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                           NSLog(@"%@", [element objectForKey:@"value"]);
                                           [parameters setObject:[element objectForKey:@"value"] forKey:@"area_id"];
                                           NSLog(@"%@", [element text]);
                                           [parameters setObject:[element text] forKey:@"area_name"];
                                           [list addObject:parameters];
                                       }
                                   }
                                   
                                   /*
                                    int taipei_count = contributorsNodes.count;
                                    int num = 0;
                                    for (TFHppleElement *element in contributorsNodes) {
                                    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                    //NSLog(@"%@", [NSString stringWithFormat:@"%i",num * 100]);
                                    [parameters setObject:[NSString stringWithFormat:@"%i",num * 100] forKey:@"area_id"];
                                    NSArray *AElements = [element searchWithXPathQuery:@"//div[@class='hd']"];
                                    for (TFHppleElement *child in AElements) {
                                    //NSLog(@"%@", [child text]);
                                    [parameters setObject:[child text] forKey:@"area_name"];
                                    }
                                    //NSLog(@"%@key", [NSString stringWithFormat:@"%i",num]);
                                    [parameters setObject:[NSString stringWithFormat:@"%i",num] forKey:@"area_sort_id"];
                                    
                                    AElements = [element searchWithXPathQuery:@"//tr"];
                                    int i = 0;
                                    NSMutableArray* list1 = [[NSMutableArray alloc] init];
                                    for (TFHppleElement *tempTRElement in AElements) {
                                    if (i == 0) {
                                    i++;
                                    continue;
                                    }
                                    NSArray *TDElements = [tempTRElement childrenWithTagName:@"td"];
                                    NSMutableDictionary *parameters1 = [[NSMutableDictionary alloc] init];
                                    NSString *movie_theater_address;
                                    NSString *movie_theater_tel;
                                    NSString *movie_theater_area_id;
                                    NSString *movie_theater_id;
                                    NSString *movie_theater_name;
                                    for (TFHppleElement *tempTDElement in TDElements) {
                                    if ([tempTDElement text] != nil) {
                                    //NSLog(@"%@", [tempTDElement text]);
                                    movie_theater_address = [tempTDElement text];
                                    
                                    NSArray *AElements2 = [tempTDElement searchWithXPathQuery:@"//em"];
                                    for (TFHppleElement *child2 in AElements2) {
                                    //NSLog(@"%@", [child2 text]);
                                    movie_theater_tel = [child2 text];
                                    }
                                    
                                    movie_theater_area_id = [NSString stringWithFormat:@"%i",num * 100];
                                    }
                                    NSArray *AElements = [tempTDElement searchWithXPathQuery:@"//a"];
                                    for (TFHppleElement *tempAElement in AElements) {
                                    
                                    NSArray *myWords = [[tempAElement objectForKey:@"href"] componentsSeparatedByString:@"/"];
                                    NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                    NSArray *myWords1 = [ichar componentsSeparatedByString:@"="];
                                    NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:[myWords1 count] - 1]];
                                    
                                    movie_theater_id = ichar1;
                                    //NSLog(@"A-text:%@", [tempAElement text]);
                                    movie_theater_name = [tempAElement text];
                                    }
                                    }
                                    [parameters1 setObject:movie_theater_address forKey:@"movie_theater_address"];
                                    [parameters1 setObject:movie_theater_tel forKey:@"movie_theater_tel"];
                                    [parameters1 setObject:movie_theater_area_id forKey:@"movie_theater_area_id"];
                                    [parameters1 setObject:movie_theater_id forKey:@"movie_theater_id"];
                                    [parameters1 setObject:movie_theater_name forKey:@"movie_theater_name"];
                                    [list1 addObject:parameters1];
                                    }
                                    [parameters setObject:list1 forKey:@"movie_theater"];
                                    
                                    [list addObject:parameters];
                                    num++;
                                    }
                                    
                                    contributorsXpathQueryString = @"//select[@id='area']/option";
                                    contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                    
                                    NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                    num = taipei_count;
                                    for (TFHppleElement *element in contributorsNodes) {
                                    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                    if (![[[element attributes] objectForKey:@"value"] isEqual: @"0"]) {
                                    NSMutableArray* list2 = [[NSMutableArray alloc] init];
                                    //NSLog(@"%@", [[element attributes] objectForKey:@"value"]);
                                    [parameters setObject:[[element attributes] objectForKey:@"value"] forKey:@"area_id"];
                                    //NSLog(@"%@", [element text]);
                                    [parameters setObject:[element text] forKey:@"area_name"];
                                    //NSLog(@"%@key", [NSString stringWithFormat:@"%i",num]);
                                    [parameters setObject:[NSString stringWithFormat:@"%i",num] forKey:@"area_sort_id"];
                                    [parameters setObject:list2 forKey:@"movie_theater"];
                                    [list addObject:parameters];
                                    num++;
                                    }
                                    }
                                    */
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification3"
                                                                                       object: list];
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification3"                                                            object: nil];
                               }
                           }];
}

-(void)selectKey4:(NSDictionary*)mark
{
    NSURL *url = [NSURL URLWithString:[MARK_QUERY_URL4 stringByAppendingFormat:@"?area_id=%@", [mark objectForKey:@"area_id"]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    // set GET or POST method
    [request setHTTPMethod:@"GET"];
    // adding keys with values
    //NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"area=%@", [mark objectForKey:@"area_id"]]];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   
                                   NSString *contributorsXpathQueryString = @"//div[@class='theater_content']/ul/li";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                   
                                   int i = 0;
                                   for (TFHppleElement *element in contributorsNodes) {
                                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                       if (i == 0) {
                                           i++;
                                           continue;
                                       }
                                       [parameters setObject:@"" forKey:@"movie_theater_name"];
                                       NSArray *AElements = [element searchWithXPathQuery:@"//div[@class='name']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"%@", [child text]);
                                           [parameters setObject:[child text] forKey:@"movie_theater_name"];
                                           NSArray *myWords = [[child objectForKey:@"href"] componentsSeparatedByString:@"id="];
                                           NSLog(@"%@", [myWords objectAtIndex:1]);
                                           if ([myWords objectAtIndex:1] != nil) {
                                               [parameters setObject:[myWords objectAtIndex:1] forKey:@"movie_theater_id"];
                                           }
                                       }
                                       [parameters setObject:@"" forKey:@"movie_theater_address"];
                                       AElements = [element searchWithXPathQuery:@"//div[@class='adds']"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"%@", [child text]);
                                           if ([child text] != nil) {
                                               [parameters setObject:[child text] forKey:@"movie_theater_address"];
                                           }
                                       }
                                       [parameters setObject:@"" forKey:@"movie_theater_tel"];
                                       AElements = [element searchWithXPathQuery:@"//div[@class='tel']"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"%@", [child text]);
                                           if ([child text] != nil) {
                                               [parameters setObject:[child text] forKey:@"movie_theater_tel"];
                                           }
                                       }
                                       
                                       [list addObject:parameters];
                                   }
                                   
                                   /*
                                    for (TFHppleElement *element in contributorsNodes) {
                                    
                                    NSArray *AElements = [element searchWithXPathQuery:@"//tr"];
                                    int i = 0;
                                    for (TFHppleElement *tempTRElement in AElements) {
                                    if (i == 0) {
                                    i++;
                                    continue;
                                    }
                                    NSArray *TDElements = [tempTRElement childrenWithTagName:@"td"];
                                    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                    NSString *movie_theater_address;
                                    NSString *movie_theater_tel;
                                    NSString *movie_theater_area_id;
                                    NSString *movie_theater_id;
                                    NSString *movie_theater_name;
                                    for (TFHppleElement *tempTDElement in TDElements) {
                                    if ([tempTDElement text] != nil) {
                                    //NSLog(@"%@", [tempTDElement text]);
                                    movie_theater_address = [tempTDElement text];
                                    
                                    NSArray *AElements2 = [tempTDElement searchWithXPathQuery:@"//em"];
                                    for (TFHppleElement *child2 in AElements2) {
                                    //NSLog(@"%@", [child2 text]);
                                    if ([child2 text] == nil) {
                                    movie_theater_tel = @"";
                                    } else {
                                    movie_theater_tel = [child2 text];
                                    }
                                    }
                                    movie_theater_area_id = [NSString stringWithFormat:@"%@",[mark objectForKey:@"area_id"]];
                                    }
                                    NSArray *AElements = [tempTDElement searchWithXPathQuery:@"//a"];
                                    for (TFHppleElement *tempAElement in AElements) {
                                    
                                    NSArray *myWords = [[tempAElement objectForKey:@"href"] componentsSeparatedByString:@"/"];
                                    NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                    NSArray *myWords1 = [ichar componentsSeparatedByString:@"="];
                                    NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:[myWords1 count] - 1]];
                                    
                                    movie_theater_id = ichar1;
                                    //NSLog(@"A-text:%@", [tempAElement text]);
                                    movie_theater_name = [tempAElement text];
                                    }
                                    }
                                    [parameters setObject:movie_theater_address forKey:@"movie_theater_address"];
                                    [parameters setObject:movie_theater_tel forKey:@"movie_theater_tel"];
                                    [parameters setObject:movie_theater_area_id forKey:@"movie_theater_area_id"];
                                    [parameters setObject:movie_theater_id forKey:@"movie_theater_id"];
                                    [parameters setObject:movie_theater_name forKey:@"movie_theater_name"];
                                    [list addObject:parameters];
                                    }
                                    }
                                    */
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification4"
                                                                                       object: list];
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification4"                                                            object: nil];
                               }
                           }];
}

- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

-(void)selectKey5:(NSDictionary*)mark
{
    NSLog(@"字串==%@",[MARK_QUERY_URL5 stringByAppendingFormat:@"/id=%@", [mark objectForKey:@"movie_theater_id"]]);
    
    NSURL *url = [NSURL URLWithString:[MARK_QUERY_URL5 stringByAppendingFormat:@"/id=%@", [mark objectForKey:@"movie_theater_id"]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    // set GET or POST method
    [request setHTTPMethod:@"GET"];
    // adding keys with values
    //NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"id=%@", [mark objectForKey:@"movie_theater_id"]]];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   NSString* newStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@""withString:@""];
                                   //NSLog(@"字串==%@",newStr);
                                   
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   
                                   NSString *contributorsXpathQueryString = @"//div[@class='theater_list _c']/ul/li";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                   
                                   for (TFHppleElement *element in contributorsNodes) {
                                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                       NSArray *AElements = [element searchWithXPathQuery:@"//div[@class='release_foto']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           NSArray *myWords = [[child objectForKey:@"href"] componentsSeparatedByString:@"-"];
                                           NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                           NSLog(@"%@", [myWords objectAtIndex:(myWords.count - 1)]);
                                           [parameters setObject:[myWords objectAtIndex:(myWords.count - 1)] forKey:@"movie_id"];
                                       }
                                       AElements = [element searchWithXPathQuery:@"//div[@class='release_foto']/a/img"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"%@", [child objectForKey:@"src"]);
                                           [parameters setObject:[child objectForKey:@"src"] forKey:@"movie_image"];
                                       }
                                       AElements = [element searchWithXPathQuery:@"//div[@class='theaterlist_name']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"%@", [child text]);
                                           [parameters setObject:[child text] forKey:@"movie_chinese_name"];
                                       }
                                       [parameters setObject:@"" forKey:@"movie_english_name"];
                                       AElements = [element searchWithXPathQuery:@"//div[@class='en']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"%@", [child text]);
                                           if ([child text] != nil) {
                                               [parameters setObject:[child text] forKey:@"movie_english_name"];
                                           }
                                       }
                                       AElements = [element searchWithXPathQuery:@"//ul[@class='theater_time']/li"];
                                       NSMutableArray* list2 = [[NSMutableArray alloc] init];
                                       for (TFHppleElement *child in AElements) {
                                           if ([[child text] rangeOfString:@":"].location != NSNotFound) {
                                               NSLog(@"%@", [child text]);
                                               [list2 addObject:[child text]];
                                           }
                                       }
                                       if ([list2 count] == 0) {
                                           NSLog(@"找不到時間");
                                           AElements = [element searchWithXPathQuery:@"//ul[@class='theater_time']/li/a"];
                                           for (TFHppleElement *child in AElements) {
                                               if ([[child text] rangeOfString:@":"].location != NSNotFound) {
                                                   NSLog(@"%@", [self removeSpaceAndNewline:[child text]]);
                                                   [list2 addObject:[self removeSpaceAndNewline:[child text]]];
                                               }
                                           }
                                       }
                                       [parameters setObject:list2 forKey:@"movie_release_date"];
                                       NSMutableArray* list1 = [[NSMutableArray alloc] init];
                                       AElements = [element searchWithXPathQuery:@"//div[@class='tapR']"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"%@", [child text]);
                                           [list1 addObject:[child text]];
                                       }
                                       AElements = [element searchWithXPathQuery:@"//div[@class='tapB']"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"%@", [child text]);
                                           [list1 addObject:[child text]];
                                       }
                                       [parameters setObject:list1 forKey:@"movie_device"];
                                       [parameters setObject:@"" forKey:@"movie_classification"];
                                       
                                       NSRange range = [element.raw rangeOfString:@"icon_0"];
                                       if (range.location != NSNotFound)
                                       {
                                           [parameters setObject:@"https://s.yimg.com/cv/ae/movies/icon_0.png" forKey:@"movie_classification"];
                                       }
                                       
                                       range = [element.raw rangeOfString:@"icon_6"];
                                       if (range.location != NSNotFound)
                                       {
                                           [parameters setObject:@"https://s.yimg.com/cv/ae/movies/icon_6.png" forKey:@"movie_classification"];
                                       }
                                       
                                       range = [element.raw rangeOfString:@"icon_12"];
                                       if (range.location != NSNotFound)
                                       {
                                           [parameters setObject:@"https://s.yimg.com/cv/ae/movies/icon_12.png" forKey:@"movie_classification"];
                                       }
                                       
                                       range = [element.raw rangeOfString:@"icon_15"];
                                       if (range.location != NSNotFound)
                                       {
                                           [parameters setObject:@"https://s.yimg.com/cv/ae/movies/icon_15.png" forKey:@"movie_classification"];
                                       }
                                       
                                       range = [element.raw rangeOfString:@"icon_18"];
                                       if (range.location != NSNotFound)
                                       {
                                           [parameters setObject:@"https://s.yimg.com/cv/ae/movies/icon_18.png" forKey:@"movie_classification"];
                                       }
                                       [list addObject:parameters];
                                   }
                                   
                                   /*
                                    NSString *movie_id;
                                    NSString *movie_chinese_name = [[NSString alloc] init];
                                    movie_chinese_name = @"";
                                    NSString *movie_image;
                                    NSString *movie_classification;
                                    int k = 0;
                                    for (TFHppleElement *element in contributorsNodes) {
                                    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                    NSArray *AElements = [element searchWithXPathQuery:@"//div[@class='img']/a/img"];
                                    for (TFHppleElement *child in AElements) {
                                    //NSLog(@"%@", [child objectForKey:@"src"]);
                                    movie_image = [child objectForKey:@"src"];
                                    NSArray *myWords = [[child objectForKey:@"src"] componentsSeparatedByString:@"/"];
                                    NSString *ichar  = [NSString stringWithFormat:@"%@", [myWords objectAtIndex:[myWords count] - 1]];
                                    NSArray *myWords1 = [ichar componentsSeparatedByString:@"."];
                                    NSString *ichar1  = [NSString stringWithFormat:@"%@", [myWords1 objectAtIndex:0]];
                                    //NSLog(@"%@", ichar1);
                                    movie_id = ichar1;
                                    }
                                    
                                    AElements = [element searchWithXPathQuery:@"//div[@class='gate']/img"];
                                    for (TFHppleElement *child in AElements) {
                                    movie_classification = [child objectForKey:@"src"];
                                    }
                                    
                                    AElements = [element searchWithXPathQuery:@"//h4/a"];
                                    for (TFHppleElement *child in AElements) {
                                    if ([child text] != nil) {
                                    movie_chinese_name = [child text];
                                    }
                                    }
                                    
                                    AElements = [element searchWithXPathQuery:@"//span[@class='mvtype']/img"];
                                    NSMutableArray* list1 = [[NSMutableArray alloc] init];
                                    for (TFHppleElement *child in AElements) {
                                    //NSLog(@"%@", [child objectForKey:@"src"]);
                                    [list1 addObject:[child objectForKey:@"src"]];
                                    }
                                    
                                    AElements = [element searchWithXPathQuery:@"//span[@class='tmt']"];
                                    NSMutableArray* list2 = [[NSMutableArray alloc] init];
                                    for (TFHppleElement *child in AElements) {
                                    //NSLog(@"%@", [child text]);
                                    [list2 addObject:[child text]];
                                    }
                                    
                                    [parameters setObject:@"電影介紹&時刻表" forKey:@"menu"];
                                    AElements = [element searchWithXPathQuery:@"//a[@class='trailer']"];
                                    for (TFHppleElement *child in AElements) {
                                    [parameters setObject:[child objectForKey:@"href"] forKey:@"trailer_url"];
                                    [parameters setObject:@"電影介紹&時刻表&預告片" forKey:@"menu"];
                                    }
                                    
                                    [parameters setObject:movie_id forKey:@"movie_id"];
                                    [parameters setObject:movie_image forKey:@"movie_image"];
                                    [parameters setObject:movie_classification forKey:@"movie_classification"];
                                    [parameters setObject:movie_chinese_name forKey:@"movie_chinese_name"];
                                    [parameters setObject:list1 forKey:@"movie_device"];
                                    [parameters setObject:list2 forKey:@"movie_release_date"];
                                    [list addObject:parameters];
                                    k++;
                                    }
                                    */
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification5"
                                                                                       object: list];
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification5"                                                            object: nil];
                               }
                           }];
}

-(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *temp = [html stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return temp;
}

-(void)selectKey6:(NSDictionary*)mark
{
    NSLog(@"字串==%@",[MARK_QUERY_URL9 stringByAppendingFormat:@"/id=%@", [mark objectForKey:@"id"]]);
    
    NSURL *url = [NSURL URLWithString:[MARK_QUERY_URL6 stringByAppendingFormat:@"/id=%@", [mark objectForKey:@"id"]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    // set GET or POST method
    [request setHTTPMethod:@"GET"];
    // adding keys with values
    //NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"id=%@", [mark objectForKey:@"id"]]];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   NSString* newStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"<br />"withString:@" "];
                                   data = [newStr dataUsingEncoding:NSUTF8StringEncoding];
                                   
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   
                                   NSString *image;
                                   NSString *classification;
                                   NSString *chinese_name;
                                   NSString *english_name;
                                   NSString *release_date;
                                   NSString *type = @"";
                                   NSString *length;
                                   NSString *director;
                                   NSString *actor;
                                   
                                   NSString *MovieTrailer = @"";
                                   
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   
                                   NSString *contributorsXpathQueryString = @"//div[@class='movie_intro_foto']/img";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   //NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                   for (TFHppleElement *element in contributorsNodes) {
                                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                       image = [element objectForKey:@"src"];
                                       NSLog(@"%@", image);
                                       [parameters setObject:image forKey:@"image"];
                                       
                                       [parameters setObject:@"" forKey:@"MovieTrailer"];
                                       [parameters setObject:@"" forKey:@"classification"];
                                       
                                       NSRange range = [newStr rangeOfString:@"icon_0"];
                                       if (range.location != NSNotFound)
                                       {
                                           [parameters setObject:@"https://s.yimg.com/cv/ae/movies/icon_0.png" forKey:@"classification"];
                                       }
                                       
                                       range = [newStr rangeOfString:@"icon_6"];
                                       if (range.location != NSNotFound)
                                       {
                                           [parameters setObject:@"https://s.yimg.com/cv/ae/movies/icon_6.png" forKey:@"classification"];
                                       }
                                       
                                       range = [newStr rangeOfString:@"icon_12"];
                                       if (range.location != NSNotFound)
                                       {
                                           [parameters setObject:@"https://s.yimg.com/cv/ae/movies/icon_12.png" forKey:@"classification"];
                                       }
                                       
                                       range = [newStr rangeOfString:@"icon_15"];
                                       if (range.location != NSNotFound)
                                       {
                                           [parameters setObject:@"https://s.yimg.com/cv/ae/movies/icon_15.png" forKey:@"classification"];
                                       }
                                       
                                       range = [newStr rangeOfString:@"icon_18"];
                                       if (range.location != NSNotFound)
                                       {
                                           [parameters setObject:@"https://s.yimg.com/cv/ae/movies/icon_18.png" forKey:@"classification"];
                                       }
                                       
                                       [parameters setObject:@"" forKey:@"director"];
                                       [parameters setObject:@"" forKey:@"actor"];
                                       
                                       [list addObject:parameters];
                                   }
                                   
                                   contributorsXpathQueryString = @"//div[@class='movie_intro_info_r']";
                                   contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   //NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                   
                                   for (TFHppleElement *element in contributorsNodes) {
                                       NSArray *AElements = [element searchWithXPathQuery:@"//h1"];
                                       for (TFHppleElement *child in AElements) {
                                           chinese_name = [child text];
                                           NSLog(@"%@", chinese_name);
                                           [[list objectAtIndex:0] setObject:chinese_name forKey:@"chinese_name"];
                                       }
                                       AElements = [element searchWithXPathQuery:@"//h3"];
                                       for (TFHppleElement *child in AElements) {
                                           if ([child text] != nil) {
                                               english_name = [child text];
                                               NSLog(@"%@", english_name);
                                               [[list objectAtIndex:0] setObject:english_name forKey:@"english_name"];
                                           }
                                       }
                                       AElements = [element searchWithXPathQuery:@"//span"];
                                       int i = 0;
                                       NSString* string1, *string2, *string3;
                                       for (TFHppleElement *child in AElements) {
                                           switch (i) {
                                               case 0:
                                                   if ([child text] != nil) {
                                                       release_date = [child text];
                                                   } else {
                                                       release_date = @"不詳";
                                                   }
                                                   NSLog(@"%@", release_date);
                                                   [[list objectAtIndex:0] setObject:release_date forKey:@"release_date"];
                                                   break;
                                               case 1:
                                                   if ([child text] != nil) {
                                                       length = [child text];
                                                   } else {
                                                       length = @"不詳";
                                                   }
                                                   NSLog(@"%@", length);
                                                   [[list objectAtIndex:0] setObject:length forKey:@"length"];
                                                   break;
                                                   
                                           }
                                           i++;
                                       }
                                       
                                       int aaa = 0;
                                       AElements = [element searchWithXPathQuery:@"//span[@class='movie_intro_list']"];
                                       for (TFHppleElement *child in AElements) {
                                           if (aaa == 0) {
                                               [[list objectAtIndex:0] setObject:[self convertHTML:child.raw] forKey:@"director"];
                                           } else {
                                               [[list objectAtIndex:0] setObject:[self convertHTML:child.raw] forKey:@"actor"];
                                           }
                                           aaa ++;
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='level_name']/a"];
                                       for (TFHppleElement *child in AElements) {
                                           type = [NSString stringWithFormat:@"%@%@%@", type, [[[child text] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""], @" "];
                                       }
                                       NSLog(@"%@", type);
                                       [[list objectAtIndex:0] setObject:type forKey:@"type"];
                                   }
                                   
                                   //[parameters setObject:MovieTrailer forKey:@"MovieTrailer"];
                                   //[parameters setObject:image forKey:@"image"];
                                   //[parameters setObject:classification forKey:@"classification"];
                                   //[parameters setObject:type forKey:@"type"];
                                   //[parameters setObject:director forKey:@"director"];
                                   //[parameters setObject:actor forKey:@"actor"];
                                   
                                   /*
                                    NSString *contributorsXpathQueryString = @"//div[@id='ymvmvf']";
                                    NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                    
                                    NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                    for (TFHppleElement *element in contributorsNodes) {
                                    NSArray *AElements = [element searchWithXPathQuery:@"//div[@class='border']/a"];
                                    for (TFHppleElement *child in AElements) {
                                    image = [child objectForKey:@"href"];
                                    //NSLog(@"%@", image);
                                    }
                                    AElements = [element searchWithXPathQuery:@"//img[@class='gate']"];
                                    for (TFHppleElement *child in AElements) {
                                    classification = [child objectForKey:@"src"];
                                    //NSLog(@"%@", classification);
                                    }
                                    AElements = [element searchWithXPathQuery:@"//div[@class='text bulletin']/h4"];
                                    for (TFHppleElement *child in AElements) {
                                    if ([child text] == nil) {                                           chinese_name = @"不詳";
                                    } else {
                                    chinese_name = [child text];
                                    }
                                    //NSLog(@"%@", chinese_name);
                                    }
                                    
                                    AElements = [element searchWithXPathQuery:@"//li[@class='trailer']/a"];
                                    for (TFHppleElement *child in AElements) {
                                    if ([child text] == nil) {
                                    MovieTrailer = @"";
                                    } else {
                                    MovieTrailer = [child objectForKey:@"href"];
                                    }
                                    }
                                    
                                    AElements = [element searchWithXPathQuery:@"//div[@class='text bulletin']/h5"];
                                    for (TFHppleElement *child in AElements) {
                                    if ([child text] == nil) {                                           english_name = @"不詳";
                                    } else {
                                    english_name = [child text];
                                    }
                                    //NSLog(@"%@", english_name);
                                    }
                                    
                                    AElements = [element searchWithXPathQuery:@"//span[@class='dta']"];
                                    int i = 0;
                                    NSString* string1, *string2, *string3;
                                    for (TFHppleElement *child in AElements) {
                                    switch (i) {
                                    case 0:
                                    if ([child text] != nil) {                                                release_date = [child text];
                                    } else {
                                    release_date = @"不詳";
                                    }
                                    //NSLog(@"%@", release_date);
                                    break;
                                    case 1:
                                    AElements = [child searchWithXPathQuery:@"//a"];
                                    if([AElements count] == 0 || AElements == nil) {
                                    if ([child text] != nil) {                                                       string1 = [child text];
                                    } else {
                                    string1 = @"不詳";
                                    }
                                    }
                                    else if([AElements count] >= 1) {
                                    int i1 = 0;
                                    for (TFHppleElement *child in AElements) {
                                    if (i1 == 0) {
                                    if ([child text] != nil) {                                                                 string1 = [child text];
                                    } else {
                                    string1 = @"不詳";
                                    }
                                    } else {
                                    if ([child text] != nil) {                                                                 string1 = [NSString stringWithFormat:@"%@、%@",string1,[child text]];
                                    } else {
                                    string1 = @"不詳";
                                    }
                                    }
                                    i1++;
                                    }
                                    }
                                    type = string1;
                                    //NSLog(@"%@", type);
                                    break;
                                    case 2:
                                    if ([child text] != nil) {                                                    length = [child text];
                                    } else {
                                    length = @"不詳";
                                    }
                                    //NSLog(@"%@", length);
                                    break;
                                    case 3:
                                    AElements = [child searchWithXPathQuery:@"//a"];
                                    if([AElements count] == 0 || AElements == nil) {
                                    if ([child text] != nil) {                                                         string2 = [child text];
                                    } else {
                                    string2 = @"不詳";
                                    }
                                    } else if([AElements count] >= 1) {
                                    int i2 = 0;
                                    for (TFHppleElement *child in AElements) {
                                    if (i2 == 0) {
                                    if ([child text] != nil) {                                                                string2 = [child text];
                                    } else {
                                    string2 = @"不詳";
                                    }
                                    } else {
                                    if ([child text] != nil) {                                                                string2 = [NSString stringWithFormat:@"%@、%@",string2,[child text]];
                                    } else {
                                    string2 = @"不詳";
                                    }
                                    }
                                    i2++;
                                    }
                                    }
                                    director = string2;
                                    //NSLog(@"%@", director);
                                    break;
                                    case 4:
                                    AElements = [child searchWithXPathQuery:@"//a"];
                                    if([AElements count] == 0 || AElements == nil) {
                                    if ([child text] != nil) {                                                         string3 = [child text];
                                    } else {
                                    string3 = @"不詳";
                                    }
                                    } else if([AElements count] >= 1) {
                                    int i3 = 0;
                                    for (TFHppleElement *child in AElements) {
                                    if (i3 == 0) {
                                    if ([child text] != nil) {                                                               string3 = [child text];
                                    } else {
                                    string3 = @"不詳";
                                    }
                                    } else {
                                    if ([child text] != nil) {
                                    string3 = [NSString stringWithFormat:@"%@、%@",string3,[child text]];
                                    } else {
                                    string3 = @"不詳";
                                    }
                                    }
                                    i3++;
                                    }
                                    }
                                    actor = string3;
                                    //NSLog(@"%@", actor);
                                    break;
                                    }
                                    i++;
                                    }
                                    }
                                    */
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification6"
                                                                                       object: list];
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification6"                                                            object: nil];
                               }
                           }];
}

-(void)selectKey7:(NSDictionary*)mark
{
    NSLog(@"字串==%@",[NSString stringWithFormat:@"https://movies.yahoo.com.tw/ajax/get_schedule_by_movie?movie_id=%@&date=%@&mode=movie-showtime&region_id=&theater_id=&datetime=&movie_type_id=", [mark objectForKey:@"id"], [mark objectForKey:@"date"]]);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://movies.yahoo.com.tw/ajax/get_schedule_by_movie?movie_id=%@&date=%@&mode=movie-showtime&region_id=&theater_id=&datetime=&movie_type_id=", [mark objectForKey:@"id"], [mark objectForKey:@"date"]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    // set GET or POST method
    [request setHTTPMethod:@"GET"];
    // adding keys with values
    //NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"id=%@", [mark objectForKey:@"id"]]];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   NSString* newStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@""withString:@""];
                                   //NSLog(@"字串7==%@",newStr);
                                   
                                   NSDictionary* jsonObj =
                                   [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
                                   
                                   //NSLog(@"view==%@",[jsonObj objectForKey:@"view"]);
                                   data = [[jsonObj objectForKey:@"view"] dataUsingEncoding:NSUTF8StringEncoding];
                                   
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   NSMutableArray* list1 = [[NSMutableArray alloc] init];
                                   NSMutableArray* list2 = [[NSMutableArray alloc] init];
                                   NSMutableArray* list3 = [[NSMutableArray alloc] init];
                                   NSMutableArray* list4 = [[NSMutableArray alloc] init];
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   
                                   NSString *contributorsXpathQueryString = @"//div[contains(@id,'theater_id')]";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                   
                                   NSMutableArray *c = [[NSMutableArray alloc]init];
                                   for (TFHppleElement *element in contributorsNodes) {
                                       NSArray *AElements = [element searchWithXPathQuery:@"//div[contains(@id,'theater_id')]"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSLog(@"area %@", [child objectForKey:@"data-location"]);
                                           [c addObject:[child objectForKey:@"data-location"]];
                                       }
                                   }
                                   
                                   NSOrderedSet * orderSet = [[NSOrderedSet alloc] initWithArray:c];
                                   
                                   for (TFHppleElement *element in contributorsNodes) {
                                       
                                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                       
                                       NSArray *AElements = [element searchWithXPathQuery:@"//div[contains(@id,'theater_id')]"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"area %@", [child objectForKey:@"data-location"]);
                                           [parameters setObject:[child objectForKey:@"data-location"] forKey:@"area"];
                                           break;
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//h2"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"%@", [child text]);
                                           //[list2 addObject:[element text]];
                                           [parameters setObject:[child text] forKey:@"movie_theater_name"];
                                           break;
                                       }
                                       
                                       NSMutableArray *d = [[NSMutableArray alloc]init];
                                       AElements = [element searchWithXPathQuery:@"//div[@class='timetable-label']"];
                                       for (TFHppleElement *child in AElements) {
                                           if ([child text] != nil) {
                                               NSLog(@"%@", [child text]);
                                               [d addObject:[child text]];
                                           }
                                       }
                                       
                                       NSMutableArray *e = [[NSMutableArray alloc]init];
                                       AElements = [element searchWithXPathQuery:@"//label"];
                                       for (TFHppleElement *child in AElements) {
                                           if ([child text] != nil) {
                                               NSLog(@"%@", [child text]);
                                               [e addObject:[child text]];
                                           }
                                       }
                                       
                                       [parameters setObject:d forKey:@"movie_device"];
                                       [parameters setObject:e forKey:@"movie_release_date"];
                                       [list1 addObject:parameters];
                                   }
                                   
                                   for (NSString *element in orderSet) {
                                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                       NSLog(@"orderSet %@", element);
                                       [parameters setObject:element forKey:@"area"];
                                       
                                       list2 = [[NSMutableArray alloc] init];
                                       list3 = [[NSMutableArray alloc] init];
                                       list4 = [[NSMutableArray alloc] init];
                                       for (NSDictionary *obj in list1) {
                                           if ([[obj objectForKey:@"area"] isEqual:element]) {
                                               [list2 addObject:[obj objectForKey:@"movie_theater_name"]];
                                               [list3 addObject:[obj objectForKey:@"movie_release_date"]];
                                               [list4 addObject:[obj objectForKey:@"movie_device"]];
                                           }
                                       }
                                       [parameters setObject:list2 forKey:@"movie_theater_name"];
                                       [parameters setObject:list3 forKey:@"movie_release_date"];
                                       [parameters setObject:list4 forKey:@"movie_device"];
                                       [list addObject:parameters];
                                   }
                                   
                                   for (NSDictionary *obj in list) {
                                       NSLog(@"area %@", [obj objectForKey:@"area"]);
                                       NSLog(@"movie_theater_name %@", [obj objectForKey:@"movie_theater_name"]);
                                       for (NSString *obj1 in [obj objectForKey:@"movie_release_date"]) {
                                           NSLog(@"movie_release_date %@", obj1);
                                       }
                                       for (NSString *obj1 in [obj objectForKey:@"movie_device"]) {
                                           NSLog(@"movie_device %@", obj1);
                                       }
                                   }
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification7"
                                                                                       object: list];
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification7"
                                                                                       object: nil];
                               }
                           }];
}

-(void)selectKey8:(NSDictionary*)mark
{
    NSURL *url = [NSURL URLWithString:[mark objectForKey:@"url"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // set GET or POST method
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (data != nil && error == nil)
                               {
                                   NSString* newStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@""withString:@""];
                                   NSLog(@"字串8==%@",newStr);
                                   
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   NSString *contributorsXpathQueryString = @"//ul[@class='notice_list _c']/li";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                   for (TFHppleElement *element in contributorsNodes) {
                                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                       NSArray *AElements = [element searchWithXPathQuery:@"//img"];
                                       
                                       //bool check = false;
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"字串==%@", [child objectForKey:@"src"]);
                                           [parameters setObject:[child objectForKey:@"src"] forKey:@"image"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//h2"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"字串==%@", [child text]);
                                           [parameters setObject:[child text] forKey:@"movietrailer_name"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//a"];
                                       for (TFHppleElement *child in AElements) {
                                           NSLog(@"字串==%@", [[child objectForKey:@"href"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                                           [parameters setObject:[[child objectForKey:@"href"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"movietrailer_href"];
                                       }
                                       
                                       /*
                                        AElements = [element searchWithXPathQuery:@"//a"];
                                        NSString *ichar;
                                        int i = 0;
                                        for (TFHppleElement *child in AElements) {
                                        switch (i) {
                                        case 0:
                                        ichar = [NSString stringWithFormat:@"%@%@",@"https://tw.movies.yahoo.com", [child objectForKey:@"href"]];
                                        NSLog(@"字串==%@", ichar);
                                        if (check) {
                                        [parameters setObject:ichar forKey:@"movietrailer_href"];
                                        }
                                        break;
                                        case 1:
                                        if (check) {
                                        [parameters setObject:[child text] forKey:@"movietrailer_name"];
                                        }
                                        break;
                                        }
                                        i++;
                                        }
                                        
                                        if (check) {
                                        [list addObject:parameters];
                                        }
                                        */
                                       [list addObject:parameters];
                                   }
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification8"
                                                                                       object: list];
                                   
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification8"                                                            object: nil];
                               }
                           }];
}

-(void)selectKey9:(NSDictionary*)mark
{
    NSLog(@"字串==%@",[MARK_QUERY_URL9 stringByAppendingFormat:@"/id=%@", [mark objectForKey:@"id"]]);
    
    NSURL *url = [NSURL URLWithString:[MARK_QUERY_URL9 stringByAppendingFormat:@"/id=%@", [mark objectForKey:@"id"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    // set GET or POST method
    [request setHTTPMethod:@"GET"];
    // adding keys with values
    //NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"id=%@", [mark objectForKey:@"id"]]];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   NSString* newStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"<br />"withString:@"\n"];
                                   data = [newStr dataUsingEncoding:NSUTF8StringEncoding];
                                   
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                   
                                   NSString *plot_synopsis;
                                   
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   
                                   NSString *contributorsXpathQueryString = @"//div[@class='gray_infobox_inner']/span";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                   int i = 0;
                                   for (TFHppleElement *element in contributorsNodes) {
                                       switch (i) {
                                           case 0:
                                               plot_synopsis = [element text];
                                               break;
                                       }
                                       i++;
                                   }
                                   /*
                                    if (plot_synopsis == nil) {
                                    contributorsXpathQueryString = @"//div[@class='text show']/p";
                                    contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                    NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                    int i = 0;
                                    for (TFHppleElement *element in contributorsNodes) {
                                    switch (i) {
                                    case 0:
                                    plot_synopsis = [element text];
                                    break;
                                    }
                                    i++;
                                    }
                                    }
                                    if (plot_synopsis == nil) {
                                    plot_synopsis = @"";
                                    }
                                    */
                                   [parameters setObject:plot_synopsis forKey:@"plot_synopsis"];
                                   [list addObject:parameters];
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification9"
                                                                                       object: list];
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification9"                                                            object: nil];
                               }
                           }];
}

-(void)selectKey10:(NSDictionary*)mark
{
    NSURL *url = [NSURL URLWithString:[@"https://tw.movies.yahoo.com/movieinfo_review.html/id=" stringByAppendingFormat:@"%@&s=0&o=0&p=%@", [mark objectForKey:@"id"], [mark objectForKey:@"currentPage"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // set GET or POST method
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (data != nil && error == nil)
                               {
                                   NSString* newStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@""withString:@""];
                                   //NSLog(@"字串==%@",newStr);
                                   
                                   NSMutableArray* list = [[NSMutableArray alloc] init];
                                   
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   NSString *contributorsXpathQueryString = @"//div[@class='row-container clearfix']";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                   for (TFHppleElement *element in contributorsNodes) {
                                       NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                                       NSArray *AElements = [element searchWithXPathQuery:@"//div[@class='rate']/img"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSArray *str = [[child objectForKey:@"href"] componentsSeparatedByString:@"id="];
                                           //[parameters setObject:str[1] forKey:@"movie_theater_id"];
                                           //[parameters setObject:[child text] forKey:@"movie_theater_name"];
                                           NSLog(@"123456789==%@", [child objectForKey:@"src"]);
                                           [parameters setObject:[child objectForKey:@"src"] forKey:@"score"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='text']/h4"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSArray *str = [[child objectForKey:@"href"] componentsSeparatedByString:@"id="];
                                           //[parameters setObject:str[1] forKey:@"movie_theater_id"];
                                           //[parameters setObject:[child text] forKey:@"movie_theater_name"];
                                           NSLog(@"123456789==%@", [child text]);
                                           [parameters setObject:[child text] forKey:@"title"];
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='text']/p"];
                                       int count = 0;
                                       for (TFHppleElement *child in AElements) {
                                           //NSArray *str = [[child objectForKey:@"href"] componentsSeparatedByString:@"id="];
                                           //[parameters setObject:str[1] forKey:@"movie_theater_id"];
                                           //[parameters setObject:[child text] forKey:@"movie_theater_name"];
                                           if (count == 0) {
                                               NSLog(@"123456789==%@", [child text]);
                                               [parameters setObject:[child text] forKey:@"content"];
                                           }
                                           count++;
                                       }
                                       
                                       AElements = [element searchWithXPathQuery:@"//div[@class='date']"];
                                       for (TFHppleElement *child in AElements) {
                                           //NSArray *str = [[child objectForKey:@"href"] componentsSeparatedByString:@"id="];
                                           //[parameters setObject:str[1] forKey:@"movie_theater_id"];
                                           //[parameters setObject:[child text] forKey:@"movie_theater_name"];
                                           NSLog(@"123456789==%@", [child text]);
                                           [parameters setObject:[child text] forKey:@"time"];
                                       }
                                       
                                       [list addObject:parameters];
                                   }
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification10"
                                                                                       object: list];
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification10"
                                                                                       object: nil];
                               }
                           }];
}

-(void)selectKey11:(NSDictionary*)mark
{
    NSLog(@"字串==%@",[MARK_QUERY_URL9 stringByAppendingFormat:@"/id=%@", [mark objectForKey:@"id"]]);
    
    NSURL *url = [NSURL URLWithString:[MARK_QUERY_URL6 stringByAppendingFormat:@"/id=%@", [mark objectForKey:@"id"]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    // set GET or POST method
    [request setHTTPMethod:@"GET"];
    // adding keys with values
    //NSString *post = [[NSString alloc] initWithString:[NSString stringWithFormat:@"id=%@", [mark objectForKey:@"id"]]];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody:postData];
    [request setTimeoutInterval: 300.0]; // Will timeout after 30 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil)
                               {
                                   NSString* newStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"<br />"withString:@" "];
                                   data = [newStr dataUsingEncoding:NSUTF8StringEncoding];
                                   
                                   //NSLog(@"字串11==%@",newStr);
                                   
                                   NSString * str;
                                   
                                   TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:data];
                                   NSString *contributorsXpathQueryString = @"//div[@class='color_btnbox']/a";
                                   NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
                                   
                                   NSLog(@"array count==%lu",(unsigned long)contributorsNodes.count);
                                   for (TFHppleElement *element in contributorsNodes) {
                                       //NSLog(@"123456789==%@", [element objectForKey:@"href"]);
                                       str = [element objectForKey:@"href"];
                                       break;
                                   }
                                   
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFinishedNotification11"
                                                                                       object: str];
                               }
                               else
                               {
                                   // There was an error, alert the user
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"BLQueryMarkFailedNotification11"                                                            object: nil];
                               }
                           }];
}

@end
