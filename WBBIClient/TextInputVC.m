//
//  TextInputVC.m
//  WBBIClient
//
//  Created by 黃韜 on 14/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "TextInputVC.h"

@interface TextInputVC () <UITextViewDelegate>

@property (copy, nonatomic) NSString *mark;
@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) IBOutlet UITextView *InputTV;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *SaveBB;

- (IBAction)SaveBBPressed:(id)sender;

@end

@implementation TextInputVC

@synthesize InputTV = m_pInputTV;

@synthesize mark = m_pMark;
@synthesize content = m_pContent;

#pragma mark - Object life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Data load
    m_pInputTV.text = m_pContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User interface

- (IBAction)SaveBBPressed:(id)sender
{
    [self postResult];
}

#pragma mark - Public interface

- (void)Mark:(NSString *)mark
{
    m_pMark = mark;
}

- (void)Title:(NSString *)title andContent:(NSString *)content
{
    self.title = title;
    m_pContent = content;
}

#pragma mark - Internal methods

- (void)postResult
{
    NSDictionary *result = [NSDictionary dictionaryWithObjects:@[m_pMark, m_pInputTV.text]
                                                       forKeys:@[@"mark", @"result"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTextInputVCKey
                                                        object:result];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
