//
//  Haptics.m
//  VibGenerator
//
//  Created by larcuser on 2/3/22.
//

#import "Haptics.h"

#import <CoreHaptics/CoreHaptics.h>

@interface Haptics () {
    CHHapticEngine *_engine;
    BOOL HAPTICS_ON;
}

@end

@implementation Haptics
static Haptics *_defaultEngine = nil;

+ (instancetype)sharedinstance {
    if (_defaultEngine) {
        return _defaultEngine;
    }
    @synchronized ([Haptics class]) {
        if (!_defaultEngine) {
            _defaultEngine = [[self alloc]init];
            [_defaultEngine initEngine];
        }
        return _defaultEngine;
    }
    return nil;
}

- (void)initEngine {
    HAPTICS_ON = FALSE;
    NSError *error = nil;
    _engine = [[CHHapticEngine alloc]initAndReturnError:&error];
    if (error) {
        NSLog(@"initEngine Error: %@", error.description);
        _defaultEngine = nil;
    }
}

#pragma mark - CHHapticsEngine
- (void)startEngine {
    NSError *error = nil;
    
    [_engine startAndReturnError:&error];
    if (error) {
        NSLog(@"startEngine Error 0: %@", error.description);
    }
    
    [self playEventsWithFixedIntensity:1.0 sharpness:1.0 loopFor:5 duration:5 interval:5];
    
}

- (void)stopEngine {
    [_engine stopWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"stopEngine Error: %@", error.description);
        }
        self->HAPTICS_ON = NO;
    }];
}

#pragma mark - CHHapticPattern
- (void)playEventsWithFixedIntensity:(float)intensity sharpness:(float)sharpness loopFor:(int)loop_times duration:(int)duration interval:(int)interval {
    if (HAPTICS_ON == NO) {
        HAPTICS_ON = YES;
    }
    NSLog(@"playEventsWithFixedIntensity:%f sharpness:%f loopFor:%d duration:%d interval:%d", intensity, sharpness, loop_times, duration, interval);
    int i = 0;
    NSMutableArray *events = [NSMutableArray array];
    while (i < loop_times) {
        CHHapticEventParameter *event_para_intensity = [[CHHapticEventParameter alloc]initWithParameterID:CHHapticEventParameterIDHapticIntensity value:intensity];
        CHHapticEventParameter *event_para_sharpness = [[CHHapticEventParameter alloc]initWithParameterID:CHHapticEventParameterIDHapticSharpness value:sharpness];
        
        int start_time = i * (interval + duration);
        
        CHHapticEvent *event = [[CHHapticEvent alloc]initWithEventType:CHHapticEventTypeHapticContinuous parameters:[NSArray arrayWithObjects:event_para_intensity, event_para_sharpness, nil] relativeTime:start_time duration:duration];
        
        i += 1;
        [events addObject:event];
    }
    
    NSError *error = nil;
    CHHapticPattern *pattern = [[CHHapticPattern alloc]initWithEvents:[NSArray arrayWithArray:events] parameters:@[] error:&error];
    if (error) {
        NSLog(@"playEventsWithFixedIntensity 0: %@", error.description);
    } else {
        id <CHHapticPatternPlayer> player = [_engine createAdvancedPlayerWithPattern:pattern error:&error];
        if (error) {
            NSLog(@"playEventsWithFixedIntensity 1: %@", error.description);
        } else {
            [player startAtTime:0 error:&error];
            if (error) {
                NSLog(@"playEventsWithFixedIntensity 2: %@", error.description);
            }
        }
    }
}

@end
