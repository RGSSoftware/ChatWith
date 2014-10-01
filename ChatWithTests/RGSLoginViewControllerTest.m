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

//@interface mockLoginViewControllerDelegate : NSObject <LoginViewControllerDelegate>
//@property (nonatomic, strong)UserModel *userModel;
//
//@end
//@implementation mockLoginViewControllerDelegate
//-(void)loginViewController:(RGSLoginViewController *)loginViewController loginUser:(UserModel *)user{
//    self.userModel = user;
//}
//
//-(void)loginViewController:(RGSLoginViewController *)loginViewController registerUser:(UserModel *)user{
//    self.userModel = user;
//}
//@end




SPEC_BEGIN(RGSLoginViewControllerSpec)

describe(@"RGSLoginViewController", ^{
    __block RGSLoginViewController *sut;
    __block KWMock <LoginViewControllerDelegate> *mockLVDelegate;
    
    beforeEach(^{
        
        //given
        sut = [RGSLoginViewController new];
        
        mockLVDelegate = [KWMock mockForProtocol:@protocol(LoginViewControllerDelegate)];
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
            __block UITextField *userTextField;
            
            beforeEach(^{
                //given
                userTextField = [UITextField new];
                userTextField.text = validUserName;
//                sut.regUserNameTextField = UserTextField;
            });
//            context(@"password is valid", ^{
//                __block UITextField *mockUserPasswordTextField;
//                
//                beforeEach(^{
//                    //given
//                    mockUserPasswordTextField = [UITextField new];
//                    mockUserPasswordTextField.text = validUserPassword;
//                    sut.regUserPasswordTextField = mockUserPasswordTextField;
//                });
//                
//                
//                it(@"should call loginViewController:registerUser: on delegate", ^{
//                    //then
//                    [[mockLVDelegate should] receive:@selector(loginViewController:registerUser:)];
//                    
//                    //when
//                    [sut registerUser:nil];
//                });
//                it(@"should send userName to delegate", ^{
//                    //given
//                    mockLoginViewControllerDelegate *mock = [mockLoginViewControllerDelegate new];
//                    
//                    sut.delegate = mock;
//                    
//                    //when
//                    [sut registerUser:nil];
//                    
//                    //then
//                    [[mock.userModel.userName should] equal:validUserName];
//                });
//                it(@"should send password to delegate", ^{
//                    //given
//                    mockLoginViewControllerDelegate *mock = [mockLoginViewControllerDelegate new];
//                    
//                    sut.delegate = mock;
//                    
//                    //when
//                    [sut registerUser:nil];
//                    
//                    //then
//                    [[mock.userModel.password should] equal:validUserPassword];
//                });
//                it(@"should send self as loginViewController to delgate", ^{
//                    [[mockLVDelegate should] receive:@selector(loginViewController:registerUser:) withArguments:sut, any()];
//                    
//                    //when
//                    [sut registerUser:nil];
//                    
//                });
//            });
//            context(@"password is NOT valid", ^{
//                it(@"should NOT send call loginViewController:loginUser: on delegate", ^{
//                    //given
//                    UITextField *mockUserPasswordTextField = [UITextField new];
//                    mockUserPasswordTextField.text = nonValidUserPassword;
//                    sut.regUserPasswordTextField = mockUserPasswordTextField;
//                    
//                    //then
//                    [[mockLVDelegate shouldNot] receive:@selector(loginViewController:registerUser:)];
//                    
//                    //when
//                    [sut registerUser:nil];
//                });
//            });
        });
//        context(@"userName is NOT valid", ^{
//            it(@"should NOT send call loginViewController:registerUser: on delegate", ^{
//                //given
//                UITextField *mockUserTextField = [UITextField new];
//                mockUserTextField = [UITextField new];
//                mockUserTextField.text = nonValidUserName;
//                sut.regUserNameTextField = mockUserTextField;
//                
//                //then
//                [[mockLVDelegate shouldNot] receive:@selector(loginViewController:registerUser:)];
//                
//                //when
//                [sut registerUser:nil];
//            });
//        });
    });
//    context(@"login button is clicked", ^{
//        context(@"userName is valid", ^{
//            __block UITextField *mockUserTextField;
//            
//            beforeEach(^{
//                //given
//                mockUserTextField = [UITextField new];
//                mockUserTextField.text = validUserName;
//                sut.userNameTextField = mockUserTextField;
//            });
//            context(@"password is valid", ^{
//                __block UITextField *mockUserPasswordTextField;
//                
//                beforeEach(^{
//                    //given
//                    mockUserPasswordTextField = [UITextField new];
//                    mockUserPasswordTextField.text = validUserPassword;
//                    sut.userPasswordTextField = mockUserPasswordTextField;
//                });
//            
//            
//                it(@"should call loginViewController:loginUser: on delegate", ^{
//                    //then
//                    [[mockLVDelegate should] receive:@selector(loginViewController:loginUser:)];
//                    
//                    //when
//                    [sut loginUser:nil];
//                });
//                it(@"should send userName to delegate", ^{
//                    //given
//                    mockLoginViewControllerDelegate *mock = [mockLoginViewControllerDelegate new];
//                    
//                    sut.delegate = mock;
//                    
//                    //when
//                    [sut loginUser:nil];
//                    
//                    //then
//                    [[mock.userModel.userName should] equal:validUserName];
//                });
//                it(@"should send password to delegate", ^{
//                    //given
//                    mockLoginViewControllerDelegate *mock = [mockLoginViewControllerDelegate new];
//                    
//                    sut.delegate = mock;
//                    
//                    //when
//                    [sut loginUser:nil];
//                    
//                    //then
//                    [[mock.userModel.password should] equal:validUserPassword];
//                });
//                it(@"should send self as loginViewController to delgate", ^{
//                    [[mockLVDelegate should] receive:@selector(loginViewController:loginUser:) withArguments:sut, any()];
//                    
//                    //when
//                    [sut loginUser:nil];
//                });
//                it(@"should send Non Nil User to delegate", ^{
//                    [[mockLVDelegate should] receive:@selector(loginViewController:loginUser:) withArguments:any(), isNot(nilValue())];
//                    
//                    //when
//                    [sut loginUser:nil];
//                });
//            });
//            context(@"password is NOT valid", ^{
//                it(@"should NOT send call loginViewController:loginUser: on delegate", ^{
//                    //given
//                    UITextField *mockUserPasswordTextField = [UITextField new];
//                    mockUserPasswordTextField.text = nonValidUserPassword;
//                    sut.userPasswordTextField = mockUserPasswordTextField;
//                    
//                    //then
//                    [[mockLVDelegate shouldNot] receive:@selector(loginViewController:loginUser:)];
//                    
//                    //when
//                    [sut loginUser:nil];
//                });
//            });
//        });
//        context(@"userName is NOT valid", ^{
//            it(@"should NOT send call loginViewController:loginUser: on delegate", ^{
//                //given
//                UITextField *mockUserTextField = [UITextField new];
//                mockUserTextField = [UITextField new];
//                mockUserTextField.text = nonValidUserName;
//                sut.userNameTextField = mockUserTextField;
//                
//                //then
//                [[mockLVDelegate shouldNot] receive:@selector(loginViewController:loginUser:)];
//                
//                //when
//                [sut loginUser:nil];
//                
//            });
//            it(@"should show Alert", ^{
//                //given
//                sut.alertViewClass = [JMRMockAlertView class];
//                JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
//                
//                UITextField *mockUserTextField = [UITextField new];
//                mockUserTextField = [UITextField new];
//                mockUserTextField.text = nonValidUserName;
//                sut.userNameTextField = mockUserTextField;
//                
//                [sut loginUser:nil];
//                
//                assertThatInt(alertVerifier.showCount, is(equalTo(@1)));
//                assertThat(alertVerifier.title, is(nilValue()));
//                assertThat(alertVerifier.message, is(@"Oops! Something's not right. Give it another shot."));
//                assertThat(alertVerifier.delegate, is(sameInstance(sut)));
//                assertThat(alertVerifier.cancelButtonTitle, is(@"OKAY"));
//                
//                
//            });
//        });
//    });
});
SPEC_END