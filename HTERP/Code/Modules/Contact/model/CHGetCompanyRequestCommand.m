//
//  CHGetCompanyRequestCommand.m
//  HTERP
//
//  Created by macbook on 10/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CHGetCompanyRequestCommand.h"
#import "CJSONRequestCommand.h"

@implementation CHGetCompanyRequestCommand

- (BOOL) urlDataLoadAuthentication:(CURLDataLoader*)loader
                       trustServer:(NSString*)host
{
    return NO;
}

- (void)startRequest:(NSString *)url
            postData:(NSDictionary *)postData
{
    [self setTimeOutSeconds:5];
    NSString* newUrl = [self setUpUrlParam:url];
    Info(@"URL:%@",newUrl);
    [super startRequest:newUrl postData:postData];
    
}

- (void) startRequest:(NSString*)inputUrl
             postData:(NSDictionary*)postData
               header:(NSDictionary*)header
{
    [self setTimeOutSeconds:5];
    NSString* newUrl = [self setUpUrlParam:inputUrl];
    Info(@"URL:%@",newUrl);
    
    NSDictionary *newPostData = [self setUpPostData:postData];
    [super startRequest:newUrl postData:newPostData header:[self setUpHeader]];
}

//登录态信息
-(NSString *)setUpUrlParam:(NSString *)url
{
    return url;
}

- (NSDictionary *)setUpPostData:(NSDictionary *)postData
{
    NSMutableDictionary *newPostData = [NSMutableDictionary dictionaryWithDictionary:postData];
    
    NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *plt = @"ios";
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [newPostData setObject:deviceId forKey:@"devId"];
    [newPostData setObject:plt forKey:@"plt"];
    [newPostData setObject:appVersion forKey:@"appver"];
    
    return newPostData;
}

- (NSDictionary *)setUpHeader
{
    NSString *luin = [NSString stringWithFormat:@"%@", @"1478226620226023751"];
    NSString *lskey = [NSString stringWithFormat:@"%@", @"aaaaaa"];
    
    NSString *encodeLuin = [luin stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodeLskey = [lskey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithCapacity:8];
    [header setObject:encodeLuin forKey:@"luin"];
    [header setObject:encodeLskey forKey:@"lskey"];
    
    return [header copy];
}

//-(void)parserDataInThread:(NSData *)recvData
//{
//#ifdef DEBUG_PROFILE
    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recvData options:NSJSONReadingMutableContainers error:nil];
    
//    NSString *string = [[NSString alloc] initWithData:recvData encoding:NSUTF8StringEncoding];

//    self.originalData = [CJSONRequestCommand replaceUnicode:string] ;
//#endif
    
//    NSError *error = nil;
//    self.responseModel = [[self.modelClass alloc] initWithData:recvData error:&error] ;
//    if (error) {
//        _dataParseError = [error copy];
//    }
//}



@end
