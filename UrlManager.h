//
//  UrlManager.h
//  CloudBuckIt
//
//  Created by Muhammad Umar on 14/08/2015.
//  Copyright (c) 2015 Neberox Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlManager : NSObject

+(NSDictionary *)getSignUpParameterswith:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password andTransactionID:(NSString *)transactionID;
+(NSString *) getLoginUrl;
+(NSString *)registrationURL;
+(NSDictionary *)emailValidation:(NSString *)emailTxt;

+(NSDictionary *)getLoginParameters:(NSString *)username password:(NSString *)password;
+(NSDictionary *)getHomeParameters;
+(NSDictionary *)getCategoryParameters:(long) categoryId;

+(NSDictionary *)getForumParameters;
+(NSDictionary *)getForumDetailParameters:(NSDictionary *)mDict;
+(NSDictionary *)getSubscribeForumDetailParameters:(NSDictionary *)mDict subscribe:(NSString *)subscribe;
+(NSDictionary *)getUnSubscribeForumDetailParameters:(NSDictionary *)mDict;

+(NSDictionary *)getCreateForumTopicParameters:(NSDictionary *)mDict title:(NSString *)title content:(NSString *)content tags:(NSString *)tags subscription:(NSString *)subscription;
+(NSDictionary *)getCreateTopicReplyParameters:(NSDictionary *)mDict content:(NSString *)content tags:(NSString *)tags subscription:(NSString *)subscription;

+(NSDictionary *)getSubscribeTopicDetailParameters:(NSDictionary *)mDict subscribe:(NSString *)subscribe;
+(NSDictionary *)getUnSubscribeTopicDetailParameters:(NSDictionary *)mDict;


+(NSDictionary *)getTopicDetailParameters:(NSDictionary *)mainDict;

+(NSDictionary *)getPushParams;


+(NSDictionary *)getWorkoutParameters:(int) page;
+(NSDictionary *)getVideoAlbums;
+(NSDictionary *)getAlbumParameters:(int) page album:(NSString *)album;
+(NSDictionary *)getDetailParameters:(NSDictionary *)dict;
+(NSDictionary *)addComment:(NSString *)comment parent:(NSString *)parent dict:(NSDictionary *)mainDict;

+(NSDictionary *)getVideoCommentsParameters:(long) page videoId:(NSString *)videoId;
+(NSDictionary *)getVideoAddCommentsParameters:(long) page videoId:(NSString *)videoId text:(NSString *)text;

@end