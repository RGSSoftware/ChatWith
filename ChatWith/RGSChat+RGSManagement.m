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
                                                      NSDictionary *insertedObjects = [[notification userInfo] objectForKey:NSInsertedObjectsKey];
                                                      if(insertedObjects){
                                                          [self updateLastestMessageDateWith:insertedObjects];
                                                          
                                                      }
                                                      NSDictionary *updatedOjects = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
                                                      if(updatedOjects){
                                                          [self updateLastestMessageDateWith:updatedOjects];
                                                      }
                                                      NSDictionary *deletedOjects = [[notification userInfo] objectForKey:NSDeletedObjectsKey];
                                                      if(deletedOjects){
                                                          [self updateLastestMessageDateWith:deletedOjects];
                                                      }
                                                  }];
}

-(void)updateLastestMessageDate{
    [self willChangeValueForKey:NSStringFromSelector(@selector(lastestMessageDate))];
    //Key-Value Coding
    [self willAccessValueForKey:NSStringFromSelector(@selector(messages))];
    [self setLastestMessageDate:[self valueForKeyPath:@"messages.@max.date"]];
    [self didAccessValueForKey:NSStringFromSelector(@selector(messages))];
    [self didChangeValueForKey:NSStringFromSelector(@selector(lastestMessageDate))];
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
    [self willAccessValueForKey:NSStringFromSelector(@selector(lastestMessage))];
    
    [self willAccessValueForKey:NSStringFromSelector(@selector(messages))];
    
    message = [[[self messages] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(date)) ascending:NO]]] firstObject];
    [self didAccessValueForKey:NSStringFromSelector(@selector(messages))];
    
    
    [self didAccessValueForKey:NSStringFromSelector(@selector(lastestMessage))];
    return message;
    
}

-(void)deRegisterForMessagesChanges{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
}

-(NSNumber *)unreadMessagesCount{
    NSNumber *count;
    [self willAccessValueForKey:NSStringFromSelector(@selector(unreadMessagesCount))];
    
    [self willAccessValueForKey:NSStringFromSelector(@selector(messages))];
    
    count = [self valueForKeyPath:@"messages.@sum.isUnread"];
    [self didAccessValueForKey:NSStringFromSelector(@selector(messages))];
    
    
    [self didAccessValueForKey:NSStringFromSelector(@selector(unreadMessagesCount))];
    return count;
}
-(void)updateLastestMessageDateWith:(NSDictionary *)dictionary{
    for(NSManagedObject *object in dictionary){
        if([object.entity.name isEqualToString:NSStringFromClass([RGSMessage class])]){
            RGSMessage *message = (RGSMessage *)object;
            //update messsages.@min.date
            if([message.chat isEqual:self]){
                if([message.chat.messages containsObject:message]){
                    [self updateLastestMessageDate];
                }
            }
            
        }
    }
}


@end
