//
//  ABAddressBookUI.h
//  iPhoneContacts
//
//  Created by Jim Dovey on 09-07-04.
//  Copyright 2009 Morfunk, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

#import "ABAddressBook.h"
#import "ABGroup.h"
#import "ABPerson.h"
#import "ABMultiValue.h"

@interface ABAddressBook (UserInterface)

- (ABPeoplePickerNavigationController *) peoplePicker;

// Sadly, calling this 'newPersonController' causes memory-contract problems when using Clang static analysis
- (ABNewPersonViewController *) viewControllerForNewPerson;

@end

@interface ABGroup (UserInterface)

- (ABNewPersonViewController *) viewControllerForNewPerson;

@end

@interface ABPerson (UserInterface)

// returns a multi-value containing strings, each of which is a localized address with optional country name
// addCountryName: always return an address containing a country name, regardless of whether it is specified
- (ABMultiValue *) localizedAddressStringsWithCountryName: (BOOL) addCountryName;
- (NSString *) localizedAddressStringForLabel: (NSString *) label addCountryName: (BOOL) addCountryName;

- (ABPersonViewController *) viewController;

@end
