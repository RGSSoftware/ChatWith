//
//  RGSUserLoginDelegate.m
//  ChatWith
//
//  Created by PC on 10/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSUserMangementService.h"
#import "RGSUser.h"
#import "LocalStorageService.h"



@implementation RGSUserMangementService

static RGSUserMangementService *_instance = nil;
static dispatch_once_t once_token = 0;

+ (instancetype)shared
{
    dispatch_once(&once_token, ^{
        if (_instance == nil) {
            _instance = [[RGSUserMangementService alloc] init];
        }
    });
    
    return _instance;
}
+(void)setSharedInstance:(RGSUserMangementService *)instance {
    once_token = 0; // resets the once_token so dispatch_once will run again
    _instance = instance;
}

-(void)isUsernameTaken:(NSString *)username successBlock:(void (^)(BOOL isTaken))results{
    [QBRequest userWithLogin:username successBlock:^(QBResponse *response, QBUUser *user) {
        results(YES);
    } errorBlock:^(QBResponse *response) {
        if(response.status == QBResponseStatusCodeNotFound) results(NO);
    }];
}


-(void)registerUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL))results{
    QBUUser *user = [QBUUser user];
    user.login = username;
    user.password = password;
    [QBRequest signUp:user
         successBlock:^(QBResponse *response, QBUUser *user) {
             RGSUser *saveUser = [RGSUser MR_findFirstByAttribute:@"fullName" withValue:user.login];
             [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
                 saveUser.entityID = [NSNumber numberWithInteger:user.ID];
             } completion:^(BOOL success, NSError *error) {
                 results(success);
             }];
         } errorBlock:^(QBResponse *response) {
             results(NO);
         }];
}

-(void)loginUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL))results{
    if([[LocalStorageService shared] savedUser]){
        //If user is trying to login, but there Credentials are saved
//        if([[[LocalStorageService shared] savedUser].login isEqualToString:username]){
        if(TRUE){
            //login saved user
            [self quickBloxLoginUsername:username password:password successBlock:results];
        } else {
            //when user is not a saved user
            
            //delete saved user
            [[[LocalStorageService shared] savedUser] MR_deleteEntity];
            //save new user with {username and password}
            [[LocalStorageService shared] createCurrentUserWithusername:username password:password successBlock:^(BOOL success, NSError *error) {
                //login new user
                if(success) [self quickBloxLoginUsername:username password:password successBlock:results];
            }];
        }
    } else {
        //save new user with {username and password}
        [[LocalStorageService shared] createCurrentUserWithusername:username password:password successBlock:^(BOOL success, NSError *error) {
            //login new user
            if(success) [self quickBloxLoginUsername:username password:password successBlock:results];
        }];
    }
    
    
}

-(void)quickBloxLoginUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(BOOL))results{
    [QBRequest logInWithUserLogin:username password:password successBlock:^(QBResponse *response, QBUUser *user) {
        RGSUser *currentUser = [[LocalStorageService shared] savedUser];
        
        [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
            currentUser.entityID = [NSNumber numberWithInteger:user.ID];
        } completion:^(BOOL success, NSError *error) {
            results(success);
        }];
    } errorBlock:^(QBResponse *response) {
        results(NO);
    }];
}

+(BOOL)isPasswordValid:(NSString *)password
{
    if (password && !(password.length <= 4) && (password.length <=15)) {
        return YES;
    }
    
    return NO;
}
+(BOOL)isUserNameValid:(NSString *)username
{
    if(username && !(username.length == 0) && (username.length <= 20)){
        
        return [username isAlphaNumeric];
    }
    return NO;
}
+(BOOL)isEmailValid:(NSString *)email{
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:email];
}
@end
