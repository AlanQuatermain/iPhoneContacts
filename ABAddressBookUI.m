//
//  ABAddressBookUI.m
//  iPhoneContacts
//
//  Created by Jim Dovey on 09-07-04.
//  Copyright 2009 Morfunk, LLC. All rights reserved.
//

#import "ABAddressBookUI.h"
#import <AddressBookUI/ABAddressFormatting.h>

@implementation ABAddressBook (UserInterface)

- (ABPeoplePickerNavigationController *) peoplePicker
{
    ABPeoplePickerNavigationController * controller = [[ABPeoplePickerNavigationController alloc] init];
    controller.addressBook = self.addressBookRef;
    return ( [controller autorelease] );
}

- (ABNewPersonViewController *) viewControllerForNewPerson
{
    ABNewPersonViewController * controller = [[ABNewPersonViewController alloc] init];
    controller.addressBook = self.addressBookRef;
    return ( [controller autorelease] );
}

@end

@implementation ABGroup (UserInterface)

- (ABNewPersonViewController *) viewControllerForNewPerson
{
    ABNewPersonViewController * controller = [[ABNewPersonViewController alloc] init];
    controller.parentGroup = self.recordRef;
    return ( [controller autorelease] );
}

@end

@implementation ABPerson (UserInterface)

- (ABMultiValue *) localizedAddressStringsWithCountryName: (BOOL) addCountryName
{
    ABMultiValue * addresses = [self valueForProperty: kABPersonAddressProperty];
    if ( addresses == nil )
        return ( nil );
    
    ABMutableMultiValue * values = [[ABMutableMultiValue alloc] initWithPropertyType: kABMultiStringPropertyType];
    NSUInteger i, count = addresses.count;
    for ( i = 0; i < count; i++ )
    {
        NSString * str = ABCreateStringWithAddressDictionary( [addresses valueAtIndex: i], addCountryName );
        [values addValue: str withLabel: [addresses labelAtIndex: i] identifier: NULL];
    }
    
    ABMultiValue * result = [values copy];
    [values release];
    
    return ( [result autorelease] );
}

- (NSString *) localizedAddressStringForLabel: (NSString *) label addCountryName: (BOOL) addCountryName
{
    ABMultiValue * addresses = [self valueForProperty: kABPersonAddressProperty];
    if ( addresses == nil )
        return ( nil );
    
    NSUInteger i, count = addresses.count;
    for ( i = 0; i < count; i++ )
    {
        NSString * testLabel = [addresses labelAtIndex: i];
        if ( [testLabel isEqualToString: label] )
            break;
    }
    
    // if the requested label wasn't found, 
    if ( i >= addresses.count )
        return ( nil );
    
    return ( ABCreateStringWithAddressDictionary([addresses valueAtIndex: i], addCountryName) );
}

- (ABPersonViewController *) viewController
{
    ABPersonViewController * controller = [[ABPersonViewController alloc] init];
    controller.displayedPerson = self.recordRef;
    return ( [controller autorelease] );
}

@end