//
//  StoryBoardSpec.m
//  ChatWith
//
//  Created by PC on 10/1/14.
//  Copyright 2014 Randel Smith. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "RGSLoginViewController.h"


SPEC_BEGIN(StoryBoardSpec)

describe(@"StoryBoard", ^{
    __block UIStoryboard *sut;
    
    beforeEach(^{
        sut = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    it(@"intial ViewContoller should be LoginViewController", ^{
        [[[sut instantiateInitialViewController] should] beKindOfClass:[RGSLoginViewController class]];
    });
});

SPEC_END
