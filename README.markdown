About
=======================

Installation
=======================

1) First you need to get the latest version of the Ad4Max framework binary on GitHub, or you can also compile it from the sources.

![Finder package](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/01.png)

3) Include the `Ad4Max.framework` in the in the linked libraries in the project configuration:

In the project settings go to the build phases tab

![Build phases tab](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/02.png)


explode “Link Binary With Libraries” and click the “+” button

click on the “Add Other...” button

![add other library](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/03.png)

![select .framework](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/04.png)

4) Since you are in framework part, you can also add `CoreTelephony` and `SystemConfiguration` which are  also require to use the Ad4Max framework.

![core telephony](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/05.png)
![system configuration](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/06.png)

5) Than you need to setup a subview on the screen you want to display the ad

![uiview](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/07.png)

![uiview size](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/08.png)

7) Than change the class of the object from `UIView` to `Ad4MaxBannerView`

![change view class](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/09.png)

8) Link the ad4MaxDelegate to the file owner (probably your view controller)

![delegate](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/10.png)

	#import <Ad4Max/Ad4Max.h>
the banner identifier definition:

	-(NSString*)getAdBoxId

the ad server of your provider:

	-(NSString*)getAdServerURL {
    	return @"adtest.ad4max.com";
	}

and the the error handling:

	-(void)bannerView:(Ad4MaxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
	{

Documentation
========


[Browse on Github](http://clentz.github.com/ad4Max-SampleApp-iOS/)

Subscribe in XCode: [http://clentz.github.com/ad4Max-SampleApp-iOS/publish/com.publigroup.ad4Max.atom](http://clentz.github.com/ad4Max-SampleApp-iOS/publish/com.publigroup.ad4Max.atom)

Licence
===========

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License.  You may obtain a copy
of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
License for the specific language governing permissions and limitations under
the License.