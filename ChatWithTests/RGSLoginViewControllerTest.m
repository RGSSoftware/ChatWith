//
//  RGSLoginViewControllerTest.m
//  ChatWith
//
//  Created by PC on 4/15/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RGSLoginViewController.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "JMRMockAlertView.h"
#import "JMRMockAlertViewVerifier.h"

#import <Kiwi/Kiwi.h>

NSString *const validUserName = @"AAAAAAAAAAZZZZZZZZZZ";
NSString *const validUserPassword = @"AAAAABBBBBZZZZZ";

NSString *const nonValidUserName = @"AAAAAAAAAAZZZZZZZZZZX";
NSString *const nonValidUserPassword = @"AABB";

@interface mockLoginViewControllerDelegate : NSObject <LoginViewControllerDelegate>
@property (nonatomic, getter=isUsernameTaken)BOOL usernameTaken;

@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *password;

@end
@implementation mockLoginViewControllerDelegate
-(void)loginViewController:(RGSLoginViewController *)loginViewController loginUsername:(NSString *)username password:(NSString *)password{
    self.username = username;
    self.password = password;
}
-(void)loginViewController:(RGSLoginViewController *)loginViewController registerUsername:(NSString *)username password:(NSString *)password{
    self.username = username;
    self.password = password;
}

-(BOOL)loginViewController:(RGSLoginViewController *)loginViewController isUsernameTaken:(NSString *)username{
    return self.isUsernameTaken;
}
@end



SPEC_BEGIN(RGSLoginViewControllerSpec)

describe(@"RGSLoginViewController", ^{
    __block RGSLoginViewController *sut;
    __block KWMock <LoginViewControllerDelegate> *mockLVDelegate;
    
    beforeEach(^{
        
        //given
        sut = [RGSLoginViewController new];
        
        mockLVDelegate = [KWMock nullMockForProtocol:@protocol(LoginViewControllerDelegate)];
        sut.delegate = mockLVDelegate;
        
    });
    afterEach(^{
        sut = nil;
        mockLVDelegate = nil;
    });
    
//    it(@"should have a Login View", ^{
//        UIView *view = sut.loginView;
//        
//        [view shouldNotBeNil];
//    });
//    it(@"should have a Registration View", ^{
//        [sut.registrationView shouldNotBeNil];
//    });
    context(@"register button is clicked", ^{
        context(@"userName is valid", ^{
            __block UITextField *mockUserTextField;
            
            beforeEach(^{
                //given
                mockUserTextField = [UITextField new];
                mockUserTextField.text = validUserName;
                sut.usernameTextField = mockUserTextField;
            });
            
            afterEach(^{
                mockUserTextField = nil;
                sut.usernameTextField = nil;
            });
        
            context(@"password is valid", ^{
                __block UITextField *mockPasswordTextField;
                
                beforeEach(^{
                    //given
                    mockPasswordTextField = [UITextField new];
                    mockPasswordTextField.text = validUserPassword;
                    sut.passwordTextField = mockPasswordTextField;
                });
                
                afterEach(^{
                    mockPasswordTextField = nil;
                    sut.passwordTextField = nil;
                });
                
                context(@"userName is NOT TAKEN", ^{
                    __block mockLoginViewControllerDelegate *mock;
                    
                    beforeEach(^{
                        mock = [mockLoginViewControllerDelegate new];
                        mock.usernameTaken = NO;
                    });
                    afterEach(^{
                        mock = nil;
                    });
                    
                    it(@"should call loginViewController:registerUser: on delegate", ^{
                        //then
                        [[mockLVDelegate should] receive:@selector(loginViewController:registerUsername:password:)];
                        
                        //when
                        [sut registerUser:nil];
                    });
                    
                    
                    it(@"should send userName to delegate", ^{
                        //given
                        sut.delegate = mock;
                        
                        //when
                        [sut registerUser:nil];
                        
                        //then
                        [[mock.username should] equal:validUserName];
                    });
                    it(@"should send password to delegate", ^{
                        //given
                        sut.delegate = mock;
                        
                        //when
                        [sut registerUser:nil];
                        
                        //then
                        [[mock.password should] equal:validUserPassword];
                    });
                    it(@"should send self as loginViewController to delgate", ^{
                        [[mockLVDelegate should] receive:@selector(loginViewController:registerUsername:password:) withArguments:sut, any(), any()];
                        
                        //when
                        [sut registerUser:nil];
                        
                    });
                });
                context(@"userName is TAKEN", ^{
                    __block mockLoginViewControllerDelegate *mock;
                    
                    beforeEach(^{
                        mock = [mockLoginViewControllerDelegate new];
                        mock.usernameTaken = YES;
                    });
                    afterEach(^{
                        mock = nil;
                    });
                    it(@"should show Alert", ^{
                        //given
                        sut.alertViewClass = [JMRMockAlertView class];
                        JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
                        
                        sut.delegate = mock;
                        
                        [sut registerUser:nil];
                        
                        assertThatInt(alertVerifier.showCount, is(equalTo(@1)));
                        assertThat(alertVerifier.title, is(nilValue()));
                        assertThat(alertVerifier.message, is(@"Oops! Somebody already has that name. Give it another shot."));
                        assertThat(alertVerifier.delegate, is(sameInstance(sut)));
                        assertThat(alertVerifier.cancelButtonTitle, is(@"OKAY"));
                        
                    });

                });

            });

            context(@"password is NOT valid", ^{
                it(@"should NOT send call loginViewController:loginUser: on delegate", ^{
                    //given
                    UITextField *mockUserPasswordTextField = [UITextField new];
                    mockUserPasswordTextField.text = nonValidUserPassword;
                    sut.usernameTextField = mockUserPasswordTextField;
                    
                    //then
                    [[mockLVDelegate shouldNot] receive:@selector(loginViewController:registerUsername:password:)];
                    
                    //when
                    [sut registerUser:nil];
                });
            });
    
        context(@"userName is NOT valid", ^{
            it(@"should NOT call loginViewController:registerUser: on delegate", ^{
                //given
                UITextField *mockUserTextField = [UITextField new];
                mockUserTextField = [UITextField new];
                mockUserTextField.text = nonValidUserName;
                sut.usernameTextField = mockUserTextField;
                
                //then
                [[mockLVDelegate shouldNot] receive:@selector(loginViewController:registerUsername:password:)];
                
                //when
                [sut registerUser:nil];
            });
        });
    });
        context(@"userName is NOT valid", ^{
            it(@"should NOT send call loginViewController:registerUsername:password: on delegate", ^{
                //given
                UITextField *mockUserTextField = [UITextField new];
                mockUserTextField = [UITextField new];
                mockUserTextField.text = nonValidUserName;
                sut.usernameTextField = mockUserTextField;
                
                //then
                [[mockLVDelegate shouldNot] receive:@selector(loginViewController:registerUsername:password:)];
                
                //when
                [sut registerUser:nil];
                
            });
            it(@"should show Alert", ^{
                //given
                sut.alertViewClass = [JMRMockAlertView class];
                JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
                
                UITextField *mockUserTextField = [UITextField new];
                mockUserTextField = [UITextField new];
                mockUserTextField.text = nonValidUserName;
                sut.usernameTextField = mockUserTextField;
                
                [sut registerUser:nil];
                
                assertThatInt(alertVerifier.showCount, is(equalTo(@1)));
                assertThat(alertVerifier.title, is(nilValue()));
                assertThat(alertVerifier.message, is(@"Oops! Something's not right. Give it another shot."));
                assertThat(alertVerifier.delegate, is(sameInstance(sut)));
                assertThat(alertVerifier.cancelButtonTitle, is(@"OKAY"));
                
            });
        });
    });
    context(@"login button is clicked", ^{
        context(@"userName is valid", ^{
            __block UITextField *mockUserTextField;
            
            beforeEach(^{
                //given
                mockUserTextField = [UITextField new];
                mockUserTextField.text = validUserName;
                sut.usernameTextField = mockUserTextField;
            });
            context(@"password is valid", ^{
                __block UITextField *mockUserPasswordTextField;
                
                beforeEach(^{
                    //given
                    mockUserPasswordTextField = [UITextField new];
                    mockUserPasswordTextField.text = validUserPassword;
                    sut.passwordTextField = mockUserPasswordTextField;
                });
            
            
                it(@"should call loginViewController:loginUser: on delegate", ^{
                    //then
                    [[mockLVDelegate should] receive:@selector(loginViewController:loginUsername:password:)];
                    
                    //when
                    [sut loginUser:nil];
                });
                it(@"should send userName to delegate", ^{
                    //given
                    mockLoginViewControllerDelegate *mock = [mockLoginViewControllerDelegate new];
                    
                    sut.delegate = mock;
                    
                    //when
                    [sut loginUser:nil];
                    
                    //then
                    [[mock.username should] equal:validUserName];
                });
                it(@"should send password to delegate", ^{
                    //given
                    mockLoginViewControllerDelegate *mock = [mockLoginViewControllerDelegate new];
                    
                    sut.delegate = mock;
                    
                    //when
                    [sut loginUser:nil];
                    
                    //then
                    [[mock.password should] equal:validUserPassword];
                });
                it(@"should send self as loginViewController to delgate", ^{
                    [[mockLVDelegate should] receive:@selector(loginViewController:loginUsername:password:) withArguments:sut, any(), any()];
                    
                    //when
                    [sut loginUser:nil];
                });
            });
            context(@"password is NOT valid", ^{
                it(@"should NOT send call loginViewController:loginUser: on delegate", ^{
                    //given
                    UITextField *mockUserPasswordTextField = [UITextField new];
                    mockUserPasswordTextField.text = nonValidUserPassword;
                    sut.usernameTextField = mockUserPasswordTextField;
                    
                    //then
                    [[mockLVDelegate shouldNot] receive:@selector(loginViewController:loginUsername:password:)];
                    
                    //when
                    [sut loginUser:nil];
                });
            });
        });
        context(@"userName is NOT valid", ^{
            it(@"should NOT send call loginViewController:loginUser: on delegate", ^{
                //given
                UITextField *mockUserTextField = [UITextField new];
                mockUserTextField = [UITextField new];
                mockUserTextField.text = nonValidUserName;
                sut.usernameTextField = mockUserTextField;
                
                //then
                [[mockLVDelegate shouldNot] receive:@selector(loginViewController:loginUsername:password:)];
                
                //when
                [sut loginUser:nil];
                
            });
            it(@"should show Alert", ^{
                //given
                sut.alertViewClass = [JMRMockAlertView class];
                JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
                
                UITextField *mockUserTextField = [UITextField new];
                mockUserTextField = [UITextField new];
                mockUserTextField.text = nonValidUserName;
                sut.usernameTextField = mockUserTextField;
                
                [sut loginUser:nil];
                
                assertThatInt(alertVerifier.showCount, is(equalTo(@1)));
                assertThat(alertVerifier.title, is(nilValue()));
                assertThat(alertVerifier.message, is(@"Oops! Something's not right. Give it another shot."));
                assertThat(alertVerifier.delegate, is(sameInstance(sut)));
                assertThat(alertVerifier.cancelButtonTitle, is(@"OKAY"));
                
            });
        });
    });
});
SPEC_END