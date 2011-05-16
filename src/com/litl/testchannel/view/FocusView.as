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
package com.litl.testchannel.view
{
    import com.litl.control.DropDownList;
    import com.litl.control.Label;
    import com.litl.control.LitlMediaPlayer;
    import com.litl.control.TextButton;
    import com.litl.control.listclasses.SelectableItemRenderer;
    import com.litl.control.playerclasses.AudioPlayerControlBar;
    import com.litl.control.playerclasses.AudioPlayerFeatures;
    import com.litl.helpers.geolocate.GeoLocationEvent;
    import com.litl.helpers.geolocate.GeoLocationService;
    import com.litl.sdk.enum.PropertyScope;
    import com.litl.sdk.enum.UpdateProfile;
    import com.litl.sdk.message.ForceSaveStateMessage;
    import com.litl.sdk.message.OptionsStatusMessage;
    import com.litl.sdk.message.PropertyMessage;
    import com.litl.sdk.service.LitlService;
    import com.litl.testchannel.model.TestModel;

    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    public class FocusView extends TestView
    {
        protected var zipcode:TextButton;
        protected var closeOptions:TextButton;
        protected var openUrlButton:TextButton;
        protected var navigateToURLButton:TextButton;
        protected var updateProfileDropdown:DropDownList;
        protected var audioPlayer:LitlMediaPlayer;
        protected var audioFileDropdown:DropDownList;

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

            var updateProfile:String = model.service.deviceProperties.updateProfile;
            updateProfileDropdown.selectedIndex = profiles.indexOf(updateProfile);
            addChild(updateProfileDropdown);

            audioPlayer = new LitlMediaPlayer();
            audioPlayer.controlBarClass = AudioPlayerControlBar;
            audioPlayer.features = AudioPlayerFeatures.PLAY_BUTTON | AudioPlayerFeatures.SCRUB_BAR;
            audioPlayer.move(250, 200);
            audioPlayer.setSize(400, 26);
            audioPlayer.autoPlay = false;
            addChild(audioPlayer);

            var files:Array = [ "",
                                "testAudio0.mp3",
                                "testAudio1.mp3",
                                "http://u10.sky.fm:80/sky_tophits_aacplus.flv",
                                "http://u10.sky.fm:80/sky_lovemusic_aacplus.flv",
                                "http://www.youtube.com/watch?v=D5FzCeV0ZFc",
                                "http://www.youtube.com/watch?v=eGDBR2L5kzI",
                                "nonexistent" ];
            audioFileDropdown = new DropDownList();
            audioFileDropdown.dataProvider = files;
            audioFileDropdown.itemRenderer = SelectableItemRenderer;
            audioFileDropdown.move(150, 250);
            audioFileDropdown.setSize(400, 50);
            audioFileDropdown.setStyle("dropdownWidth", 100);
            addChild(audioFileDropdown);

            model.service.addEventListener(ForceSaveStateMessage.FORCE_SAVE_STATE, onForceSaveState, false, 0, true);
        }

        override public function onResume():void {
            zipcode.addEventListener(Event.SELECT, onZipcodeClick, false, 0, true);
            closeOptions.addEventListener(Event.SELECT, onCloseOptionsClick, false, 0, true);
            model.service.addEventListener(OptionsStatusMessage.OPTIONS_STATUS, onOptions, false, 0, true);
            openUrlButton.addEventListener(Event.SELECT, onOpenUrl, false, 0, true);
            navigateToURLButton.addEventListener(Event.SELECT, onNavigateToURL, false, 0, true);
            updateProfileDropdown.addEventListener(Event.SELECT, onUpdateProfileSelect, false, 0, true);
            audioFileDropdown.addEventListener(Event.SELECT, onAudioFileSelect, false, 0, true);
        }

        override public function onPause():void {
            zipcode.removeEventListener(Event.SELECT, onZipcodeClick);
            closeOptions.removeEventListener(Event.SELECT, onCloseOptionsClick);
            model.service.removeEventListener(OptionsStatusMessage.OPTIONS_STATUS, onOptions, false);
            openUrlButton.removeEventListener(Event.SELECT, onOpenUrl);
            navigateToURLButton.removeEventListener(Event.SELECT, onNavigateToURL);
            updateProfileDropdown.removeEventListener(Event.SELECT, onUpdateProfileSelect);
            audioFileDropdown.removeEventListener(Event.SELECT, onAudioFileSelect);
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
            }
            else {
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

        protected function onAudioFileSelect(e:Event):void {
            var audioFile:String = audioFileDropdown.selectedItem as String;
            if (audioFile == "") {
                audioPlayer.unloadMedia();
                return;
            }

            try {
                audioPlayer.url = audioFile;
            } catch (err:Error) {
                trace(err.name + ":  "+err.message);
                audioPlayer.unloadMedia();
            }
        }

        protected function onForceSaveState(e:ForceSaveStateMessage):void {
            trace("force save state.  unloading audio player");
            audioPlayer.unloadMedia();

            trace("saving update profile");
            model.service.deviceProperties.updateProfile = updateProfileDropdown.selectedItem as String;
        }
    }
}
