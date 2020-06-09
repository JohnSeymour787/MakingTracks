//
//  PTVAPISupportClass.h
//  MakingTracks
//
//  Created by John on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PTVAPISupportClass_h
#define PTVAPISupportClass_h

@interface PTVAPISupportClass: NSObject
+(NSURL*) generateURLWithDevIDAndKey:(NSString*) urlPath;
@end

#endif /* PTVAPISupportClass_h */
