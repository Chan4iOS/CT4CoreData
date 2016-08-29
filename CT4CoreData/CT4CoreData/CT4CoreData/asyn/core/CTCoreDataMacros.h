//
//  CTCoreDataMacros.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#ifndef CTCoreDataMacros_h
#define CTCoreDataMacros_h
#import <UIKit/UIKit.h>
#define _systermVersion_greter_8_0 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

#ifdef DEBUG
#define CTDBLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define CTDBLog(...)
#endif


#endif /* CTCoreDataMacros_h */
