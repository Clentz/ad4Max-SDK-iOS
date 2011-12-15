Intro
=======================

The ad4max iOS SDK lets you monetize your iOS apps via advertising. 
The code sends http requests to the ad4max ad server and displays ads in various formats (images, text ads).
You will receive 50 % of click and CPM generated revenues.
It supports different 2 banner sizes (320x50 for portrait mode and 480x32 for landscape mode)
Please go to http://www.ad4max.com/contact/contact-us to get in touch , and ask for an account.

About
=======================
Ad4max is a Swiss ad network, that enables developers to monetize their websites and apps via advertising. Banners of various sizes can be placed on websites or directly in applications. 
Ad4max decided to make its SDK public as open source project. So you can adapt it to your own needs.

Documentation
=======================

The code documentation is available for consulting in your browser [there](http://clentz.github.com/ad4Max-SampleApp-iOS/).
You can also get it through XCode and subscribe to any updates via [this Atom feed](http://clentz.github.com/ad4Max-SampleApp-iOS/publish/com.publigroup.ad4Max.atom).

Sample application
=======================

A very basic App is provided and demonstrates how to make a more advanced use of the framework, for example:
- how to display Ads both in Portrait and Landscape modes
- how to show an Ad banner only when an Ad is available

You can try it and analyze it by opening 'ad4Max-SampleApp.xcodeproj' in XCode.

Installation
=======================

1. First you need to get [the latest version of the Ad4Max framework binary](http://clentz.github.com/ad4Max-SampleApp-iOS/framework/Ad4Max.framework.zip) on GitHub.

1. Unzip the `Ad4Max.framework` package to the project folder using the Finder.
<br/>
![Finder package](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/01.png)

1. Include the `Ad4Max.framework` in the linked libraries in the project configuration:
* In the project settings go to the build phases tab
<br/>
![Build phases tab](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/02.png)
* explode “Link Binary With Libraries” and click the “+” button
* click on the “Add Other...” button
<br/>
![add other library](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/03.png)
* and finally select the `Ad4Max.framework` folder to add it
<br/>
![select .framework](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/04.png)

1. Since you are at it, you can also add `CoreTelephony` and `SystemConfiguration` which are also required by the Ad4Max framework.
<br/>
![core telephony](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/05.png)
![system configuration](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/06.png)

1. Then you need to setup a subview on the screen where you want to display the Ad
* Using Interface Builder drag a UIView object from the library
<br/>
![uiview](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/07.png)
* Size it to the right size of the Ad you want to display.
<br/>
![uiview size](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/08.png)
* Then change the Class of the object from `UIView` to `Ad4MaxBannerView`
<br/>
![change view class](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/09.png)

1. Link the ad4MaxDelegate to the file owner (probably your view controller)
<br/>
![delegate](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/10.png)

1. Go in this file owner and start by including the header file:
	\#import <Ad4Max/Ad4Max.h>

1. Make your controller implement the `Ad4MaxBannerViewDelegate` protocol:
	@interface ViewController : UIViewController <Ad4MaxBannerViewDelegate>```

1. Implement the required delegate methods:
* the banner identifier definition:
	-(NSString*)getAdBoxId
	{
		return @"38eef07c-f3c0-4caf-89e8-251e920d0668";
	}

* the ad server of your provider:
	-(NSString*)getAdServerURL {
    	return @"adtest.ad4max.com";
	}

* and the error handling:
	-(void)bannerView:(Ad4MaxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
	{
	    NSLog(@"Error: %@",error);
	}

You can also implement the optionals methods to handle the refresh rate, the Ad categories, the language filter, and the banner behaviors. Refer to the [documentation](http://clentz.github.com/ad4Max-SampleApp-iOS/) to find the details about the other parameters you can act on.


Licence
===========

This Software is licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License.  You may obtain a copy
of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
License for the specific language governing permissions and limitations under
the License.

This product includes third-party softwares compatible with this Apache license but you must make sure you conform to these licenses if you use, install, modify or redistribute this software:

- [Reachability](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html) licensed by Apple Inc.
- [UIDevice-with-UniqueIdentifier-for-iOS-5](https://github.com/gekitz/UIDevice-with-UniqueIdentifier-for-iOS-5/blob/master/license) licensed by the Georg Kitz. 

Copyright (C) 2011 Publigroupe All Rights Reserved.
