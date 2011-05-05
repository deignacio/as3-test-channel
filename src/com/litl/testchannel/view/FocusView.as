/*
 * Copyright (c) 2010 litl, LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
package com.litl.testchannel.view {
    import com.litl.control.DropDownList;
    import com.litl.control.Label;
    import com.litl.control.TextButton;
    import com.litl.control.listclasses.SelectableItemRenderer;
    import com.litl.helpers.geolocate.GeoLocationEvent;
    import com.litl.helpers.geolocate.GeoLocationService;
    import com.litl.sdk.enum.PropertyScope;
    import com.litl.sdk.enum.UpdateProfile;
    import com.litl.sdk.message.OptionsStatusMessage;
    import com.litl.sdk.message.PropertyMessage;
    import com.litl.sdk.service.LitlService;
    import com.litl.testchannel.model.TestModel;

    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    public class FocusView extends TestView {
        protected var zipcode:TextButton;
        protected var closeOptions:TextButton;
        protected var openUrlButton:TextButton;
        protected var navigateToURLButton:TextButton;
        protected var updateProfileDropdown:DropDownList;

        public function FocusView(model:TestModel, color:uint) {
            super(model, color);

            messages.setSize(600, 600);

            zipcode = new TextButton();
            zipcode.move(250, 20);
            zipcode.text = "click to refresh zipcode";
            addChild(zipcode);

            closeOptions = new TextButton();
            closeOptions.move(250, 50);
            closeOptions.text = "close options";

            openUrlButton = new TextButton();
            openUrlButton.move(250, 80);
            openUrlButton.text = "use openURL";
            addChild(openUrlButton);

            navigateToURLButton = new TextButton();
            navigateToURLButton.move(250, 110);
            navigateToURLButton.text = "use navigateToURL";
            addChild(navigateToURLButton);

            var profiles:Array = [ UpdateProfile.DAILY,
                                   UpdateProfile.HOURLY,
                                   UpdateProfile.FREQUENTLY,
                                   UpdateProfile.LIVE ];
            updateProfileDropdown = new DropDownList();
            updateProfileDropdown.dataProvider = profiles;
            updateProfileDropdown.itemRenderer = SelectableItemRenderer;
            updateProfileDropdown.move(250, 150);
            updateProfileDropdown.setStyle("dropDownWidth", 240);
            updateProfileDropdown.setSize(200, 26);
            addChild(updateProfileDropdown);
        }

        override public function onResume():void {
            zipcode.addEventListener(Event.SELECT, onZipcodeClick, false, 0, true);
            closeOptions.addEventListener(Event.SELECT, onCloseOptionsClick, false, 0, true);
            model.service.addEventListener(OptionsStatusMessage.OPTIONS_STATUS, onOptions, false, 0, true);
            openUrlButton.addEventListener(Event.SELECT, onOpenUrl, false, 0, true);
            navigateToURLButton.addEventListener(Event.SELECT, onNavigateToURL, false, 0, true);
            updateProfileDropdown.addEventListener(Event.SELECT, onUpdateProfileSelect, false, 0, true);
        }

        override public function onPause():void {
            zipcode.removeEventListener(Event.SELECT, onZipcodeClick);
            closeOptions.removeEventListener(Event.SELECT, onCloseOptionsClick);
            model.service.removeEventListener(OptionsStatusMessage.OPTIONS_STATUS, onOptions, false);
            openUrlButton.removeEventListener(Event.SELECT, onOpenUrl);
            navigateToURLButton.removeEventListener(Event.SELECT, onNavigateToURL);
            updateProfileDropdown.removeEventListener(Event.SELECT, onUpdateProfileSelect);
        }

        override protected function updateDisplay():void {
            super.updateDisplay();

            viewLabel.text = "focus view";
        }

        protected function onZipcodeClick(e:Event):void {
            var geoloc:GeoLocationService = new GeoLocationService();
            geoloc.addEventListener(GeoLocationEvent.UPDATE, onGeoLocationUpdate);
            geoloc.update();
        }

        protected function onGeoLocationUpdate(e:GeoLocationEvent):void {
            zipcode.text = "geolocation data:  " + e.location.postcode + ", " + e.location.timezone + ".  " + e.location.city + ", " + e.location.state;
        }

        protected function onCloseOptionsClick(e:Event):void {
            model.service.closeOptions();
        }

        protected function onOptions(e:OptionsStatusMessage):void {
            if (e.optionsOpen) {
                addChild(closeOptions);
            } else {
                if (contains(closeOptions)) {
                    removeChild(closeOptions);
                }
            }
            addMessage("options open? " + e.optionsOpen);
        }

        protected function onOpenUrl(e:Event):void {
            model.service.openURL("http://google.com");
        }

        protected function onNavigateToURL(e:Event):void {
            var request:URLRequest = new URLRequest("http://litl.com");
            navigateToURL(request);
        }

        protected function onUpdateProfileSelect(e:Event):void {
            var updateProfile:String = updateProfileDropdown.selectedItem as String;
            model.service.setUpdateProfile(updateProfile);
        }
    }
}
