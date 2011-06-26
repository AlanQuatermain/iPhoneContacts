/*
 * ABRecord.h
 * iPhoneContacts
 * 
 * Created by Jim Dovey on 5/6/2009.
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

#import "ABRecord.h"
#import "ABMultiValue.h"

#import <AddressBook/ABPerson.h>

static NSMutableIndexSet * __multiValuePropertyIDSet = nil;

@implementation ABRecord

@synthesize recordRef=_ref;

+ (void) initialize
{
    if ( self != [ABRecord class] )
        return;
    
    __multiValuePropertyIDSet = [[NSMutableIndexSet alloc] init];
    [__multiValuePropertyIDSet addIndex: kABPersonEmailProperty];
    [__multiValuePropertyIDSet addIndex: kABPersonAddressProperty];
    [__multiValuePropertyIDSet addIndex: kABPersonDateProperty];
    [__multiValuePropertyIDSet addIndex: kABPersonPhoneProperty];
    [__multiValuePropertyIDSet addIndex: kABPersonInstantMessageProperty];
    [__multiValuePropertyIDSet addIndex: kABPersonURLProperty];
    [__multiValuePropertyIDSet addIndex: kABPersonRelatedNamesProperty];
}

+ (Class<ABRefInitialization>) wrapperClassForPropertyID: (ABPropertyID) propID
{
    if ( [__multiValuePropertyIDSet containsIndex: propID] )
        return ( [ABMultiValue class] );
    
    return ( Nil );
}

- (id) initWithABRef: (CFTypeRef) recordRef
{
    if ( recordRef == NULL )
    {
        [self release];
        return ( nil );
    }
    
    if ( [super init] == nil )
        return ( nil );
    
    // we have to trust the user that the type is correct -- no CFTypeRef checking in AddressBook.framework
    _ref = (ABRecordRef) CFRetain(recordRef);
    
    return ( self );
}

- (void) dealloc
{
    if ( _ref != NULL )
        CFRelease( _ref );
    [super dealloc];
}

- (ABRecordID) recordID
{
    return ( ABRecordGetRecordID(_ref) );
}

- (ABRecordType) recordType
{
    return ( ABRecordGetRecordType(_ref) );
}

- (id) valueForProperty: (ABPropertyID) property
{
    CFTypeRef value = ABRecordCopyValue( _ref, property );
    if ( value == NULL )
        return ( nil );
    
    id result = nil;
    
    Class<ABRefInitialization> wrapperClass = [[self class] wrapperClassForPropertyID: property];
    if ( wrapperClass != Nil )
        result = [[wrapperClass alloc] initWithABRef: value];
    else
        result = (id) value;
    
    return ( [result autorelease] );
}

- (BOOL) setValue: (id) value forProperty: (ABPropertyID) property error: (NSError **) error
{
    if ( [value isKindOfClass: [ABMultiValue class]] )
        value = (id) [value getMultiValueRef];
    return ( (BOOL) ABRecordSetValue(_ref, property, (CFTypeRef)value, (CFErrorRef *)error) );
}

- (BOOL) removeValueForProperty: (ABPropertyID) property error: (NSError **) error
{
    return ( (BOOL) ABRecordRemoveValue(_ref, property, (CFErrorRef *)error) );
}

- (NSString *) compositeName
{
    NSString * result = (NSString *) ABRecordCopyCompositeName( _ref );
    return ( [result autorelease] );
}

@end
