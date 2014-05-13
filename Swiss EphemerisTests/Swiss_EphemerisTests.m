//
//  Swiss_EphemerisTests.m
//  Swiss EphemerisTests
//
//  Created by Regina Snape on 2/26/14.
//  Copyright (c) 2014 Coach Roebuck. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Swiss_Ephemeris.h"

@interface Swiss_EphemerisTests : XCTestCase

@end

@implementation Swiss_EphemerisTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//Covers ranges from ??? to 3000 BC - 3000 AD
- (void) test01_testAstrology {
    double latitude = 38.349819;
    double longitude = -81.632622;
    
    Swiss_Ephemeris * swissEphemeris = [Swiss_Ephemeris new];
    [swissEphemeris calculateAstrology:nil
                                        lat:latitude
                                        lon:longitude
                                       elev:0
                                       year:-3003
                                      month:2
                                        day:1
                                       hour:22
                                     minute:30
                                 lastPlanet:SE_CHIRON
                                 logResults:1];
}


/**
 Pinpoints the exact date and time in which a planet entered a sign throughout history.
 **/
- (void) test03_testSlowPlanetSignCalendar {
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int totalPastResults = 30;
    int currentPastResults = 0;
    double latitude = -111.933333;
    double longitude = 40.566667;
    Swiss_Ephemeris * swissEphemeris = [Swiss_Ephemeris new];
    int planetIndex = SE_MERCURY;
    int signIndex = SE_SIGN_Aquarius;
    char * target = [swissEphemeris planetNameAtIndex:planetIndex];
    char * sign = [swissEphemeris signNameAtIndex:signIndex];
    NSDate *  date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    double daysToAdd = -1;
    const char * utf8String = nil;
    char * prevSign = nil;
    BOOL pinPointing = NO;
    BOOL didChangeTimeToAdd = NO;
    int direction = 0;
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    printf("\n\nFinding last time %s was in %s\n",
           target,
           sign);
    
    while(currentPastResults < totalPastResults)
    {
        char * signName;
        NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
        
        [swissEphemeris calculateAstrology:nil
                                       lat:latitude
                                       lon:longitude
                                      elev:0
                                      year:comp.year
                                     month:comp.month
                                       day:comp.day
                                      hour:comp.hour
                                    minute:comp.minute
                                lastPlanet:SE_CHIRON
                                logResults:0];
        signName = [swissEphemeris signForPlanet:planetIndex];
        utf8String = [[dateFormatter stringFromDate:date] UTF8String];
        
        int compare = strcmp(sign, signName);
  
        if(compare == 0 && !pinPointing)
        {
            pinPointing = YES;
        }
        else if(compare == 0 && didChangeTimeToAdd)
        {
            daysToAdd *= -0.5;
            didChangeTimeToAdd = NO;
        }
        else if(pinPointing && compare != 0 && !didChangeTimeToAdd)
        {
            daysToAdd *= -0.5;
            didChangeTimeToAdd = YES;
            
        }
        else if(pinPointing && compare != 0 && didChangeTimeToAdd)
        {
            daysToAdd *= 0.5;
            didChangeTimeToAdd = YES;
            
        }
        
        prevSign = signName;
        
        if(comp.year <= 0)
            break;
        
        NSDate * nextDate = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        NSTimeInterval currentTimeInterval = [date timeIntervalSince1970];
        NSTimeInterval nextTimeInterval = [nextDate timeIntervalSince1970];
        
        if(fabs(currentTimeInterval - nextTimeInterval) < 100)
        {
            printf("**********\t%s: %s was in %s\t**********\n",
                   utf8String,
                   target,
                   sign);
            daysToAdd = -1;
            currentPastResults++;
            date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
            prevSign = nil;
            direction = 0;
            pinPointing = NO;
            didChangeTimeToAdd = NO;
        }
        else
        {
            date = nextDate;
        }
        
    }
    
    printf("\n\n");
}

/**
 Pinpoints the exact date and time in which a planet entered a sign throughout history.
 **/
- (void) test03_testSlowPlanetAspectCalendar {
    Swiss_Ephemeris * swissEphemeris = [Swiss_Ephemeris new];
    int planetIndex = SE_JUPITER;
    int targetIndex = SE_URANUS;
    int 	aspectIndex = SE_ASPECT_Square;
    char * target = [swissEphemeris planetNameAtIndex:planetIndex];
    char * planet = [swissEphemeris planetNameAtIndex:targetIndex];
    char * aspectAngleName = [swissEphemeris aspectNameAtIndex:aspectIndex];
    double aspectAngleValue = [swissEphemeris aspectAngleAtIndex:aspectIndex];
    NSDate *  date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int totalPastResults = 30;
    int currentPastResults = 0;
    double latitude = -111.933333;
    double longitude = 40.566667;
    double daysToAdd = -1;
    const char * utf8String = nil;
    BOOL pinPointing = NO;
    BOOL didChangeTimeToAdd = NO;
    int direction = 0;
    
    printf("\n\nPrevious Calendar When %s Was %s %s (%f degrees)\n",
           target,
           planet,
           aspectAngleName,
           aspectAngleValue);

    while(currentPastResults < totalPastResults)
    {
        NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
      
        [swissEphemeris calculateAstrology:nil
                                       lat:latitude
                                       lon:longitude
                                      elev:0
                                      year:comp.year
                                     month:comp.month
                                       day:comp.day
                                      hour:comp.hour
                                    minute:comp.minute
                                lastPlanet:SE_CHIRON
                                logResults:0];
        
        char * nextAspectAngleName = [swissEphemeris aspectNameForFirstPlanet:planetIndex secondPlanet:targetIndex];
        //double nextAspectAngleValue = [swissEphemeris aspectAngleForFirstPlanet:planetIndex secondPlanet:targetIndex];
        utf8String = [[dateFormatter stringFromDate:date] UTF8String];
        
        int compare = strcmp(aspectAngleName, nextAspectAngleName);
        
        if(compare == 0 && !pinPointing)
        {
            pinPointing = YES;
        }
        else if(compare == 0 && didChangeTimeToAdd)
        {
            daysToAdd *= -0.5;
            didChangeTimeToAdd = NO;
        }
        else if(pinPointing && compare != 0 && !didChangeTimeToAdd)
        {
            daysToAdd *= -0.5;
            didChangeTimeToAdd = YES;
            
        }
        else if(pinPointing && compare != 0 && didChangeTimeToAdd)
        {
            daysToAdd *= 0.5;
            didChangeTimeToAdd = YES;
            
        }
        
        if(comp.year <= 0)
            break;
        
        NSDate * nextDate = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        NSTimeInterval currentTimeInterval = [date timeIntervalSince1970];
        NSTimeInterval nextTimeInterval = [nextDate timeIntervalSince1970];
        
        if(fabs(currentTimeInterval - nextTimeInterval) < 100)
        {
            printf("%s\n", utf8String);
            daysToAdd = -1;
            currentPastResults++;
            date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
            direction = 0;
            pinPointing = NO;
            didChangeTimeToAdd = NO;
        }
        else
        {
            date = nextDate;
        }
        
    }
    
    printf("\n\n");
}

//Reference: http://www.configurationhunter.com/astrology-tools/planet_aspects
//Moon Calendar Reference: http://www.lunarium.co.uk/calendar/universal.jsp?calendarYear=2014&calendarMonth=3
//Full Moon Calendar: http://www.fullmoon.info/en/fullmoon-calendar.html
//Moon Phases: http://www.eyeofhorus.biz/info/moon-lore/2014-full-moon-phase/
- (void) test05_testQuickPlanetAspectCalendar {
    
    int totalResults = 50;
    double latitude = -111.933333;
    double longitude = 40.566667;
    Swiss_Ephemeris * swissEphemeris = [Swiss_Ephemeris new];
    int planetIndex = SE_JUPITER;
    int targetIndex = SE_URANUS;
    int 	aspectIndex = SE_ASPECT_Square;
    char * target = [swissEphemeris planetNameAtIndex:planetIndex];
    char * planet = [swissEphemeris planetNameAtIndex:targetIndex];
    char * aspect = [swissEphemeris aspectNameAtIndex:aspectIndex];
    double angle = [swissEphemeris aspectAngleAtIndex:aspectIndex];
    NSDate *  date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    printf("\n\nPrevious Calendar When %s Was %s %s (%f degrees)\n",
           target,
           aspect,
           planet,
           angle);
    
    NSArray * results = [swissEphemeris quickCalendarForFirstPlanet:planetIndex
                                                  secondPlanet:targetIndex
                                                   aspectIndex:aspectIndex
                                                          date:date
                                                      latitude:latitude
                                                     longitude:longitude
                                             calendarDirection:HCalendarPast
                                                  totalResults:totalResults];
    
    
    for(NSDate * nextDate in results)
    {
        printf("%s\n", [[dateFormatter stringFromDate:nextDate] UTF8String]);
    }

    printf("\n\n");
}

- (void) test07_testQuickPlanetSignCalendar {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    Swiss_Ephemeris * swissEphemeris = [Swiss_Ephemeris new];
    int planetIndex = SE_VENUS;
    int signIndex = SE_SIGN_Leo;
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    printf("\n\nQuick Find for %s in %s\n",
           [swissEphemeris planetNameAtIndex:planetIndex],
           [swissEphemeris signNameAtIndex:signIndex]);
    
    NSArray * results = [swissEphemeris quickCalendarForPlanet:planetIndex
                                           sign:signIndex
                                           date:[NSDate date]
                                       latitude:-111.933333
                                      longitude:40.566667
                              calendarDirection:HCalendarPast
                                   totalResults:50];
    
    for(NSDictionary * dict in results)
    {
        NSDate * nextDate = dict[@"DATE"];
        NSString * nextSign = dict[@"SIGN"];
        printf("%s: %s\n",
               [[dateFormatter stringFromDate:nextDate] UTF8String],
               [nextSign UTF8String]);
    }
    printf("\n\n");
}

@end
