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
    import com.litl.control.Label;
    import com.litl.sdk.message.UserInputMessage;
    import com.litl.testchannel.model.TestModel;

    import com.litl.testchannel.skin.LeftArrow;
    import com.litl.testchannel.skin.RightArrow;

    import flash.display.Bitmap;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class CardView extends TestView {
        protected var timer:Timer;
        protected var arrow:Bitmap;
        protected var arrowCount:int;
        protected var arrowLabel:Label;
        protected var _slideshowKey:String;

        public function CardView(model:TestModel) {
            super(model);

            slideshowKey = "";

            timer = new Timer(500, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
        }

        public function set slideshowKey(value:String):void {
            _slideshowKey = value;

            this.updateDisplay();
        }

        public function get slideshowKey():String {
            return _slideshowKey;
        }

        override public function onResume():void {
            model.service.addEventListener(UserInputMessage.MOVE_NEXT_ITEM, handleMove, false, 0, true);
            model.service.addEventListener(UserInputMessage.MOVE_PREVIOUS_ITEM, handleMove, false, 0, true);

            updateDisplay();
        }

        override public function onPause():void {
            model.service.removeEventListener(UserInputMessage.MOVE_NEXT_ITEM, handleMove);
            model.service.removeEventListener(UserInputMessage.MOVE_PREVIOUS_ITEM, handleMove);
        }


        private function handleMove(e:UserInputMessage):void {
            if (arrow && contains(arrow) && contains(arrowLabel)) {
                removeChild(arrow);
                removeChild(arrowLabel);
            }

            switch(e.type) {
                case UserInputMessage.MOVE_NEXT_ITEM:
                    if (arrow is RightArrow) {
                        arrowCount++;
                    } else {
                        arrow = new RightArrow();
                        arrowCount = 1;
                    }
                break;
                case UserInputMessage.MOVE_PREVIOUS_ITEM:
                    if (arrow is LeftArrow) {
                        arrowCount++;
                    } else {
                        arrow = new LeftArrow();
                        arrowCount = 1;
                    }
                break;
                default:
                    arrow = null;
                    arrowLabel = null;
                    arrowCount = 0;
                break;
            }

            timer.reset();

            if (arrow) {
                if (arrowCount == 1) {
                    arrow.x = 50;
                    arrow.y = 50;

                    arrowLabel = new Label();
                    arrowLabel.x = 90;
                    arrowLabel.y = 75;
                } else if (arrowCount > 1) {
                    arrowLabel.text = "x" + arrowCount;
                }

                addChild(arrow);
                addChild(arrowLabel);

                timer.start();
            }
        }

        override protected function updateDisplay():void {
            super.updateDisplay();

            viewLabel.text = "card view " + slideshowKey;
        }

        protected function onTimer(e:TimerEvent):void {
            if (arrow) {
                removeChild(arrow);
                removeChild(arrowLabel);
            }
        }
    }
}
