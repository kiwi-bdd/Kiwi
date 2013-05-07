# Simple BDD for iOS #
[![Build Status](https://travis-ci.org/allending/Kiwi.png?branch=master)](https://travis-ci.org/allending/Kiwi)

Kiwi is a Behavior Driven Development library for iOS development.
The goal is to provide a BDD library that is exquisitely simple to setup and use.

# Kiwi 2.0 - Reboot
https://github.com/allending/Kiwi/issues/176

# Requirements #

* Xcode 4.x
* LLVM compiler recommended

# Contributors #

Kiwi is open-source and is developed by the community. The full list of Kiwi individual contributors is [here](https://github.com/allending/Kiwi/graphs/contributors).

# Why? #
The idea behind Kiwi is to have tests that are more readable than what is possible with the bundled test framework.

Tests (or rather specs) are written in Objective-C and run within the comfort of Xcode to provide a test environment that is as unobtrusive and seamless as possible in terms of running tests and error reporting.

Specs look like this:

```objective-c
describe(@"Team", ^{
    context(@"when newly created", ^{
        it(@"should have a name", ^{
            id team = [Team team];
            [[team.name should] equal:@"Black Hawks"];
        });

        it(@"should have 11 players", ^{
            id team = [Team team];
            [[[team should] have:11] players];
        });
    });
});
```

To some of you, this might seem like an abomination. To the rest, read on...

# License #
Kiwi is open source software. You may freely distribute it under the terms of
the license agreement found in __License.txt__.

# Documentation #
The [Kiwi Wiki](https://github.com/allending/Kiwi/wiki) is the official documentation source.

# Getting it #
The best way to get Kiwi is by using [CocoaPods](https://github.com/cocoapods/cocoapods). For all the installation details, check out the [Wiki](https://github.com/allending/kiwi/wiki)

