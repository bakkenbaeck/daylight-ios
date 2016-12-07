//
//  Check LICENSE.md for full license details.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface SunriseSet : NSObject

@property (readonly, strong) NSDate *date;
@property (readonly, strong) NSDate *sunset;
@property (readonly, strong) NSDate *sunrise;
@property (readonly, strong) NSDate *civilTwilightStart;
@property (readonly, strong) NSDate *civilTwilightEnd;
@property (readonly, strong) NSDate *nauticalTwilightStart;
@property (readonly, strong) NSDate *nauticalTwilightEnd;
@property (readonly, strong) NSDate *astronomicalTwilightStart;
@property (readonly, strong) NSDate *astronomicalTwilightEnd;

@property (readonly, strong) NSDateComponents* localSunrise;
@property (readonly, strong) NSDateComponents* localSunset;
@property (readonly, strong) NSDateComponents* localCivilTwilightStart;
@property (readonly, strong) NSDateComponents* localCivilTwilightEnd;
@property (readonly, strong) NSDateComponents* localNauticalTwilightStart;
@property (readonly, strong) NSDateComponents* localNauticalTwilightEnd;
@property (readonly, strong) NSDateComponents* localAstronomicalTwilightStart;
@property (readonly, strong) NSDateComponents* localAstronomicalTwilightEnd;


- (instancetype)initWithDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone latitude:(double)latitude longitude:(double)longitude NS_DESIGNATED_INITIALIZER;
+ (instancetype)sunriseSetWithDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone latitude:(double)latitude longitude:(double)longitude;
- (instancetype)init __attribute__((unavailable("init not available. Use initWithDate:timeZone:latitude:longitude: instead")));

@end

NS_ASSUME_NONNULL_END
