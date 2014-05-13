//
//  Swiss_Ephemeris.m
//  Swiss Ephemeris
//
//  Created by Regina Snape on 2/26/14.
//  Copyright (c) 2014 Coach Roebuck. All rights reserved.
//

#import "Swiss_Ephemeris.h"
#import "sweph.h"

#define BIT_ROUND_SEC               1
#define BIT_ROUND_MIN               2
#define BIT_ZODIAC                  4

#define SP_LUNAR_ECLIPSE            1
#define SP_SOLAR_ECLIPSE            2
#define SP_OCCULTATION              3
#define SP_RISE_SET                 4
#define SP_MERIDIAN_TRANSIT         5
#define SP_HELIACAL                 6

# define SP_MODE_HOW                2       /* an option for Lunar */
# define SP_MODE_LOCAL              8       /* an option for Solar */
# define SP_MODE_HOCAL              4096

# define ECL_LUN_PENUMBRAL          1       /* eclipse types for hocal list */
# define ECL_LUN_PARTIAL            2
# define ECL_LUN_TOTAL              3
# define ECL_SOL_PARTIAL            4
# define ECL_SOL_ANNULAR            5
# define ECL_SOL_TOTAL              6

#define MAX_MOON_SIGN_CHANGES       7
enum LocationDirectionType
{
	DIRECTION_NORTH,
	DIRECTION_SOUTH,
	DIRECTION_EAST,
	DIRECTION_WEST,
	DIRECTION_LATITUDE,
	DIRECTION_LONGITUDE
};

enum PinpointActionType
{
    PINPOINT_SIGNCHANGE,
    PINPOINT_MOONPHASECHANGE,
    PINPOINT_VOIDOFCOURSECHANGE
};

enum MoonPhaseType
{
    MOONPHASE_FULLMOON,
    MOONPHASE_NEWMOON
};

#define TEXT_CURRENT_DATE   @"Today's Date: "
#define TEXT_ARIES          @"Aries"
#define TEXT_TAURUS         @"Taurus"
#define TEXT_GEMINI         @"Gemini"
#define TEXT_CANCER         @"Cancer"
#define TEXT_LEO            @"Leo"
#define TEXT_VIRGO          @"Virgo"
#define TEXT_LIBRA          @"Libra"
#define TEXT_SCORPIO        @"Scorpio"
#define TEXT_SAGITTARIUS    @"Sagittarius"
#define TEXT_CAPRICORN      @"Capricorn"
#define TEXT_AQUARIUS       @"Aquarius"
#define TEXT_PISCES         @"Pisces"
#define TEXT_SUN            @"Sun"
#define TEXT_MOON           @"Moon"
#define TEXT_MERCURY        @"Mercury"
#define TEXT_VENUS          @"Venus"
#define TEXT_EARTH          @"Earth"
#define TEXT_MARS           @"Mars"
#define TEXT_JUPITER        @"Jupiter"
#define TEXT_SATURN         @"Saturn"
#define TEXT_URANUS         @"Uranus"
#define TEXT_NEPTUNE        @"Neptune"
#define TEXT_PLUTO          @"Pluto"
#define TEXT_WAXING         @"Waxing"
#define TEXT_WANING         @"Waning"
#define TEXT_FULLMOON       @"Full Moon"
#define TEXT_NEWMOON        @"New Moon"
#define TEXT_VOIDOFCOURSE   @"Void Of Course"
#define TEXT_7DAYFORECAST   @"Forecast"
#define TEXT_ABOUT          @"About"
#define TEXT_CONTACT        @"Contact"
#define TEXT_NONE           @"None"

#define APPLICATION_TOTAL_SECTIONS          1
#define APPLICATION_TOTAL_ROWS              5
#define APPLICATION_TABLE_HEIGHT            50
#define APPLICATION_FORECAST_TABLE_HEIGHT   50

#define MAIN_MOON_IN_SIGN                   0
#define MAIN_FULLORNEWMOON                  1
#define MAIN_WAXINGORWANING                 2
#define MAIN_VOIDOFCOURSE                   334
#define MAIN_7DAYFORECAST                   3
#define MAIN_ABOUT                          4
#define MAIN_CONTACT                        598

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//-----------------------------------------------------------------------------------------
//
//					APPLICATION DEFINED DATA
//
//-----------------------------------------------------------------------------------------
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#define NATALORB_CONJUNCTION	0       	//Opt #1 - Orb for chartwheel conjunctions (0 degrees)
#define NATALORB_SEMISEXTILE	30      	//Opt #7 - Orb for chartwheel semi-sextiles (30 degrees)
#define NATALORB_SEMIQUINTILE	36      	//Opt #11 - Orb for chartwheel semiquintiles (36 degrees)
#define NATALORB_NONAGEN	40      	//Opt #12 - Orb for chartwheel nonagens (40 degrees)
#define NATALORB_SEMISQUARE	45      	//Opt #8 - Orb for chartwheel semi-squares (45 degrees)
#define NATALORB_SEPTILE	51.42857	//Opt #16 - Orb for chartwheel septiles (51.42857 degrees)
#define NATALORB_SEXTILE	60      	//Opt #2 - Orb for chartwheel sextiles (60 degrees)
#define NATALORB_QUINTILE	72      	//Opt #13 - Orb for chartwheel quintiles (72 degrees)
#define NATALORB_SQUARE		90      	//Opt #3 - Orb for chartwheel squares (90 degrees)
#define NATALORB_TRECILE	108     	//Opt #14 - Orb for chartwheel treciles (108 degrees)
#define NATALORB_TRINE		120     	//Opt #4 - Orb for chartwheel trines (120 degrees)
#define NATALORB_SESQUISQUARE	135     	//Opt #9 - Orb for chartwheel sesquisquares (135 degrees)
#define NATALORB_BIQUINTILE	144     	//Opt #15 - Orb for chartwheel biquintiles (144 degrees)
#define NATALORB_QUINCUNXE	150     	//Opt #10 - Orb for chartwheel quincunxes (150 degrees)
#define NATALORB_OPPOSITE	180     	//Opt #5 - Orb for chartwheel oppositions (180 degrees)
#define NATALORB_PARALLEL	1       	//Opt #6 - Orb for chartwheel parallels and contra-parallels
#define NATALORB_CONTRAPARALLEL	1       	//Opt #6 - Orb for chartwheel parallels and contra-parallels

#define NATALORBRANGE_CONJUNCTION	8       //Opt #1 - Orb for chartwheel conjunctions (0 degrees)
#define NATALORBRANGE_SEMISEXTILE	1.5     //Opt #7 - Orb for chartwheel semi-sextiles (30 degrees)
#define NATALORBRANGE_SEMIQUINTILE	0       //Opt #11 - Orb for chartwheel semiquintiles (36 degrees)
#define NATALORBRANGE_NONAGEN		0       //Opt #12 - Orb for chartwheel nonagens (40 degrees)
#define NATALORBRANGE_SEMISQUARE	2.5     //Opt #8 - Orb for chartwheel semi-squares (45 degrees)
#define NATALORBRANGE_SEPTILE		1       //Opt #16 - Orb for chartwheel septiles (51.42857 degrees)
#define NATALORBRANGE_SEXTILE		6       //Opt #2 - Orb for chartwheel sextiles (60 degrees)
#define NATALORBRANGE_QUINTILE		1.5     //Opt #13 - Orb for chartwheel quintiles (72 degrees)
#define NATALORBRANGE_SQUARE		8       //Opt #3 - Orb for chartwheel squares (90 degrees)
#define NATALORBRANGE_TRECILE		0       //Opt #14 - Orb for chartwheel treciles (108 degrees)
#define NATALORBRANGE_TRINE		8       //Opt #4 - Orb for chartwheel trines (120 degrees)
#define NATALORBRANGE_SESQUISQUARE	2.5     //Opt #9 - Orb for chartwheel sesquisquares (135 degrees)
#define NATALORBRANGE_BIQUINTILE	1.5     //Opt #15 - Orb for chartwheel biquintiles (144 degrees)
#define NATALORBRANGE_QUINCUNXE		2.5     //Opt #10 - Orb for chartwheel quincunxes (150 degrees)
#define NATALORBRANGE_OPPOSITE		8       //Opt #5 - Orb for chartwheel oppositions (180 degrees)
#define NATALORBRANGE_PARALLEL		1       //Opt #6 - Orb for chartwheel parallels and contra-parallels
#define NATALORBRANGE_CONTRAPARALLEL		1       //Opt #6 - Orb for chartwheel parallels and contra-parallels

static double natal_orbit_numbers[] = {NATALORB_CONJUNCTION, NATALORB_SEMISEXTILE, NATALORB_SEMIQUINTILE, NATALORB_NONAGEN,
	NATALORB_SEMISQUARE, NATALORB_SEPTILE, NATALORB_SEXTILE, NATALORB_QUINTILE,
	NATALORB_SQUARE, NATALORB_TRECILE, NATALORB_TRINE, NATALORB_SESQUISQUARE,
	NATALORB_BIQUINTILE, NATALORB_QUINCUNXE, NATALORB_OPPOSITE, NATALORB_PARALLEL, NATALORB_CONTRAPARALLEL};

static double natal_orbit_ranges[] = 	{NATALORBRANGE_CONJUNCTION, NATALORBRANGE_SEMISEXTILE, NATALORBRANGE_SEMIQUINTILE,
	NATALORBRANGE_NONAGEN, NATALORBRANGE_SEMISQUARE, NATALORBRANGE_SEPTILE, NATALORBRANGE_SEXTILE,
	NATALORBRANGE_QUINTILE, NATALORBRANGE_SQUARE, NATALORBRANGE_TRECILE, NATALORBRANGE_TRINE,
	NATALORBRANGE_SESQUISQUARE, NATALORBRANGE_BIQUINTILE, NATALORBRANGE_QUINCUNXE,
	NATALORBRANGE_OPPOSITE, NATALORBRANGE_PARALLEL, NATALORBRANGE_CONTRAPARALLEL};

#define SE_SUN          0
#define SE_MOON         1
#define SE_MERCURY      2
#define SE_VENUS        3
#define SE_MARS         4
#define SE_JUPITER      5
#define SE_SATURN       6
#define SE_URANUS       7
#define SE_NEPTUNE      8
#define SE_PLUTO        9
#define SE_MEAN_NODE    10
#define SE_TRUE_NODE    11
#define SE_MEAN_APOG    12
#define SE_OSCU_APOG    13
#define SE_EARTH        14
#define SE_CHIRON       15
#define SE_PHOLUS       16
#define SE_CERES        17
#define SE_PALLAS       18
#define SE_JUNO         19
#define SE_VESTA        20
#define SE_INTP_APOG    21
#define SE_INTP_PERG    22

static char * planet_names[] = {
    SE_NAME_SUN,
    SE_NAME_MOON,
    SE_NAME_MERCURY,
    SE_NAME_VENUS,
    SE_NAME_MARS,
    SE_NAME_JUPITER,
    SE_NAME_SATURN,
    SE_NAME_URANUS,
    SE_NAME_NEPTUNE,
    SE_NAME_PLUTO,
    SE_NAME_MEAN_NODE,
    SE_NAME_TRUE_NODE,
    SE_NAME_MEAN_APOG,
    SE_NAME_OSCU_APOG,
    SE_NAME_EARTH,
    SE_NAME_CHIRON,
    SE_NAME_PHOLUS,
    SE_NAME_CERES,
    SE_NAME_PALLAS,
    SE_NAME_JUNO,
    SE_NAME_VESTA,
    SE_NAME_INTP_APOG,
    SE_NAME_INTP_PERG
};

static char* natal_orbit_text[] = {"Conjunct", "Semi-Sextile", "Semi-Quintile",
	"Nonagen", "Semi-Square", "Septile", "Sextile",
	"Quintile", "Square", "Trecile", "Trine",
	"Sesquisquare", "Biquintile", "Quincunxe",
	"Opposite", "Parallel", "Contra-Parallel"};

static char* astrological_signs[12] = {"Aries", "Taurus", "Gemini", "Cancer",
	"Leo", "Virgo", "Libra", "Scorpio",
	"Sagittarius", "Capricorn", "Aquarius", "Pisces"};

static char* house_text[] = {
    "First House",
    "Second House",
    "Third House",
    "Fourth House",
    "Fifth House",
    "Sixth House",
    "Seventh House",
    "Eighth House",
    "Ninth House",
    "Tenth House",
    "Eleventh House",
    "Twelfth House",
};

struct natalType
{
	double degrees;
	double minutes;
	double seconds;
	char sign[AS_MAXCH];
	char planet[AS_MAXCH];
	int house_number;
	double decl_latitude;
	double decl_longitude;
	double solstice_degrees;
	double solstice_minutes;
	char solstice_sign[AS_MAXCH];
	double lat_minutes;
	double declination;
	double position;
	double speedx;
	int retrograde;
} natal_info[SE_NPLANETS];

struct HouseCuspType
{
	double cusp_value;
	double degrees;
	double minutes;
	double seconds;
	char sign[AS_MAXCH];
} house_cusps[12];


static long aspect_matrix[SE_NPLANETS][SE_NPLANETS];

static inline void Convert360toDM(double* Q, double* z, double* z1, double* z2, double* z2a, double* z3)
{
	*z3 = floor(*z);
	*Q = floor(*z3/30) + 1;
    
	*z1 = *z3 / 30;
	*z1 -= floor(*z3/30);
	*z1 *= 30;
	*z1 *= 100;
	*z1 += 0.5;
	*z1 /= 100;
	//*z1 = RoundTo2Dec((*z3 / 30 - floor(*z3 / 30)) * 30);
	*z2a = (*z - *z3) * 60;
    *z2 = floor(*z2a + 0.5);
	if(*z2 >= 60)
		*z2 = 59;
}

//*************************************************************************************************************************
static inline void Convert360toDMS(double* Q, double* z, double* z1, double* z2, double* z2a, double* z3)
{
	*z3 = floor(*z);
	*Q = floor(*z3/30) + 1;
    
	*z1 = *z3 / 30;
	*z1 -= floor(*z3/30);
	*z1 *= 30;
	*z1 *= 100;
	*z1 += 0.5;
	*z1 /= 100;
	//*z1 = RoundTo2Dec((*z3 / 30 - floor(*z3 / 30)) * 30);
	*z2a = (*z - *z3) * 60;
    *z2 = floor(*z2a);
    *z2a = floor((*z2a - floor(*z2a)) * 60);
}

//*************************************************************************************************************************
static inline double CalcSPoint(double* Q, double z)
{
	double temp1 = z;
	double sPoint = 0;
    
	while(temp1 >= 30){temp1 -= 30;}
	switch((int)*Q)
	{
        case 1:
            *Q = 6;
            break;
        case 2:
            *Q = 5;
            break;
        case 3:
            *Q = 4;
            break;
        case 4:
            *Q = 3;
            break;
        case 5:
            *Q = 2;
            break;
        case 6:
            *Q = 1;
            break;
        case 7:
            *Q = 12;
            break;
        case 8:
            *Q = 11;
            break;
        case 9:
            *Q = 10;
            break;
        case 10:
            *Q = 9;
            break;
        case 11:
            *Q = 8;
            break;
        case 12:
            *Q = 7;
            break;
        default:
            break;
	}
	sPoint = (*Q - 1) * 30 + (30 - temp1);
	return sPoint;
}

//*************************************************************************************************************************
static inline int isValueWithinRange(double value, double target, double range)
{
    int retval = ((value >= (target - range)) && (value <= (target + range)));
	return retval;
}

//*************************************************************************************************************************
//the moon moves 1 arc second in 2 time seconds and the sun 2.5 arc seconds in one minute
static inline int calculateAstrology(char* path, double lat, double lon, double elev,
                                     long year, long month, long day, long hour, long minute,
                                     int first_planet, int Last_Planet, int logResults)
{
    char serr[AS_MAXCH];
	char t = 'P';
	double cusp[13];
	double ascmc[10];
	double tjd_ut = 0;
	double tjd_et = 0;
	double retval = 0;
	double OB = 0;
	double xx[6];
	double sidTime = 0;
	double CorrPlanetsY = 0;
	double Q = 0;
	double z = 0;
	double z1 = 0;
	double z2 = 0;
	double z2a = 0;
	double z3 = 0;
	long iflgret = 0;
	//long cal = 103;  //g for gregorian calendar
	int j = 0;
	int i = 0;
	int k = 0;
	long bNext = 0;
	double da = 0;
	int bParallel = 0;
	int totalNatalValues = sizeof(natal_orbit_numbers) / sizeof(double);
	
	//---------------------------------------------------------------------
	//initialization
	//---------------------------------------------------------------------
    swe_set_ephe_path(path);    //set directory path of ephemeris files
   	//swe_set_jpl_file(); //set name of JPL ephemeris file
    //swe_set_topo(lon, lat, elev);
    
	for(i = first_planet; i <= Last_Planet; i++)
	{
		natal_info[i].degrees = 0;
		natal_info[i].minutes = 0;
		natal_info[i].seconds = 0;
		memset(natal_info[i].sign, 0, AS_MAXCH);
		memset(natal_info[i].planet, 0, AS_MAXCH);
		natal_info[i].house_number = 0;
		natal_info[i].decl_latitude = 0;
		natal_info[i].decl_longitude = 0;
		natal_info[i].declination = 0;
		natal_info[i].position = 0;
		natal_info[i].speedx = 0;
		natal_info[i].retrograde = 0;
		natal_info[i].solstice_degrees = 0;
		natal_info[i].solstice_minutes = 0;
		memset(natal_info[i].solstice_sign, 0, AS_MAXCH);
        
	}
    
	for(i = 0; i < 12; i++)
	{
		house_cusps[i].cusp_value =  0;
		house_cusps[i].degrees = 0;
		house_cusps[i].minutes = 0;
		house_cusps[i].seconds = 0;
		memset(house_cusps[i].sign, 0, AS_MAXCH);
	}
	
	for(i = first_planet; i <= Last_Planet; i++)
	{
		for(j = first_planet; j <= Last_Planet; j++)
		{
			aspect_matrix[i][j] = -1;
		}
	}
	for(i = 0; i < 10; i++){ascmc[i] = 0;}
	for(i = 0; i < 13; i++){cusp[i] = 0;}
    
	//---------------------------------------------------------------------
	//get the julian time; set locations, etc.
	//---------------------------------------------------------------------
	//hour = hour + (minute / 60);
    //tjd_ut = swe_julday(year, month, day, hour, 1);
    //retval = swe_date_conversion(year, month, day, hour, (char)cal, &tjd_ut);
	//tjd_et = tjd_ut + swe_deltat(tjd_ut);
    
    //2011-10-02: the new, and (hopefully) improved way of calculating the date
    double dret[2];
    double d_timezone = 0;
    int iyear_utc = 0;
    int imonth_utc = 0;
    int iday_utc = 0;
    int ihour_utc = 0;
    int imin_utc = 0;
    double dsec_utc = 0;
    int32 gregflag = SE_GREG_CAL;
    
    /* if date and time is in time zone different from UTC, the time zone offset must be subtracted
     * first in order to get UTC: */
    swe_utc_time_zone(year, month, day, hour, minute, 0, d_timezone,
                      &iyear_utc, &imonth_utc, &iday_utc, &ihour_utc, &imin_utc, &dsec_utc);
    /* calculate Julian day number in UT (UT1) and ET (TT) from UTC */
    retval = swe_utc_to_jd (iyear_utc, imonth_utc, iday_utc, ihour_utc, imin_utc, dsec_utc, gregflag, dret, serr);
    if (retval == ERR) {
        //fprintf(stderr, serr);  /* error handling */
    }
    tjd_et = dret[0];  /* this is ET (TT) */
    tjd_ut = dret[1];  /* this is UT (UT1) */
	
	//---------------------------------------------------------------------
	//perform calculations
	//---------------------------------------------------------------------
	for(i = first_planet; i <= Last_Planet; i++)
	{
		for(j = 0; j < 6; j++){xx[j] = 0;}	//reset our array
		swe_get_planet_name(i, natal_info[i].planet);	//get the planet name
		//iflag = 258;                     //for geo
		retval = swe_calc(tjd_et, i, 258 /*| SEFLG_TOPOCTR*/, xx, serr);	//get some calculations
		
		natal_info[i].position = xx[0];	//this is the planet calculation
		natal_info[i].speedx = xx[3];	//this is the planet calculation
        
		//iflag = iflag + 2048;
        retval = swe_calc(tjd_et, i, 2309 /*| SEFLG_TOPOCTR*/, xx, serr);	//get some more calculations
		natal_info[i].declination = xx[1];	//this is the declination
		natal_info[i].retrograde = (natal_info[i].speedx < 0 ? 1 : 0);	//determine if the planet is in retrograde
	}
    
	retval = swe_houses(tjd_ut, lat, lon, t, cusp, ascmc);         //tropical
	iflgret = swe_calc(tjd_et, -1, 0, xx, serr);
    OB = xx[0];
	sidTime = ascmc[2];	//save sidereal time for later conversion
    
    swe_close();
    
	//---------------------------------------------------------------------
	//determine the house that each planet is currently residing
	//---------------------------------------------------------------------
	for(j = first_planet; j <= Last_Planet; j++)
	{
		bNext = 0;
		for(i = 1; i <= 12 && !bNext; i++)
		{
			CorrPlanetsY = natal_info[j].position + (1 / 36000);
			if(i < 12 && cusp[i] > cusp[i + 1])
			{
				if((CorrPlanetsY >= cusp[i] && CorrPlanetsY < 360)
                   || (CorrPlanetsY < cusp[i + 1] && CorrPlanetsY >= 0))
				{
					natal_info[j].house_number = i;
					bNext = 1;
				}
			}
			else if(i == 12 && cusp[i] > cusp[1])
			{
				if((CorrPlanetsY >= cusp[i] && CorrPlanetsY < 360)
                   || (CorrPlanetsY < cusp[1] && CorrPlanetsY >= 0))
				{
					natal_info[j].house_number = i;
					bNext = 1;
				}
			}
			else if(i < 12 && CorrPlanetsY >= cusp[i] && CorrPlanetsY < cusp[i + 1])
			{
				natal_info[j].house_number = i;
				bNext = 1;
			}
			else if(i == 12 && CorrPlanetsY >= cusp[i] && CorrPlanetsY < cusp[1])
			{
				natal_info[j].house_number = i;
				bNext = 1;
			}
		}
	}
	
	//---------------------------------------------------------------------
	//determine the sign that resides in each house
	//---------------------------------------------------------------------
	for(i = 1; i <= 12; i++)
	{
		Q = 0;
		z = cusp[i];
		z1 = 0;
		z2 = 0;
		z2a = 0;
		z3 = 0;
        
		Convert360toDM(&Q, &z, &z1, &z2, &z2a, &z3);
		house_cusps[i - 1].cusp_value =  cusp[i];
		house_cusps[i - 1].degrees = z1;
		house_cusps[i - 1].minutes = z2;
		house_cusps[i - 1].seconds = z2a;
		sprintf(house_cusps[i - 1].sign, "%s", astrological_signs[(int)Q - 1]);
        
		//if(logResults)
        // {
        // printf("house %d: [%f]; %02.0f %s %02.0f \n",
        // i,
        // house_cusps[i - 1].cusp_value,
        // house_cusps[i - 1].degrees,
        // house_cusps[i - 1].sign,
        // house_cusps[i - 1].minutes);
        // }
	}
    
	//---------------------------------------------------------------------
	//determine the planet list
	//---------------------------------------------------------------------
    if(logResults)
    {
        printf("Planet Name|degrees|sign|minutes|seconds|house #|declination latitude|longitude|"
               "solstice degrees|sign|minutes|seconds|retrograde|\n");
   }
	for(i = first_planet; i <= Last_Planet; i++)
	{
		z = natal_info[i].position;
		Q = 0;
		z1 = 0;
		z2 = 0;
		z2a = 0;
		z3 = 0;
        
		Convert360toDMS(&Q, &z, &z1, &z2, &z2a, &z3);
		
		natal_info[i].degrees = z1;		//degrees
		natal_info[i].minutes = z2;		//minutes
		natal_info[i].seconds = z2a;	//seconds
		sprintf(natal_info[i].sign, "%s", astrological_signs[(int)Q - 1]);
		
		//figure out the sign of the declinations
		z = natal_info[i].declination;
		if(z < 0) z = -z;	//absolute value
		Q = 0;
		z1 = 0;
		z2 = 0;
		z2a = 0;
		z3 = 0;
        
		Convert360toDM(&Q, &z, &z1, &z2, &z2a, &z3);
		natal_info[i].decl_latitude = z1;
		natal_info[i].decl_longitude = z2;
        
		//we'll need to grab this once more...
		z = natal_info[i].position;
		Q = 0;
		z1 = 0;
		z2 = 0;
		z2a = 0;
		z3 = 0;
        
		Convert360toDM(&Q, &z, &z1, &z2, &z2a, &z3);
		z = CalcSPoint(&Q, z);
		Convert360toDM(&Q, &z, &z1, &z2, &z2a, &z3);
		natal_info[i].solstice_degrees = z1;
		natal_info[i].solstice_minutes = z2;
		sprintf(natal_info[i].solstice_sign, "%s", astrological_signs[(int)Q - 1]);
		
		if(logResults)
		{
			printf("%10s: %02.0f %s %02.0fm %02.0fs\t(House %d)\t%02.0f %c %02.0f\t%02.0f %s %02.0f\t%s\n",
                   natal_info[i].planet,
                   natal_info[i].degrees,
                   natal_info[i].sign,
                   natal_info[i].minutes,
                   natal_info[i].seconds,
                   natal_info[i].house_number,
                   natal_info[i].decl_latitude,
                   (natal_info[i].declination >= 0 ? 'N' : 'S'),
                   natal_info[i].decl_longitude,
                   natal_info[i].solstice_degrees,
                   natal_info[i].solstice_sign,
                   natal_info[i].solstice_minutes,
                   (natal_info[i].retrograde == 1 ? "RETROGRATE" : ""));
		}
	}
    
	//---------------------------------------------------------------------
	//finally, calculate the aspects
	//---------------------------------------------------------------------
	for(i = first_planet; i <= Last_Planet; i++)
	{
		for(j = Last_Planet; j >= first_planet; j--)
		{
			da = 0;
			bParallel = 0;
			if(i == j)
				continue;
            
			//parallels of declination
			if(i > j)
			{
				da = abs(natal_info[i].declination - natal_info[j].declination);
				if(da > natal_orbit_numbers[totalNatalValues - 1])
					continue;
				if((natal_info[i].declination >= 0 && natal_info[j].declination >= 0)
                   || (natal_info[i].declination < 0 && natal_info[j].declination < 0))
				{
					aspect_matrix[i][j] = totalNatalValues - 2;
					bParallel = 1;
				}
				if((natal_info[i].declination >= 0 && natal_info[j].declination < 0)
                   || (natal_info[i].declination < 0 && natal_info[j].declination >= 0))
				{
					aspect_matrix[i][j] = totalNatalValues - 1;
					bParallel = 1;
				}
			}
            
			//longitude aspects
			if(!bParallel)
			{
				da = abs(natal_info[i].position - natal_info[j].position);
				if(da > 180)
					da = 360 - da;
				for(k = 0; k < totalNatalValues && aspect_matrix[i][j] == -1; k++)
				{
					aspect_matrix[i][j] = (isValueWithinRange(da, natal_orbit_numbers[k], natal_orbit_ranges[k]) ? k : -1);
				}
			}
            
            //If we were unable to determine an aspect,
            //  store the angle found.
            if(aspect_matrix[i][j] == -1)
            {
                aspect_matrix[i][j] = da;
            }
		}
	}
    
	if(logResults)
	{
		printf("\nNATAL PLANET ASPECTS TO NATAL PLANETS\n");
		for(i = first_planet; i <= Last_Planet; i++)
		{
			printf("%s\n", natal_info[i].planet);
			for(j = first_planet; j <= Last_Planet; j++)
			{
				if(i != j && !(i == SE_EARTH || j == SE_EARTH) && aspect_matrix[i][j] != -1)
				{
                    char * orbitText = (aspect_matrix[i][j] < 17 ?
                                        natal_orbit_text[aspect_matrix[i][j]] :
                                        "None");
                    double orbitAngle = (aspect_matrix[i][j] < 17 ?
                                         natal_orbit_numbers[aspect_matrix[i][j]] :
                                         aspect_matrix[i][j]);
					printf("\t%s: %s (%f)\n",
                           natal_info[j].planet,
                           orbitText,
                           orbitAngle);
				}
			}
		}
	}
    
	return 0;
}

//*************************************************************************************************************************
static inline int compareTwoPlanetsAtPath(char* path, int planet1, int planet2,
                                           double lat, double lon, double elev,
                                           long year, long month, long day,
                                           long hour, long minute,
                                           char * aspectName, double * aspectAngle,
                                           bool exact, int logResults)
{
    char serr[AS_MAXCH];
	double tjd_ut = 0;
	double tjd_et = 0;
	double retval = 0;
	double xx[6];
	int j = 0;
	int i = 0;
	int k = 0;
	double da = 0;
	int bParallel = 0;
    struct natalType natalInfo[2];
    int planetId[2] = {planet1, planet2};
    int aspect = -1;
	int totalNatalValues = sizeof(natal_orbit_numbers) / sizeof(double);
	
	//---------------------------------------------------------------------
	//initialization
	//---------------------------------------------------------------------
    swe_set_ephe_path(path);    //set directory path of ephemeris files
    
	for(i = 0; i < 2; i++)
	{
		natalInfo[i].degrees = 0;
		natalInfo[i].minutes = 0;
		natalInfo[i].seconds = 0;
		memset(natalInfo[i].sign, 0, AS_MAXCH);
		memset(natalInfo[i].planet, 0, AS_MAXCH);
		natalInfo[i].house_number = 0;
		natalInfo[i].decl_latitude = 0;
		natalInfo[i].decl_longitude = 0;
		natalInfo[i].declination = 0;
		natalInfo[i].position = 0;
		natalInfo[i].speedx = 0;
		natalInfo[i].retrograde = 0;
		natalInfo[i].solstice_degrees = 0;
		natalInfo[i].solstice_minutes = 0;
		memset(natalInfo[i].solstice_sign, 0, AS_MAXCH);
        
	}
	
	//---------------------------------------------------------------------
	//get the julian time; set locations, etc.
	//---------------------------------------------------------------------
	double dret[2];
    double d_timezone = 0;
    int iyear_utc = 0;
    int imonth_utc = 0;
    int iday_utc = 0;
    int ihour_utc = 0;
    int imin_utc = 0;
    double dsec_utc = 0;
    int32 gregflag = SE_GREG_CAL;
    
    /* if date and time is in time zone different from UTC, the time zone offset must be subtracted
     * first in order to get UTC: */
    swe_utc_time_zone(year, month, day, hour, minute, 0, d_timezone,
                      &iyear_utc, &imonth_utc, &iday_utc, &ihour_utc, &imin_utc, &dsec_utc);
    /* calculate Julian day number in UT (UT1) and ET (TT) from UTC */
    retval = swe_utc_to_jd (iyear_utc, imonth_utc, iday_utc, ihour_utc, imin_utc, dsec_utc, gregflag, dret, serr);
    if (retval == ERR) {
        //fprintf(stderr, serr);  /* error handling */
    }
    tjd_et = dret[0];  /* this is ET (TT) */
    tjd_ut = dret[1];  /* this is UT (UT1) */
	
	//---------------------------------------------------------------------
	//perform calculations
	//---------------------------------------------------------------------
	for(i = 0; i < 2; i++)
	{
		for(j = 0; j < 6; j++){xx[j] = 0;}	//reset our array
		swe_get_planet_name(planetId[i], natalInfo[i].planet);	//get the planet name
		retval = swe_calc(tjd_et, planetId[i], 258, xx, serr);	//get some calculations
		
		natalInfo[i].position = xx[0];	//this is the planet calculation
		natalInfo[i].speedx = xx[3];	//this is the planet calculation
        
        retval = swe_calc(tjd_et, planetId[i], 2309, xx, serr);	//get some more calculations
		natalInfo[i].declination = xx[1];	//this is the declination
		natalInfo[i].retrograde = (natalInfo[i].speedx < 0 ? 1 : 0);	//determine if the planet is in retrograde
	}
    
    swe_close();
    
	//---------------------------------------------------------------------
	//finally, calculate the aspects
	//---------------------------------------------------------------------
    da = 0;
    bParallel = 0;
    
    //parallels of declination
    da = (natalInfo[0].declination - natalInfo[1].declination);
    if(da < 0) da = -da;
    if(da <= natal_orbit_numbers[totalNatalValues - 1])
    {
        if((natalInfo[0].declination >= 0 && natalInfo[1].declination >= 0)
           || (natalInfo[0].declination < 0 && natalInfo[1].declination < 0))
        {
            aspect = totalNatalValues - 2;
            bParallel = 1;
        }
        if((natalInfo[0].declination >= 0 && natalInfo[1].declination < 0)
           || (natalInfo[0].declination < 0 && natalInfo[1].declination >= 0))
        {
            aspect = totalNatalValues - 1;
            bParallel = 1;
        }
    }
    
    //longitude aspects
    if(!bParallel)
    {
        da = (natalInfo[0].position - natalInfo[1].position);
        if(da < 0) da = -da;
        if(da > 180)
            da = 360 - da;
        
        //retain the angle
        *aspectAngle = da;
        for(k = 0; k < totalNatalValues && aspect == -1; k++)
        {
            aspect = (isValueWithinRange(da, natal_orbit_numbers[k],
                                         (exact ? 0 : natal_orbit_ranges[k]))
                      ? k
                      : -1);
        }
    }
    
    if(aspect != -1)
    {
        sprintf(aspectName, "%s", natal_orbit_text[aspect]);
        *aspectAngle = natal_orbit_numbers[aspect];

        if(logResults)
        {
            printf("%s is %s %s at %f\n",
                   natalInfo[0].planet,
                   aspectName,
                   natalInfo[1].planet,
                   *aspectAngle);
        }
    }
    
    
	return 0;
}

@interface Swiss_Ephemeris ()

@property (copy, nonatomic) NSDateFormatter * dateFormatter;

@end

@implementation Swiss_Ephemeris

- (id) init {
    if((self = [super init]))
    {
        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    }
    
    return self;
}

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
                logResults:(int)logResults
{
    
    return calculateAstrology(path, lat, lon, elev, year, month, day, hour, minute, SE_SUN, lastPlanet, logResults);
    
}

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
                          logResults:(int)logResults
{
    
    return calculateAstrology(path, lat, lon, elev, year, month, day, hour, minute, firstPlanet, lastPlanet, logResults);
    
}

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
                logResults:(int)logResults
{
    return compareTwoPlanetsAtPath(path, planet1, planet2, lat, lon, elev, year, month, day, hour, minute, aspectName, aspectAngle, exact, logResults);
}

- (NSArray *) quickCalendarForFirstPlanet:(int)firstPlanet
                             secondPlanet:(int)secondPlanet
                              aspectIndex:(int)aspectIndex
                                     date:(NSDate *)date
                                 latitude:(double)latitude
                                longitude:(double)longitude
                        calendarDirection:(int)calendarDirection
                             totalResults:(int)totalResults {

    NSMutableArray * array = [NSMutableArray new];
    BOOL doChangeDirections = NO;
    double targetAngle = [Swiss_Ephemeris aspectAngleAtIndex:aspectIndex];
    const char * aspectName = [Swiss_Ephemeris aspectNameAtIndex:aspectIndex];
    double daysToAdd = calendarDirection;
    double massiveSkip = 0;
    int direction = calendarDirection;
    int lastPlanet = (firstPlanet > secondPlanet ? firstPlanet : secondPlanet);
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeInterval earliestTime = [date timeIntervalSince1970];
    NSTimeInterval previousTime = [date timeIntervalSince1970];
    NSTimeInterval firstTime = [date timeIntervalSince1970];
    NSDateComponents * comp = [calendar components:unitFlags fromDate:date];
    

    while(array.count < totalResults && comp.year > 0)
    {
        [self calculateAstrologyFromPlanet:firstPlanet
                                lastPlanet:lastPlanet
                                      path:nil
                                       lat:latitude
                                       lon:longitude
                                      elev:0
                                      year:comp.year
                                     month:comp.month
                                       day:comp.day
                                      hour:comp.hour
                                    minute:comp.minute
                                logResults:0];
        
        double speed1 = [self speedForPlanet:firstPlanet];
        double speed2 = [self speedForPlanet:secondPlanet];
        double position1 = [self positionForPlanet:firstPlanet];
        double position2 = [self positionForPlanet:secondPlanet];
        double officialAspectAngle = [self aspectAngleForFirstPlanet:firstPlanet
                                      secondPlanet:secondPlanet];
        double floored = officialAspectAngle - floor(officialAspectAngle);
        const char * utf8String = [[self.dateFormatter stringFromDate:date] UTF8String];
        double clockwiseAngle = (position1 > position2 ? ((360 - position1) + position2) : ((360 - position2) + position1));
        double counterClockwiseAngle = (position1 > position2 ? position1 - position2 : position2 - position1);
        double shorterAngle = (clockwiseAngle < counterClockwiseAngle ? clockwiseAngle : counterClockwiseAngle);
        double angleDiff = fabs(targetAngle - shorterAngle);

        printf("%s: dir=%d %s:%f, %f; %s:%f, %f; angle: %f official=%f aspect=%s\n",
               utf8String,
               direction,
               [Swiss_Ephemeris planetNameAtIndex:firstPlanet],
               position1,
               speed1,
               [Swiss_Ephemeris planetNameAtIndex:secondPlanet],
               position2,
               speed2,
               shorterAngle,
               (officialAspectAngle > 0 && officialAspectAngle < 360 ? officialAspectAngle : -1),
               (floored == 0 ? aspectName : ""));
        
        if([[NSDate dateWithTimeIntervalSince1970:earliestTime] compare:date] == NSOrderedDescending)
            earliestTime = [date timeIntervalSince1970];
        
//        if(doFindDistanceRequired)
//        {
//            doFindDistanceRequired = NO;
//            daysToAdd = [self daysToAddToReachAngle:angleDiff
//                                                        speed1:speed1
//                                                        speed2:speed2
//                                                     direction:direction];
//        }
        if((direction > 0 && shorterAngle > targetAngle)
                || (direction < 0 && shorterAngle < targetAngle))
        {
            doChangeDirections = YES;
        }
        
        if(doChangeDirections)
        {
            doChangeDirections = !doChangeDirections;
            
            //change directions
            direction = -direction;
            
            double nextDaysToAdd = [self daysToAddToReachAngle:angleDiff
                                                        speed1:speed1
                                                        speed2:speed2
                                                     direction:direction];
            NSDate * nextDate = [date dateByAddingTimeInterval:60*60*24*nextDaysToAdd];
            NSTimeInterval timeSinceFirstDate = [nextDate timeIntervalSince1970];
            NSTimeInterval timeSinceCurrentDate = [date timeIntervalSince1970];
            NSTimeInterval timediff = timeSinceFirstDate - timeSinceCurrentDate;
            
            if(fabs(nextDaysToAdd) > fabs(daysToAdd))
                nextDaysToAdd = direction * (fabs(daysToAdd) * 0.5);
            
            if(fabs(timediff) < 100 || nextDaysToAdd < 0.000001)
            {
                [array addObject:date];
                daysToAdd = calendarDirection;
                direction = calendarDirection;
                previousTime = [date timeIntervalSince1970];
                firstTime = [date timeIntervalSince1970];
                
                //if(massiveSkip == 0)
                    massiveSkip = [self daysToAddToReachAngle:180
                                                            speed1:speed1
                                                            speed2:speed2
                                                         direction:direction];
                
                date = [NSDate dateWithTimeIntervalSince1970:earliestTime];
                date = [date dateByAddingTimeInterval:60*60*24*massiveSkip];
                comp = [calendar components:unitFlags fromDate:date];
                continue;
            }
            else
            {
                daysToAdd = nextDaysToAdd;
            }
        }
        else if(angleDiff > 2)
        {
            daysToAdd = [self daysToAddToReachAngle:angleDiff
                                             speed1:speed1
                                             speed2:speed2
                                          direction:direction];
        }
        previousTime = [date timeIntervalSince1970];
        firstTime = [date timeIntervalSince1970];
        date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        comp = [calendar components:unitFlags fromDate:date];
    }
    
    return array;
}

- (double) daysToAddToReachAngle:(double)target
                          speed1:(double)speed1
                          speed2:(double)speed2
                       direction:(double)direction {
    if(speed1 < 0) speed1 = -speed1;
    if(speed2 < 0) speed2 = -speed2;
    double speedDiff = (speed1 > speed2 ? speed1 - speed2 : speed2 - speed1);
    double daysToAdd = direction * (target/speedDiff);
    return daysToAdd;
}

- (NSArray *)calendarForPlanet:(int)planet
                          sign:(int)sign
                          date:(NSDate *)date
                      latitude:(double)latitude
                     longitude:(double)longitude
             calendarDirection:(int)calendarDirection
                  totalResults:(int)totalResults {
    
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL pinPointing = NO;
    BOOL didChangeTimeToAdd = NO;
    BOOL isLookingForDifferentSign = YES;
    char * prevSign = nil;
    char * planetName = [Swiss_Ephemeris planetNameAtIndex:planet];
    double daysToAdd = calendarDirection;
    int direction = 0;
    NSMutableArray * array = [NSMutableArray new];
    NSString * currentSign;
    NSString * futureSign = nil;
    
    while(array.count < totalResults)
    {
        char * signName;
        NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
        
        [self calculateAstrology:nil
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
        signName = [self signForPlanet:planet];
        
        double speed = [self speedForPlanet:planet];
        double degrees = [self degreesForPlanet:planet];
        double minutes = [self minutesForHouseNumber:planet];
        double seconds = [self secondsForHouseNumber:planet];
        double decimal = degrees + (minutes/60) + (seconds/3600);
        double position = natal_info[planet].position;
        
        printf("planetName=%s target=%s date=%s decimal=%f position=%f sign=%s speed=%f\n",
               planetName,
               [Swiss_Ephemeris signNameAtIndex:sign],
               [[self.dateFormatter stringFromDate:date] UTF8String],
               decimal,
               position,
               [self signForPlanet:planet],
               speed);
        
        if(currentSign.length > 0)
        {
            int compare = strcmp([currentSign UTF8String], signName);
            
            if(compare != 0)
            {
                if(!pinPointing && isLookingForDifferentSign)
                {
                    daysToAdd *= -0.5;
                    pinPointing = YES;
                    isLookingForDifferentSign = NO;
                    futureSign = [NSString stringWithFormat:@"%s", signName];
                }
                else if(pinPointing && isLookingForDifferentSign)
                {
                    daysToAdd *= -0.5;
                    isLookingForDifferentSign = NO;
                }
            }
            else if(pinPointing && !isLookingForDifferentSign)
            {
                daysToAdd *= -0.5;
                isLookingForDifferentSign = YES;
            }
        }
        else
        {
            currentSign = [NSString stringWithFormat:@"%s", signName];
        }
        
        if(comp.year <= 0)
            break;
        
        NSDate * nextDate = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        NSTimeInterval currentTimeInterval = [date timeIntervalSince1970];
        NSTimeInterval nextTimeInterval = [nextDate timeIntervalSince1970];
        
        if(fabs(currentTimeInterval - nextTimeInterval) < 100)
        {
            if(sign == SE_SIGN_Unknown
               || (sign - [Swiss_Ephemeris indexForSignName:futureSign] < 2)
               || (sign == 0 && [Swiss_Ephemeris indexForSignName:futureSign] == 11)
               || (sign == 11 && [Swiss_Ephemeris indexForSignName:futureSign] == 0))
            {
                [array addObject:@{@"DATE":date, @"SIGN":futureSign}];
                daysToAdd = calendarDirection;
                date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
                prevSign = nil;
                direction = 0;
                pinPointing = NO;
                didChangeTimeToAdd = NO;
                isLookingForDifferentSign = YES;
                currentSign = nil;
            }
        }
        else
        {
            date = nextDate;
        }
    }
    
    return array;
}

- (NSArray *)quickCalendarForPlanet:(int)planet
                          sign:(int)sign
                          date:(NSDate *)date
                      latitude:(double)latitude
                     longitude:(double)longitude
             calendarDirection:(int)calendarDirection
                  totalResults:(int)totalResults {
    
    NSMutableArray * array = [NSMutableArray new];
    BOOL doFindDistanceRequired = YES;
    BOOL doChangeDirections = NO;
    char * currentSign;
    char * signName = [Swiss_Ephemeris signNameAtIndex:sign];
    double daysToAdd = calendarDirection;
    double firstPosition = 0;
    double targetAngle = sign * 30; //each sign is 30 degrees. The start of Aries is at 0 degrees
    double minDistanceToTravel = 0;
    double prevDistance = 0;
    int direction = calendarDirection;
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * comp = [calendar components:unitFlags fromDate:date];
    NSTimeInterval earliestTime = INT64_MAX;
    NSTimeInterval previousTime = 0;
    NSTimeInterval currentTime = [date timeIntervalSince1970];
    NSTimeInterval latestTime = INT64_MIN;
    
     while(array.count < totalResults && comp.year > -3000)
    {
        [self calculateAstrology:nil
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
        
        double speed = [self speedForPlanet:planet];
        double position = natal_info[planet].position;
        currentSign = [self signForPlanet:planet];
        currentTime = [date timeIntervalSince1970];
        
//        printf("date=%s pos=%f sign=%s speed=%f dir=%d\n",
//               [[self.dateFormatter stringFromDate:date] UTF8String],
//               position,
//               currentSign,
//               speed,
//               direction);
        
        if(doFindDistanceRequired)
        {
            doFindDistanceRequired = NO;
            
            minDistanceToTravel = [self distanceWithFirstAngle:position secondAngle:targetAngle direction:direction shortestDistance:YES];
            
            if(speed < 0) speed = -speed;
            daysToAdd = direction * (minDistanceToTravel/speed);
            firstPosition = position;
        }
        else
        {
            double distance = [self distanceWithFirstAngle:firstPosition secondAngle:position direction:direction shortestDistance:NO];
            
            if(distance > 360 || (prevDistance == 0 && distance > 180))
                distance = [self distanceWithFirstAngle:firstPosition secondAngle:position direction:direction shortestDistance:YES];
            
            if([self hasDistanceBeenReachedWithFirstPosition:firstPosition
                                              secondPosition:position
                                                   direction:direction
                                         minDistanceToTravel:minDistanceToTravel
                                                prevDistance:prevDistance
                                                    distance:distance
                                                 targetAngle:targetAngle])
            {
                prevDistance = 0;
                doChangeDirections = YES;
            }
            else
                prevDistance = distance;
        }

        if(doChangeDirections || (fabs(currentTime - previousTime) < 10))
        {
            doChangeDirections = !doChangeDirections;
            
            //change directions
            direction = -direction;

//            NSTimeInterval nextDaysToAdd = direction * daysToAdd * 0.5;
//            NSDate * nextDate = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
//            NSTimeInterval timeSinceFirstDate = [nextDate timeIntervalSince1970];
//            NSTimeInterval timediff = timeSinceFirstDate - currentTime;
            
            minDistanceToTravel = [self distanceWithFirstAngle:position secondAngle:targetAngle direction:direction shortestDistance:YES];
            
            if(speed < 0) speed = -speed;
            double nextDaysToAdd = direction * (minDistanceToTravel/speed);
            firstPosition = position;

            NSDate * nextDate = [date dateByAddingTimeInterval:60*60*24*nextDaysToAdd];

            NSTimeInterval timeSinceFirstDate = [nextDate timeIntervalSince1970];
            NSTimeInterval timeSinceCurrentDate = [date timeIntervalSince1970];
            NSTimeInterval timediff = timeSinceFirstDate - timeSinceCurrentDate;
            
            if(fabs(nextDaysToAdd) > fabs(daysToAdd))
                nextDaysToAdd = direction * (fabs(daysToAdd) * 0.5);

            if(fabs(timediff) < 100 || fabs(currentTime - previousTime) < 10)
            {
                [array addObject:@{@"DATE":date, @"SIGN":[NSString stringWithUTF8String:signName]}];
                direction = calendarDirection;
                minDistanceToTravel = (position > targetAngle ? position - targetAngle : targetAngle - position);
                if(minDistanceToTravel < 180) minDistanceToTravel = 360;
                if(speed < 0) speed = -speed;
                latestTime = currentTime;
                earliestTime = currentTime;
                previousTime = 0;
                daysToAdd = direction * (minDistanceToTravel/speed);
                firstPosition = position;
            }
            else
            {
                daysToAdd = nextDaysToAdd;
            }
        }

        if(currentTime > latestTime)
            latestTime = currentTime;
        if(currentTime < earliestTime)
            earliestTime = currentTime;
        
        previousTime = [date timeIntervalSince1970];
        date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        comp = [calendar components:unitFlags fromDate:date];
    }

    return array;
}


- (double) distanceWithFirstAngle:(double)a1
                      secondAngle:(double)a2
                        direction:(int)direction
                 shortestDistance:(BOOL)shortestDistance
{
    double distance = 0;
    
    if(shortestDistance)
    {
        if(fabs(a1 - a2) > 180)
        {
            if(a1 > a2)
                distance = a2 - (a1 - 360);
            else
                distance = a1 - (a2 - 360);
        }
        else if(a1 > a2)
            distance = a1 - a2;
        else
            distance = a2 - a1;
    }
    else if(direction < 0)
    {
        if(a2 < a1)
            distance = a1 - a2;
//        else if(a2 > a1 && (a2 - a1) > 180 && shortestDistance)
//            distance = (a2 - (a1 - 360));
        else
            distance = a1 - (a2 - 360);
    }
    else if(direction > 0)
    {
        if(a2 > a1)
            distance = a2 - a1;
//        else if(a1 > a2 && (a1 - a2) > 180 && shortestDistance)
//            distance = (a2 - (a1 - 360));
        else
            distance = a1 - (a2 - 360);
    }
    
    return fabs(distance);
}

- (BOOL) hasDistanceBeenReachedWithFirstPosition:(double)p1
                                  secondPosition:(double)p2
                                       direction:(double)direction
                             minDistanceToTravel:(double)minDistanceToTravel
                                    prevDistance:(double)prevDistance
                                        distance:(double)distance
                                     targetAngle:(double)targetAngle
{
    BOOL result = YES;
    
    result = (distance > minDistanceToTravel || (prevDistance > distance && prevDistance > 180));
    
    if(result)
    {
        if(direction > 1)
        {
            if(p2 - targetAngle > 180)
            {
                if(p2 > 180) p2 -= 360;
                else targetAngle -= 360;
            }
            result = (p2 >= targetAngle);
        }
        else if(direction < 1)
        {
            if(p2 - targetAngle > 180)
            {
                if(p2 > 180) p2 -= 360;
                else targetAngle -= 360;
            }
            result = (targetAngle >= p2);
        }
    }
    
    return result;
}

+ (NSInteger) indexForPlanetName:(NSString *)planetName {
    static NSArray * planetsArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray * mArray = [NSMutableArray new];
        for(NSInteger i = 0; i < 23; i++)
        {
            [mArray addObject:[NSString stringWithUTF8String:planet_names[i]]];
        }
        planetsArray = mArray;
    });
    
    return [planetsArray indexOfObject:[NSString stringWithString:planetName]];
}

+ (NSInteger) indexForSignName:(NSString *)signName {
    static NSArray * signsArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray * mArray = [NSMutableArray new];
        for(NSInteger i = 0; i < 12; i++)
        {
            [mArray addObject:[NSString stringWithUTF8String:astrological_signs[i]]];
        }
        signsArray = mArray;
    });
    
    return [signsArray indexOfObject:[NSString stringWithString:signName]];
}

+ (NSInteger) indexForAspectName:(NSString *)aspectName {
    
    static NSArray * aspectArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray * mArray = [NSMutableArray new];
        for(NSInteger i = 0; i < 17; i++)
        {
            [mArray addObject:[NSString stringWithUTF8String:natal_orbit_text[i]]];
        }
        aspectArray = mArray;
    });
    
    return [aspectArray indexOfObject:[NSString stringWithString:aspectName]];
    
}

+ (char *) planetNameAtIndex:(NSUInteger)index {
    return (index < SE_NPLANETS ? planet_names[index] : "");
}

+ (char *) signNameAtIndex:(NSUInteger) index {
    return (index < SE_NPLANETS ? astrological_signs[index] : "");
}

+ (char *) houseNameAtIndex:(NSUInteger) index {
    return (index < 12 ? house_text[index] : "");
}

+ (char *) aspectNameAtIndex:(NSUInteger)index {
    return (index < 17 ? natal_orbit_text[index] : "");
}

+ (double) aspectAngleAtIndex:(NSUInteger)index {
    return (index < 17 ? natal_orbit_numbers[index] : -1);
}

+ (double) aspectAngleForAspectName:(char *)aspectName {
    NSInteger index = [Swiss_Ephemeris indexForAspectName:[NSString stringWithUTF8String:aspectName]];
    return [self aspectAngleAtIndex:index];
}

- (double) aspectAngleForFirstPlanet:(NSUInteger)firstPlanet
                        secondPlanet:(NSUInteger)secondPlanet {
    return [Swiss_Ephemeris aspectAngleAtIndex:aspect_matrix[firstPlanet][secondPlanet]];
}

- (char *) aspectNameForFirstPlanet:(NSUInteger)firstPlanet
                        secondPlanet:(NSUInteger)secondPlanet {
    return [Swiss_Ephemeris aspectNameAtIndex:aspect_matrix[firstPlanet][secondPlanet]];
}

- (char *) signForPlanet:(NSUInteger)planet {
    return (planet < SE_NPLANETS ? natal_info[planet].sign : "");
}

- (double) positionForPlanet:(NSUInteger)planet {
    return (planet < SE_NPLANETS ? natal_info[planet].position : -1);
}

- (double) degreesForPlanet:(NSUInteger)planet {
    return (planet < SE_NPLANETS ? natal_info[planet].degrees : -1);
}

- (double) minutesForPlanet:(NSUInteger)planet {
    return (planet < SE_NPLANETS ? natal_info[planet].minutes : -1);
}

- (double) secondsForPlanet:(NSUInteger)planet {
    return (planet < SE_NPLANETS ? natal_info[planet].seconds : -1);
}

- (int) houseNumberForPlanet:(NSUInteger)planet {
    return (planet < SE_NPLANETS ? natal_info[planet].house_number : -1);
}

- (double) declinationForPlanet:(NSUInteger)planet {
    return (planet < SE_NPLANETS ? natal_info[planet].declination : -1);
}

- (int) retrogradeForPlanet:(NSUInteger)planet {
    return (planet < SE_NPLANETS ? natal_info[planet].retrograde : -1);
    return natal_info[planet].retrograde;
}

- (double) speedForPlanet:(NSUInteger)planet {
    return (planet < SE_NPLANETS ? natal_info[planet].speedx : -1);
    return natal_info[planet].speedx;
}

- (double) cuspValueForHouseNumber:(NSInteger) houseNumber {
    return (houseNumber >= 0 && houseNumber < 12 ? house_cusps[houseNumber].cusp_value : -1);
}

- (double) degreesForHouseNumber:(NSInteger) houseNumber {
    return (houseNumber >= 0 && houseNumber < 12 ? house_cusps[houseNumber].degrees : -1);
}

- (double) minutesForHouseNumber:(NSInteger) houseNumber {
    return (houseNumber >= 0 && houseNumber < 12 ? house_cusps[houseNumber].minutes : -1);
}

- (double) secondsForHouseNumber:(NSInteger) houseNumber {
    return (houseNumber >= 0 && houseNumber < 12 ? house_cusps[houseNumber].seconds : -1);
}

- (char *) signForHouseNumber:(NSInteger) houseNumber {
    return (houseNumber >= 0 && houseNumber < 12 ? house_cusps[houseNumber].sign : "");
}

@end
