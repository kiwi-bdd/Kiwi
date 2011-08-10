# Simple BDD for iOS #
Kiwi is a Behavior Driven Development library for iOS development.
The goal is to provide a BDD library that is exquisitely simple to setup and use.

Ping us at @alding or @lukeredpath and let us know what you are using Kiwi for.

Requirements:

* Xcode 4.x
* LLVM compiler recommended

# Why? #
The idea behind Kiwi is to have tests that are more readable that what is possible with the bundled test framework.

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

# Contributing #
Kiwi is maintained by:

 * Allen Ding (@alding)
 * Luke Redpath (@lukeredpath)

Pull requests welcome. Significant contributors are listed in __Contributors.txt__.

# Getting it #
The best way to get Kiwi is by cloning the git repository: `git clone git://github.com/allending/Kiwi.git`

# Project file structure #
__Kiwi.xcodeproject__ has two runnable targets: __Kiwi__ and __KiwiExamples__. Both of these targets are set up to be test targets.

* To run tests in Xcode 4, run __Product->Test__, or use the __Cmd-U__ shortcut.
* Running tests when __Kiwi__ is the current target runs the SenTestKit tests used to test Kiwi itself. The tests are located in the __Tests__ group in the Xcode project navigator.
* Running tests when __KiwiExamples__ is the current target runs the example Kiwi specs meant to serve as sample Kiwi usage. The specs are located in the __Examples__ group in the Xcode project navigator.


# Using Kiwi in your project #
The essential point to understand about using Kiwi in your own project is that:

* You have to have a test target.
* The Kiwi library code has to be added to the test target.
* Tests are run in the same way regular Xcode tests are run: Perform the __Test__ action on the test target.

It is highly recommended (and probably a future requirement) that you set the compiler for the test target to the latest version of the LLVM compiler. It is also easy to set up Kiwi as a static library or separate project within a workspace. Instructions will come when I have time.

Example scenarios are provided below for the simplest use cases.


## For a new Xcode project ##
1. Create a new iOS project (we will use __Foobar__ as a sample project name) and ensure that __"Include Unit Tests"__ is selected during the new project wizard process.
  * This should result in a __Tests__ group in your new project.
  * You should also have a test target named something like __FoobarTests__.

2. Remove the sample __FoobarTest.(h|m)__ files Xcode generated.

3. Add all the Kiwi sources (.h and .m) to your test target.
  * The files are located in the __Kiwi/Kiwi__ directory you cloned with git.
  * Just to be clear, this is the directory that contains the __Kiwi.h__ file.
  * An easy way to do this is to add the entire Kiwi directory with Xcode with the options __"Copy items into destination group's folder"__ and __"Add to target: FoobarTests"__.

4. Add a new __FoobarSpec.m__ file to the test target, and make sure that it belongs to the __FoobarTests__ test target. You can use the contents of __FoobarSpec.m__ below.

5. Run the __FoobarTests__ test target (__Product->Test__ or __Cmd-U__). The spec/tests should now run.
  * Try changing `should` to `shouldNot` in the spec and rerun the test. You should now see a test failure.

6. Start adding your own specs.

## For an existing project with an existing test target ##
1. Start from step (3) in the instructions given in the __"For a new Xcode project"__ section above.

## For an existing project without a test target ##
1. Add a new __"Cocoa Touch Unit Testing Bundle"__ target to your project (__File->New->New Target...->Other__).

2. Continue from step (3) in the instructions given in the __"For a new Xcode project"__ section above.

## FoobarSpec.m ##

```objective-c
#import "Kiwi.h"

SPEC_BEGIN(FoobarSpec)

describe(@"Foobar", ^{
    it(@"a simple test", ^{
        NSString *greeting = [NSString stringWithFormat:@"%@ %@", @"Hello", @"world"];
        [[greeting should] equal:@"Hello world"];
    });
});

SPEC_END
```
