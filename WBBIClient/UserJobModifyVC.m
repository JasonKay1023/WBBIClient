//
//  UserJobModifyVC.m
//  WBBIClient
//
//  Created by 黃韜 on 13/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UserJobModifyVC.h"
#import "UIView+Style.h"
#import "UserNetworking.h"
#import "UIViewController+ProgressHUD.h"

@interface UserJobModifyVC ()

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSArray *arrayJobIndustry;

@property (strong, nonatomic) IBOutlet UITextField *JobTF;
@property (strong, nonatomic) IBOutlet UIButton *SubmitB;

- (IBAction)SubmitBPressed:(UIButton *)sender;

@end

@implementation UserJobModifyVC

@synthesize JobTF = m_pJobTF;
@synthesize SubmitB = m_pSubmitB;

@synthesize selectedIndexPath = m_pSelectedIndexPath;
@synthesize arrayJobIndustry = m_pArrayJobIndustry;

#pragma mark - Object life cycle

- (void)viewDidLoad
{
    
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在加载…", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    [[UserNetworking new] JobIndustry:^(HttpResponseJson *response_json) {
        [self HideProgressHUD];
        NSLog(@"%@", response_json);
        if (response_json.StatusCode == 200) {
            m_pArrayJobIndustry = response_json.Result;
            [self.tableView reloadData];
        } else {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:response_json.Result
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    }];
    
    // User interface styling
    [m_pSubmitB SetCornerRadius:5.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User interface

- (IBAction)SubmitBPressed:(UIButton *)sender
{
    if (m_pSelectedIndexPath != nil && [m_pJobTF.text length] > 0) {
        NSString *industry_name = [[m_pArrayJobIndustry objectAtIndex:m_pSelectedIndexPath.row] objectForKey:@"Name"];
        NSNumber *industry_id = [[m_pArrayJobIndustry objectAtIndex:m_pSelectedIndexPath.row] objectForKey:@"id"];
        NSString *job_name = m_pJobTF.text;
        NSDictionary *dictionary = @{@"industry_name": industry_name,
                                     @"industry_id": industry_id,
                                     @"job_name": job_name};
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserJobModifyKey
                                                            object:dictionary];
        if (self.navigationController != nil) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"Please complete", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (m_pArrayJobIndustry) {
        return m_pArrayJobIndustry.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (m_pArrayJobIndustry) {
        cell.textLabel.text = [[m_pArrayJobIndustry objectAtIndex:indexPath.row] objectForKey:@"Name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_pSelectedIndexPath != nil) {
        UITableViewCell *selected_cell = [tableView cellForRowAtIndexPath:m_pSelectedIndexPath];
        selected_cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *selecting_cell = [tableView cellForRowAtIndexPath:indexPath];
    selecting_cell.accessoryType = UITableViewCellAccessoryCheckmark;
    m_pSelectedIndexPath = indexPath;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return @"Industry choices";
}

@end
