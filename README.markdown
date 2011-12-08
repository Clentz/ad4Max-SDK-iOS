### About

### Installation

1. First you need to get the latest version of the Ad4Max framework binary on GitHub, or you can also compile it from the sources.2. Add the Ad4Max.framework package to the project folder using the finder.

	![Finder package](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/01.png)

3. Include the Ad4Max.framework in the in the linked libraries in the project configuration:
	- In the project settings go to the build phases tab

	![Build phases tab](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/02.png)

	- explode “Link Binary With Libraries” and click the “+” button

	- click on the “Add Other...” button

	![add other library](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/03.png)	- and finally select the Ad4Max.framework folder to add it

	![select .framework](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/04.png)

4. Since you are in framework part, you can also add CoreTelephony and SystemConfiguration which are  also require to use the Ad4Max framework.

	![core telephony](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/05.png)
	![system configuration](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/06.png)

5. Than you need to setup a subview on the screen you want to display the adUsing Interface Builder drag a UIView object from the library

	![uiview](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/07.png)6. Size it to the right size of the Ad you want to display.

	![uiview size](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/08.png)

7. Than change the class of the object from UIView to Ad4MaxBannerView

	![change view class](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/09.png)

8. Link the ad4MaxDelegate to the file owner (probably your view controller)

	![delegate](http://clentz.github.com/ad4Max-SampleApp-iOS/tutorial/10.png)9. Go in this file owner and start by including the header file:	 #import <Ad4Max/Ad4Max.h>10. Make your interface to implement the Ad4MaxBannerViewDelegate protocol:@interface ViewController : UIViewController <Ad4MaxBannerViewDelegate>11. Implement the requires methods:	
	- the banner identifier definition:

>-(NSString*)getAdBoxId
>{
>return @"b15dded7-8c97-456a-9395-c2ca6a7832d7";
>}

	- and the the error handling:
>-(void)bannerView:(Ad4MaxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error>{>    NSLog(@"Error");>}You can also implement the optionals methods to handle the refresh rate, the ad categories, the lang filter, and the banner behaviors. Refer to the documentation to find the details about the other parameters you can act on.

### Documentation

[Browse on Github](http://clentz.github.com/ad4Max-SampleApp-iOS/)

Subscribe in XCode: [http://clentz.github.com/ad4Max-SampleApp-iOS/publish/com.publigroup.ad4Max.atom](http://clentz.github.com/ad4Max-SampleApp-iOS/publish/com.publigroup.ad4Max.atom)

### Licence

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License.  You may obtain a copy
of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
License for the specific language governing permissions and limitations under
the License.