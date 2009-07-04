/*
 * ABAddressBookUI.m
 * iPhoneContacts
 * 
 * Created by Jim Dovey on 4/7/2009.
 * 
 * Copyright (c) 2009 Jim Dovey
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

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