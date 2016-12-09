//
//  LocationPickerVC.m
//  WBBIClient
//
//  Created by 黃韜 on 12/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "LocationPickerVC.h"
#import "PopoverHandler.h"
#import "LocationModels.h"
#import "LocationProvinceModel.h"
#import "LocationCityModel.h"

@interface LocationPickerVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *provinceList;

@end

@implementation LocationPickerVC

@synthesize PickerPV = m_pPickerPV;

@synthesize provinceList = m_pProvinceList;

#pragma mark - Object life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_pPickerPV.dataSource = self;
    m_pPickerPV.delegate = self;
    
    m_pProvinceList = [[[LocationModels alloc] init] Locations];/*
    for (LocationProvinceModel *province in m_pProvinceList) {
        NSLog(@"省------%@", [province Name]);
        for (LocationCityModel *city in [province CityArray]) {
            NSLog(@"%@", [city Name]);
        }
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Picker view datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result;
    switch (component) {
        case 0:
            result = [m_pProvinceList count];
            break;
        
        case 1:
            result = [[[m_pProvinceList objectAtIndex:[m_pPickerPV selectedRowInComponent:0]] CityArray] count];
        
        default:
            break;
    }
    return result;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *result;
    switch (component) {
        case 0:
            result = [[m_pProvinceList objectAtIndex:row] Name];
            break;
        
        case 1:
            if ([[m_pProvinceList objectAtIndex:[m_pPickerPV selectedRowInComponent:0]] CityArray].count) {
                result = [[[[m_pProvinceList objectAtIndex:[m_pPickerPV selectedRowInComponent:0]] CityArray] objectAtIndex:row] Name];
            }
            break;
        
        default:
            break;
    }
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSString *prov;
    NSString *city;
    
    switch (component) {
        case 0:
            [m_pPickerPV reloadComponent:1];
            prov = [[m_pProvinceList objectAtIndex:row] Name];
            if ([[m_pProvinceList objectAtIndex:row] CityArray].count) {
                city = [[[[m_pProvinceList objectAtIndex:row] CityArray] objectAtIndex:0] Name];
            }
            break;
            
        case 1:
            prov = [[m_pProvinceList objectAtIndex:[m_pPickerPV selectedRowInComponent:0]] Name];
            if ([[m_pProvinceList objectAtIndex:[m_pPickerPV selectedRowInComponent:0]] CityArray].count) {
                city = [[[[m_pProvinceList objectAtIndex:[m_pPickerPV selectedRowInComponent:0]] CityArray] objectAtIndex:row] Name];
            }
            break;
            
        default:
            break;
    }

    if (city != nil) {
        prov = [prov stringByAppendingString:city];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationPickerKey
                                                        object:prov];
}

@end
