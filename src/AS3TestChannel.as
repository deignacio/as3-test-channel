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
package {
    import com.litl.helpers.channel.BaseChannel;
    import com.litl.helpers.view.ViewBase;
    import com.litl.sdk.enum.View;
    import com.litl.sdk.message.InitializeMessage;
    import com.litl.sdk.message.InitializeUpdateMessage;
    import com.litl.sdk.message.ImageRequestedMessage;
    import com.litl.sdk.message.ImagesChangedMessage;
    import com.litl.testchannel.model.TestModel;
    import com.litl.testchannel.view.CardView;
    import com.litl.testchannel.view.ChannelView;
    import com.litl.testchannel.view.FocusView;
    import com.litl.testchannel.view.TestView;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;

[SWF(backgroundColor="0xffffff", width="1280", height="800", frameRate="21")]
    public class AS3TestChannel extends BaseChannel {
        public static const CHANNEL_ID:String = "as3-test-channel";
        public static const CHANNEL_TITLE:String = "as3 test channel";
        public static const CHANNEL_VERSION:String = "0.1";
        public static const CHANNEL_HAS_OPTIONS:Boolean = true;

        protected static const NUM_SLIDES:Number = 10;

        private static const COLORS:Array = [
            0xe50000, 0x0343df, 0x15b01a,
            0x888888, 0x9AD7DB, 0xae7181,
            0xceb301, 0xf97306, 0xcae2fd,
            0xff028d, 0x029386, 0x650021,
            0x06c2ac, 0x7e1e9c, 0x89fe05,
            0xd1b26f, 0x06470c, 0xff028d
        ];
        private var _color:uint;

        protected var model:TestModel;
        protected var updateTimer:Timer;

        public function AS3TestChannel() {
            var pos:int = Math.random() * COLORS.length;
            _color = COLORS[pos];
            super();
        }

        /** @inheritDoc */
        override protected function setup():void {
            model = new TestModel(service);
        }

        /** @inheritDoc */
        override protected function registerViews():void {
            var cardView:ViewBase = new CardView(model, _color);
            views[View.CARD] = cardView;
            cardView.setSize(296,152);

            var focusView:ViewBase = new FocusView(model, _color);
            views[View.FOCUS] = focusView;

            var channelView:ViewBase = new ChannelView(model, _color);
            views[View.CHANNEL] = channelView;
            channelView.setSize(1280, 800);
        }

        /** @inheritDoc */
        override protected function connectToService():void {
            service.connect(CHANNEL_ID, CHANNEL_TITLE, CHANNEL_VERSION, CHANNEL_HAS_OPTIONS);
        }

        /**
         * sets the title, and hides the card view arrows
         *
         * @inheritDoc
         */
        override protected function handleInitialize(e:InitializeMessage):void {
            service.channelTitle = CHANNEL_TITLE;
            updateTimer = new Timer(5 * 60 * 1000);
            updateTimer.addEventListener(TimerEvent.TIMER, onUpdateTimer);
            updateTimer.start();
        }

        override protected function handleInitializeUpdate(e:InitializeUpdateMessage):void {
            service.channelTitle = CHANNEL_TITLE;
            setImages();
        }

        protected function onUpdateTimer(event:TimerEvent):void {
            setImages();
        }

        protected function setImages():void {
            service.addEventListener(ImagesChangedMessage.IMAGES_CHANGED, onImagesChanged);
            service.addEventListener(ImageRequestedMessage.IMAGE_REQUESTED, onImageRequested);

            var now:Date = new Date();
            now.setSeconds(0);

            var selectorKey:String = "selector" + now.toLocaleString();
            var backgroundKey:String = null; //"background" + now.toLocaleString();
            var foregroundKey:String = null; //"foreground" + now.toLocaleString();

            var slides:Array = new Array();
            for (var i:int = 0; i < NUM_SLIDES; ++i) {
                slides.push(now.toLocaleString());
                now.setMinutes(now.getMinutes() + 1);
            }
            service.setImages(slides, selectorKey, backgroundKey, foregroundKey);
        }

        protected function onImageRequested(event:ImageRequestedMessage):void {
            var key:String = event.key;
            if (key.search("selector") != -1) {
                var channelView:ChannelView = views[View.CHANNEL] as ChannelView;
                channelView.slideshowKey = key;
                service.addImage(key, channelView, 800, 600);
//            } else if (key.search("background") != -1) {

//            } else if (key.search("foreground") != -1) {

            } else {
                var cardView:CardView = views[View.CARD] as CardView;

                cardView.slideshowKey = key;
                service.addImage(key, cardView);
            }

        }

        protected function onImagesChanged(event:ImagesChangedMessage):void {
            service.removeEventListener(ImagesChangedMessage.IMAGES_CHANGED, onImagesChanged);
            service.removeEventListener(ImageRequestedMessage.IMAGE_REQUESTED, onImageRequested);
        }

        override protected function ensureView(newView:String):ViewBase {
            var view:ViewBase = super.ensureView(newView);

            if (view != currentView) {
                if (currentView is TestView) {
                    TestView(currentView).onPause();
                }
                if (view is TestView) {
                    TestView(view).onResume();
                }
            }

            return view;
        }

        override protected function onViewChanged(newView:String, newDetails:String, viewWidth:Number = 0, viewHeight:Number = 0):void {
            model.addMessage(newView + ":"+ newDetails + ", " + viewWidth + "x" + viewHeight);
        }
    }
}
