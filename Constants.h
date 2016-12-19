//
//  Constants.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 18/10/2015.
//  Copyright © 2015 DeviceBee Technologies. All rights reserved.
//

#define APP_NAME        @"TrainedByJP"

#define APP_STORE_URL   @"https://itunes.apple.com/us/app/greensteam/id898192546?mt=8"

#define BASE_URL        @"http://trainedbyjp.com/api/index.php"

#define SIGNUP_URL      @"http://www.trainedbyjp.com/membership/"
#define FORGOT_PASS_URL @"http://www.trainedbyjp.com/wp-login.php?action=lostpassword"

#define DEVICE_TYPE     @"ios"

#define GREEN_COLOR [UIColor colorWithRed:0.0 green:183/255.0 blue:103/255.0 alpha:1.0]

#define NSNULL_STR     @"<null>"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

/***************************************************
 *
 *              STORYBOARD IDENTIFIERS
 *
 **************************************************/

#define  IDENTIFIER_MAIN 	    @"main"
#define  IDENTIFIER_LOGIN 	    @"login"
#define  IDENTIFIER_LOAD 	    @"loading"
#define  IDENTIFIER_VIDEO       @"video"
#define  IDENTIFIER_DETAIL      @"detail"
#define  IDENTIFIER_HOME        @"home"
#define  IDENTIFIER_DETAIL_FORUM  @"detailForum"
#define  IDENTIFIER_DETAIL_VIDEO @"detailVideo"
#define  IDENTIFIER_DETAIL_TOPIC @"topicDetail"
#define  IDENTIFIER_VIDEO_COMMENT @"videoComment"

/***************************************************
 *
 *              RESPONSE KEYS
 *
 **************************************************/

#define  RESPONSE_KEY_USER 	      @"user"
#define  RESPONSE_KEY_DRIVERS     @"drivers"
#define  RESPONSE_KEY_BOOKINGS 	  @"bookings"
#define  RESPONSE_KEY_SUCCESS     @"success"
#define  RESPONSE_KEY_MESSAGE     @"message"
#define  RESPONSE_KEY_DATA     @"data"

/***************************************************
 *
 *              USER KEYS
 *
 **************************************************/

#define  USER_ID 	       @"id"
#define  USER_NAME         @"name"
#define  USER_EMAIL        @"email"
#define  USER_ACCESSKEY    @"accessKey"
#define  USER_IMAGEPATH    @"imagePath"
#define  USER_PHONE        @"phone"
#define  USER_PHONE_PIN    @"smsCode"
#define  USER_ACC_STATE    @"accStatus"

#define  USER_CARDS        @"cards"

#define VEHICLE_TYPE_TAXI        1000
#define VEHICLE_TYPE_RICKSHAW    1001
#define VEHICLE_TYPE_PICKUP      1002


/* User Defaults Keys */
#define  USERDEFAULT_ISLOGGEDIN   @"isLoggedIn"
#define  USERDEFAULT_USER         @"user"
#define  USERDEFAULT_TOKEN        @"pushToken"
#define  USERDEFAULT_PINACTIVATED @"isPinActivated"

#define  USER_STATE_IDLE     0
#define  USER_STATE_BOOKED   1
