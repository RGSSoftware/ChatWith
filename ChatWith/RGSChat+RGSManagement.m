//
//  RGSChat+RGSManagement.m
//  ChatWith
//
//  Created by PC on 2/21/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "RGSChat+RGSManagement.h"

#import "RGSMessage.h"

@implementation RGSChat (RGSManagement)
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
-(id)lastestMessage{
    RGSMessage *message;
    [self willAccessValueForKey:@"lastestMessage"];
    
    [self willAccessValueForKey:@"messages"];
    
    message = [[[self messages] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(date)) ascending:NO]]] firstObject];
    [self didAccessValueForKey:@"messages"];
    
    
    [self didAccessValueForKey:@"lastestMessage"];
    return message;
    
}

-(void)deRegisterForMessagesChanges{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
}

-(NSNumber *)unreadMessagesCount{
    NSNumber *count;
    [self willAccessValueForKey:@"unreadMessagesCount"];
    
    [self willAccessValueForKey:@"messages"];
    
    count = [self valueForKeyPath:@"messages.@sum.isUnread"];
    [self didAccessValueForKey:@"messages"];
    
    
    [self didAccessValueForKey:@"unreadMessagesCount"];
    return count;
}


@end
