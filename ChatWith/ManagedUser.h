//
//  ManagedUser.h
//  ChatWith
//
//  Created by PC on 10/2/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ManagedUser : NSManagedObject

@property (nonatomic, retain) NSNumber * externalUserID;
@property (nonatomic, retain) NSNumber * blobID;
@property (nonatomic, retain) NSString * facebookID;
@property (nonatomic, retain) NSString * twitterID;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * oldPassword;
@property (nonatomic, retain) NSDate * lastRequestAt;
@property (nonatomic, retain) NSString * customData;
@property (nonatomic, retain) NSNumber * currentUser;
@property (nonatomic, retain) NSNumber * entityID;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;


-(BOOL)isSignIn;
@end

