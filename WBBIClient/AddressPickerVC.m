//
//  AddressPickerVC.m
//  WBBIClient
//
//  Created by 林穎怡 on 2016/1/6.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import "AddressPickerVC.h"
#import <MJExtension.h>
#import "ProvinceModel.h"
#import "CityModel.h"
#import "CountyModel.h"

#define kLocationFileName @"locations"

@interface AddressPickerVC ()
{
    NSArray *m_pDataArray;
    NSString *m_eType;
    NSString *m_strShortcut;
}

- (IBAction)BackBBPressed:(id)sender;

@end

@implementation AddressPickerVC

@synthesize Delegate = m_pDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.clipsToBounds = NO;
    if (!m_eType) {
        m_eType = @"province";
    }
    if ([m_eType isEqualToString:@"province"]) {
        m_pDataArray = [ProvinceModel mj_objectArrayWithKeyValuesArray:[self arrayWithContentsOfJSONString]];
        self.title = NSLocalizedString(@"省份", @"");
    } else if ([m_eType isEqualToString:@"city"]) {
        m_pDataArray = [CityModel mj_objectArrayWithKeyValuesArray:m_pDataArray];
        self.title = NSLocalizedString(@"城市", @"");
    } else if ([m_eType isEqualToString:@"county"]) {
        m_pDataArray = [CountyModel mj_objectArrayWithKeyValuesArray:m_pDataArray];
        self.title = NSLocalizedString(@"行政区", @"");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)arrayWithContentsOfJSONString
{
    NSString *json_string = [[NSBundle mainBundle] pathForResource:kLocationFileName
                                                            ofType:@"json"];
    NSData *json_data = [NSData dataWithContentsOfFile:json_string];
    __autoreleasing NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:json_data
                                                options:kNilOptions
                                                  error:&error];
    if (error != nil) {
        return nil;
    }
    return result[@"province"];
}

- (void)SetData:(NSArray *)list andType:(NSString *)type withShortcut:(NSString *)shortcut
{
    m_pDataArray = list;
    m_eType = type;
    m_strShortcut = shortcut;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_pDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if ([m_eType isEqualToString:@"province"]) {
        ProvinceModel *object = [ProvinceModel mj_objectWithKeyValues:[m_pDataArray objectAtIndex:indexPath.row]];
        cell.textLabel.text = object.name;
    } else if ([m_eType isEqualToString:@"city"]) {
        CityModel *object = [CityModel mj_objectWithKeyValues:[m_pDataArray objectAtIndex:indexPath.row]];
        cell.textLabel.text = object.name;
    } else if ([m_eType isEqualToString:@"county"]) {
        CountyModel *object = [CountyModel mj_objectWithKeyValues:[m_pDataArray objectAtIndex:indexPath.row]];
        cell.textLabel.text = object.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([m_eType isEqualToString:@"province"]) {
        ProvinceModel *object = [m_pDataArray objectAtIndex:indexPath.row];
        if (!object.city) {
            [self terminate:object.zip];
        } else {
            AddressPickerVC *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                   instantiateViewControllerWithIdentifier:@"AddressPickerVC"];
            vc.Delegate = m_pDelegate;
            [vc SetData:object.city andType:@"city" withShortcut:object.name];
            if (self.navigationController) {
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
    } else if ([m_eType isEqualToString:@"city"]) {
        CityModel *object = [m_pDataArray objectAtIndex:indexPath.row];
        if (!object.county) {
            [self terminate:object.zip];
        } else {
            AddressPickerVC *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                   instantiateViewControllerWithIdentifier:@"AddressPickerVC"];
            vc.Delegate = m_pDelegate;
            [vc SetData:object.county andType:@"county" withShortcut:[m_strShortcut stringByAppendingString:object.name]];
            if (self.navigationController) {
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
    } else if ([m_eType isEqualToString:@"county"]) {
        CountyModel *object = [CountyModel mj_objectWithKeyValues:[m_pDataArray objectAtIndex:indexPath.row]];
        m_strShortcut = [m_strShortcut stringByAppendingString:object.name];
        [self terminate:object.zip];
    }
}

- (void)terminate:(NSString *)zipcode
{
    NSLog(@"%@", zipcode);
    [m_pDelegate ReturnResult:zipcode withShortcut:m_strShortcut];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BackBBPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
