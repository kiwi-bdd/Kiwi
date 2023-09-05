//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

// Set this to 0 to turn off all internal Kiwi tests. Useful when needing to
// focus on a single issue that could be affected by other tests, especially
// when dealing with Class method stubs, alloc/init stubs, etc.
#define KW_TESTS_ENABLED 1

// Use this macro to define a spec with a custom spec class.
#define CUSTOM_SPEC_BEGIN(name, test_case_class) \
    \
    @interface name : test_case_class \
    \
    @end \
    \
    @implementation name \
    \
    + (NSString *)file { return @__FILE__; } \
    \
    + (void)buildExampleGroups { \
        [super buildExampleGroups]; \
        \
        id _kw_test_case_class = self; \
        { \
            __unused name *self = _kw_test_case_class;
