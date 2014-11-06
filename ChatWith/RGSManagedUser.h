//
//  ManagedUser.h
//  ChatWith
//
//  Created by PC on 11/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RGSContact;

@interface RGSManagedUser : NSManagedObject

@property (nonatomic, retain) NSNumber * blobID;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * currentUser;
@property (nonatomic, retain) NSString * customData;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * entityID;
@property (nonatomic, retain) NSNumber * externalUserID;
@property (nonatomic, retain) NSString * facebookID;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSDate * lastRequestAt;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * oldPassword;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * twitterID;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) NSSet *befriend;
@end

@interface RGSManagedUser (CoreDataGeneratedAccessors)

- (void)addContactsObject:(RGSContact *)value;
- (void)removeContactsObject:(RGSContact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addBefriendObject:(RGSContact *)value;
- (void)removeBefriendObject:(RGSContact *)value;
- (void)addBefriend:(NSSet *)values;
- (void)removeBefriend:(NSSet *)values;

@end
