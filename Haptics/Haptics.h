//
//  Haptics.h
//  VibGenerator
//
//  Created by larcuser on 2/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Haptics : NSObject

+ (instancetype)sharedinstance;
- (void)startEngine;
- (void)stopEngine;

@end

NS_ASSUME_NONNULL_END
