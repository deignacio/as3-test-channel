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
    import com.litl.testchannel.model.TestModel;
    import com.litl.testchannel.view.CardView;
    import com.litl.testchannel.view.ChannelView;
    import com.litl.testchannel.view.FocusView;
    import com.litl.testchannel.view.TestView;

    [SWF(backgroundColor="0xffffff", width="1280", height="800", frameRate="21")]
    public class AS3TestChannel extends BaseChannel {
        public static const CHANNEL_ID:String = "as3-test-channel";
        public static const CHANNEL_TITLE:String = "as3 test channel";
        public static const CHANNEL_VERSION:String = "0.1";
        public static const CHANNEL_HAS_OPTIONS:Boolean = true;

        protected var model:TestModel;

        public function AS3TestChannel() {
            super();
        }

        /** @inheritDoc */
        override protected function setup():void {
            model = new TestModel(service);
            service.videoChatPlaceholderEnabled = true;
        }

        /** @inheritDoc */
        override protected function registerViews():void {
            var cardView:ViewBase = new CardView(model);
            views[View.CARD] = cardView;

            var focusView:ViewBase = new FocusView(model);
            views[View.FOCUS] = focusView;

            var channelView:ViewBase = new ChannelView(model);
            views[View.CHANNEL] = channelView;
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
            service.channelItemCount = 5;
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
