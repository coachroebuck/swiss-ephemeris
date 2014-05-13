//
//  Swiss_Ephemeris.h
//  Swiss Ephemeris
//
//  Created by Regina Snape on 2/26/14.
//  Copyright (c) 2014 Coach Roebuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "swephexp.h" 	/* this includes  "sweodef.h" */

typedef enum : NSUInteger {
    SE_ASPECT_Unknown         = -1,
    SE_ASPECT_Conjunction     = 0,
    SE_ASPECT_SemiSextile,
    SE_ASPECT_SemiQuintile,
    SE_ASPECT_Nonagen,
    SE_ASPECT_SemiSquare,
    SE_ASPECT_Septile,
    SE_ASPECT_Sextile,
    SE_ASPECT_Quintile,
    SE_ASPECT_Square,
    SE_ASPECT_Trecile,
    SE_ASPECT_Trine,
    SE_ASPECT_Sesquisquare,
    SE_ASPECT_BiQuintile,
    SE_ASPECT_Quincunxe,
    SE_ASPECT_Opposite,
    SE_ASPECT_Parallel,
    SE_ASPECT_ContraParallel
} SE_ASPECTS;

typedef enum : NSUInteger {
    SE_SIGN_Unknown = -1,
    SE_SIGN_Aries   = 0,
    SE_SIGN_Taurus,
    SE_SIGN_Gemini,
    SE_SIGN_Cancer,
    SE_SIGN_Leo,
    SE_SIGN_Virgo,
    SE_SIGN_Libra,
    SE_SIGN_Scorpio,
    SE_SIGN_Sagittarius,
    SE_SIGN_Capricorn,
    SE_SIGN_Aquarius,
    SE_SIGN_Pisces
} SE_SIGNS;

typedef enum : NSUInteger {
    SE_HOUSE_Unknown    = -1,
    SE_HOUSE_First      = 0,
    SE_HOUSE_Second,
    SE_HOUSE_Third,
    SE_HOUSE_Fourth,
    SE_HOUSE_Fifth,
    SE_HOUSE_Sixth,
    SE_HOUSE_Seventh,
    SE_HOUSE_Eighth,
    SE_HOUSE_Ninth,
    SE_HOUSE_Tenth,
    SE_HOUSE_Eleventh,
    SE_HOUSE_Twelfth,
} SE_HOUSES;

typedef enum : NSInteger {
    HCalendarPast = -1,
    HCalendarFuture = 1,
    HCalendarUnknown = 0,
} HCalendarType;

@interface Swiss_Ephemeris : NSObject
///Covers the time range 13201 BC to AD 17191
//the moon moves 1 arc second in 2 time seconds and the sun 2.5 arc seconds in one minute
- (int) calculateAstrology:(char *)path
                       lat:(double)lat
                       lon:(double)lon
                      elev:(double)elev
                      year:(long)year
                     month:(long)month
                       day:(long)day
                      hour:(long)hour
                    minute:(long)minute
                lastPlanet:(int)lastPlanet
                logResults:(int)logResults;

- (int) calculateAstrologyFromPlanet:(int)firstPlanet
                          lastPlanet:(int)lastPlanet
                                path:(char *)path
                                 lat:(double)lat
                                 lon:(double)lon
                                elev:(double)elev
                                year:(long)year
                               month:(long)month
                                 day:(long)day
                                hour:(long)hour
                              minute:(long)minute
                          logResults:(int)logResults;

- (int) compareTwoPlanetsAtPath:(char *)path
                        planet1:(int)planet1
                        planet2:(int)planet2
                            lat:(double)lat
                            lon:(double)lon
                           elev:(double)elev
                           year:(long)year
                          month:(long)month
                            day:(long)day
                           hour:(long)hour
                         minute:(long)minute
                     aspectName:(char *)aspectName
                    aspectAngle:(double *)aspectAngle
                          exact:(BOOL)exact
                     logResults:(int)logResults;

/**
 Pinpoints the exact date and time in which a planet aspect began.
 Reference to compare: http://www.configurationhunter.com/astrology-tools/planet_aspects
 **/
- (NSArray *) quickCalendarForFirstPlanet:(int)firstPlanet
                        secondPlanet:(int)secondPlanet
                         aspectIndex:(int)aspectIndex
                                date:(NSDate *)date
                            latitude:(double)latitude
                           longitude:(double)longitude
                   calendarDirection:(int)calendarDirection
                        totalResults:(int)totalResults;

/**
 Pinpoints the exact date in which a planet enters a sign in the future.
 **/
//Moon Calendar Reference: http://www.lunarium.co.uk/calendar/universal.jsp?calendarYear=2014&calendarMonth=3
//Full Moon Calendar: http://www.fullmoon.info/en/fullmoon-calendar.html
//Moon Phases: http://www.eyeofhorus.biz/info/moon-lore/2014-full-moon-phase/
- (NSArray *)calendarForPlanet:(int)planet
                          sign:(int)sign
                          date:(NSDate *)date
                      latitude:(double)latitude
                     longitude:(double)longitude
             calendarDirection:(int)calendarDirection
                  totalResults:(int)totalResults;

- (NSArray *)quickCalendarForPlanet:(int)planet
                          sign:(int)sign
                          date:(NSDate *)date
                      latitude:(double)latitude
                     longitude:(double)longitude
             calendarDirection:(int)calendarDirection
                  totalResults:(int)totalResults;

+ (NSInteger) indexForPlanetName:(NSString *)planetName;

+ (NSInteger) indexForSignName:(NSString *)signName;

+ (NSInteger) indexForAspectName:(NSString *)aspectName;

+ (char *) planetNameAtIndex:(NSUInteger)index;

+ (char *) signNameAtIndex:(NSUInteger) index;

+ (char *) houseNameAtIndex:(NSUInteger) index;

+ (char *) aspectNameAtIndex:(NSUInteger)index;

+ (double) aspectAngleAtIndex:(NSUInteger)index;

+ (double) aspectAngleForAspectName:(char *)aspectName;

- (double) aspectAngleForFirstPlanet:(NSUInteger)firstPlanet
                        secondPlanet:(NSUInteger)secondPlanet;

- (char *) aspectNameForFirstPlanet:(NSUInteger)firstPlanet
                       secondPlanet:(NSUInteger)secondPlanet;

- (char *) signForPlanet:(NSUInteger)planet;

- (double) positionForPlanet:(NSUInteger)planet;

- (double) degreesForPlanet:(NSUInteger)planet;

- (double) minutesForPlanet:(NSUInteger)planet;

- (double) secondsForPlanet:(NSUInteger)planet;

- (int) houseNumberForPlanet:(NSUInteger)planet;

- (double) declinationForPlanet:(NSUInteger)planet;

- (int) retrogradeForPlanet:(NSUInteger)planet;

- (double) speedForPlanet:(NSUInteger)planet;

- (double) cuspValueForHouseNumber:(NSInteger) houseNumber;

- (double) degreesForHouseNumber:(NSInteger) houseNumber;

- (double) minutesForHouseNumber:(NSInteger) houseNumber;

- (double) secondsForHouseNumber:(NSInteger) houseNumber;

- (char *) signForHouseNumber:(NSInteger) houseNumber;

@end
