//
//  RGSChat.m
//  ChatWith
//
//  Created by PC on 11/8/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSChat.h"
#import "RGSUser.h"
#import "RGSMessage.h"


@implementation RGSChat

@dynamic entityID;
@dynamic lastMessagaeText;
@dynamic lastMessageDate;
@dynamic lastMessageID;
@dynamic name;
@dynamic roomJID;
@dynamic unreadMessagesCount;
@dynamic userID;
@dynamic messages;
@dynamic receiver;
@dynamic sender;
@dynamic participants;

+(id)RGS_createEntity{
    id chat = [RGSChat MR_createEntity];
    [chat observeMessagesChanges];
    return chat;
}

-(void)observeMessagesChanges{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification) {
                                                      NSDictionary *userinfo = notification.userInfo;
                                                      NSDictionary *insertedObjects = [[notification userInfo] objectForKey:NSInsertedObjectsKey];
                                                      if(insertedObjects){
                                                          for(NSManagedObject *object in insertedObjects){
                                                              if([object.entity.name isEqualToString:NSStringFromClass([RGSMessage class])]){
                                                                  
                                                                  
                                                                  [self updateLastestMessageDate];
                                                                  
                                                              }
                                                          }

                                                      }
                                                      NSDictionary *updatedOjects = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
                                                      if(updatedOjects){
                                                          for(NSManagedObject *object in updatedOjects){
                                                              if([object.entity.name isEqualToString:NSStringFromClass([RGSMessage class])]){
                                                                  
                                                                  
                                                                  [self updateLastestMessageDate];
                                                                  
                                                              }
                                                          }
                                                      }
                                                      NSDictionary *deletedOjects = [[notification userInfo] objectForKey:NSDeletedObjectsKey];
                                                      if(deletedOjects){
                                                          for(NSManagedObject *object in deletedOjects){
                                                              if([object.entity.name isEqualToString:NSStringFromClass([RGSMessage class])]){
                                                                  
                                                                  //update messsages.@min.date
                                                                  [self updateLastestMessageDate];
                                                                  
                                                              }
                                                          }
                                                      }
                                                  }];
}

-(void)updateLastestMessageDate{
    NSSet *messages;
    [self willAccessValueForKey:@"messages"];
    messages = [self messages];
    [self didAccessValueForKey:@"messages"];
    
    [self willChangeValueForKey:@"lastMessageDate"];
    //Key-Value Coding
    [self setLastMessageDate:[self valueForKeyPath:@"messages.@max.date"]];
    [self didChangeValueForKey:@"lastMessageDate"];
}

-(void)awakeFromInsert{
    [super awakeFromInsert];
    [self observeMessagesChanges];
}
-(void)awakeFromFetch{
    [super awakeFromFetch];
     [self observeMessagesChanges];
}
-(void)prepareForDeletion{
    [super prepareForDeletion];
    [self deRegisterForMessagesChanges];
    
}
-(void)deRegisterForMessagesChanges{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
}

@end
