#!/bin/sh
cd /Developer/Library/Frameworks
rm -fr Kiwi-iOS.framework
rm -fr Kiwi-OSX.framework
sudo ln -s /Developer/Kiwi/Frameworks/Kiwi-iOS.framework Kiwi-iOS.framework
sudo ln -s /Developer/Kiwi/Frameworks/Kiwi-OSX.framework Kiwi-OSX.framework

