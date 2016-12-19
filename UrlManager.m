//
//  UrlManager.m
//  CloudBuckIt
//
//  Created by Muhammad Umar on 14/08/2015.
//  Copyright (c) 2015 Neberox Technologies. All rights reserved.
//

#import "UrlManager.h"
#import "ApiManager.h"

@implementation UrlManager

+(NSString *)registrationURL
{
    //http://www.trainedbyjp.com/api/?device=ios&registration&email=USER_EMAIL&password=PASSWORD&first_name=FIRST_NAME&last_name=LAST_NAME&transaction_id=APPLE_PAYMENT_ID
    
    return [NSString stringWithFormat:@"%@", BASE_URL];
}

+(NSString *) getLoginUrl
{
    return [NSString stringWithFormat:@"%@", BASE_URL];
}

+(NSDictionary *)getSignUpParameterswith:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password andTransactionID:(NSString *)transactionID
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @""           ,@"registration",
                          firstName     ,@"first_name",
                          lastName      ,@"last_name",
                          DEVICE_TYPE   ,@"device",
                          password      ,@"password",
                          transactionID ,@"transaction_id",
                          email,    @"email",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)emailValidation:(NSString *)emailTxt
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          DEVICE_TYPE   ,@"device",
                          emailTxt ,@"email_check",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getLoginParameters:(NSString *)username password:(NSString *)password
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @""           ,@"auth",
                          username      ,@"username",
                          DEVICE_TYPE   ,@"device",
                          password      ,@"password",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getHomeParameters
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @""                                        , @"new_homescreen",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getWorkoutParameters:(int) page
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @""                                        , @"workout_videos",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          [NSString stringWithFormat:@"%d", page]    , @"page",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getAlbumParameters:(int) page album:(NSString *)album
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          album                                      , @"album_id",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          [NSString stringWithFormat:@"%d", page]    , @"page",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getCategoryParameters:(long) categoryId;
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%ld", categoryId] , @"category",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getPushParams
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_TOKEN];
    if ( token == nil)
        token = @"";
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          token , @"device_key",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getForumParameters
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @""                                        , @"forums",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getForumDetailParameters:(NSDictionary *)mDict
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [mDict objectForKey:@"forum_id"]  ,       @"forum",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          nil
                          ];
    return dict;
}


+(NSDictionary *)getCreateForumTopicParameters:(NSDictionary *)mDict title:(NSString *)title content:(NSString *)content tags:(NSString *)tags subscription:(NSString *)subscription
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"",                                         @"create_topic",
                          [mDict objectForKey:@"forum_id"]  ,          @"forum_id",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          title         ,          @"topic_title",
                          content       ,          @"topic_content",
                          tags          ,          @"topic_tags",
                          subscription  ,          @"subscribe",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getSubscribeForumDetailParameters:(NSDictionary *)mDict subscribe:(NSString *)subscribe
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          subscribe                         ,       @"subscribe",
                          [mDict objectForKey:@"forum_id"]  , @"subscription",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getUnSubscribeForumDetailParameters:(NSDictionary *)mDict
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [mDict objectForKey:@"forum_id"]  , @"subscription",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getSubscribeTopicDetailParameters:(NSDictionary *)mDict subscribe:(NSString *)subscribe
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          subscribe                           ,       @"subscribe",
                          [mDict objectForKey:@"topic_id"]          , @"subscription",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getUnSubscribeTopicDetailParameters:(NSDictionary *)mDict
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [mDict objectForKey:@"topic_id"]  , @"subscription",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          nil
                          ];
    return dict;
}


+(NSDictionary *)getVideoAlbums
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @""                                        , @"albums",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getDetailParameters:(NSDictionary *)mDict
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          [mDict objectForKey:@"post_id"] , @"post",
                          nil
                          ];
    return dict;
}

#pragma mark TOPIC REPLIES

+(NSDictionary *)getTopicDetailParameters:(NSDictionary *)mainDict;
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          [mainDict objectForKey:@"topic_id"] , @"topic",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getCreateTopicReplyParameters:(NSDictionary *)mDict content:(NSString *)content tags:(NSString *)tags subscription:(NSString *)subscription
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"",                                         @"create_reply",
                          [mDict objectForKey:@"topic_id"]  ,          @"topic_id",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          content       ,          @"reply_content",
                          tags          ,          @"topic_tags",
                          subscription  ,          @"subscribe",
                          nil
                          ];
    return dict;
}




+(NSDictionary *)addComment:(NSString *)comment parent:(NSString *)parent dict:(NSDictionary *)mainDict;
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          [mainDict objectForKey:@"post_id"] , @"post_id",
                          parent    , @"parent",
                          comment   , @"comment",
                          @""       , @"add_comment",
                          nil
                          ];
    return dict;

}

+(NSDictionary *)getVideoCommentsParameters:(long) page videoId:(NSString *)videoId
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          videoId                                    , @"get_comments",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          [NSString stringWithFormat:@"%ld", page]    , @"page",
                          nil
                          ];
    return dict;
}

+(NSDictionary *)getVideoAddCommentsParameters:(long) page videoId:(NSString *)videoId text:(NSString *)text
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          text,                                        @"video_comment",
                          videoId                                    , @"add_video_comment",
                          DEVICE_TYPE                                , @"device",
                          [ApiManager sharedInstance].myUser.authKey , @"auth_key",
                          [NSString stringWithFormat:@"%ld", page]   , @"page",
                          nil
                          ];
    return dict;
}

@end