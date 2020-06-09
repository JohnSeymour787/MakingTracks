//  MakingTracks
//
//  PTVAPISupportClass.m
//
//  Purpose: This code provides a static class method to generate a NSURL
//           for an API endpoint path, based on the registered devID and
//           dev key provided by PTV. A signature is required to be generated
//           with these values for each request, using a HMAC-SHA1 hash.
//
//  Implementation: Provided by the PTV Timetable API Documentation, see reference.
//
//  Reference: https://www.ptv.vic.gov.au/footer/data-and-reporting/datasets/ptv-timetable-api/
//

#import "PTVAPISupportClass.h"

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation PTVAPISupportClass : NSObject

+(NSURL*) generateURLWithDevIDAndKey:(NSString*) urlPath
{
    static NSString *hardcodedURL = @"https://timetableapi.ptv.vic.gov.au";
    static NSString *hardcodedDevID = @"3001590";
    static NSString *hardcodedkey = @"c8dadf8a-8725-4e9f-9936-c88b97fc3918";
    
    NSRange deleteRange ={0,[hardcodedURL length]};
    NSMutableString *urlString = [[NSMutableString alloc]initWithString:urlPath];
    [urlString deleteCharactersInRange:deleteRange];
    if( [urlString containsString:@"?"])
        [urlString appendString:@"&"];
    else
        [urlString appendString:@"?"];
    
    [urlString appendFormat:@"devid=%@",hardcodedDevID];
    
    
    const char *cKey  = [hardcodedkey cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [urlString cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    NSString* signature = [hash uppercaseString];
    NSString *urlSuffix = [NSString stringWithFormat:@"devid=%@&signature=%@", hardcodedDevID,signature];
    
    NSURL *url = [NSURL URLWithString:urlPath];
    NSString *urlQuery = [url query];
    
    if(urlQuery != nil && [urlQuery length] > 0)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&%@",urlPath,urlSuffix]];
    }else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",urlPath,urlSuffix]];
    }
    
    return url;
}

@end
