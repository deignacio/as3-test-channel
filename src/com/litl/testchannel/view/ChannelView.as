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
    import com.litl.control.Label;
    import com.litl.sdk.message.UserInputMessage;
    import com.litl.testchannel.model.TestModel;

    import com.litl.testchannel.skin.DownArrow;
    import com.litl.testchannel.skin.UpArrow;

    import flash.display.Bitmap;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class ChannelView extends TestView
    {
        protected var goTimer:Timer;
        protected var pressedLabel:Label;
        protected var heldLabel:Label;
        protected var releasedLabel:Label;
        protected var wheelLabel:Label;

        protected var arrow:Bitmap;
        protected var arrowCount:int;
        protected var arrowLabel:Label;
        protected var arrowTimer:Timer;

        public function ChannelView(model:TestModel, color:uint) {
            super(model, color);

            messages.setSize(600, 600);

            pressedLabel = new Label();
            pressedLabel.move(50, 65);
            pressedLabel.text = "go button pressed";
            heldLabel = new Label();
            heldLabel.move(50, 85);
            heldLabel.text = "go button held";
            releasedLabel = new Label();
            releasedLabel.move(50, 105);
            releasedLabel.text = "go button released";
            wheelLabel = new Label();
            wheelLabel.move(50, 125);
            wheelLabel.text = "wheel enabled";

            goTimer = new Timer(500, 1);

            arrowTimer = new Timer(500, 1);
        }

        override public function onResume():void {
            goTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onGoTimer, false, 0, true);
            arrowTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onArrowTimer, false, 0, true);
            model.service.addEventListener(UserInputMessage.GO_BUTTON_HELD, onGoButton, false, 0, true);
            model.service.addEventListener(UserInputMessage.GO_BUTTON_PRESSED, onGoButton, false, 0, true);
            model.service.addEventListener(UserInputMessage.GO_BUTTON_RELEASED, onGoButton, false, 0, true);
            model.service.addEventListener(UserInputMessage.WHEEL_UP, onWheel, false, 0, true);
            model.service.addEventListener(UserInputMessage.WHEEL_DOWN, onWheel, false, 0, true);
        }

        override public function onPause():void {
            goTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onGoTimer);
            arrowTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onArrowTimer);
            model.service.removeEventListener(UserInputMessage.GO_BUTTON_HELD, onGoButton);
            model.service.removeEventListener(UserInputMessage.GO_BUTTON_PRESSED, onGoButton);
            model.service.removeEventListener(UserInputMessage.GO_BUTTON_RELEASED, onGoButton);
            model.service.removeEventListener(UserInputMessage.WHEEL_UP, onWheel);
            model.service.removeEventListener(UserInputMessage.WHEEL_DOWN, onWheel);
        }

        override protected function updateDisplay():void {
            super.updateDisplay();

            viewLabel.text = "channel view";
        }

        protected function onGoButton(e:UserInputMessage):void {
            switch (e.type) {
                case UserInputMessage.GO_BUTTON_PRESSED:
                    resetGoButtonDisplay();
                    addChild(pressedLabel);
                    break;
                case UserInputMessage.GO_BUTTON_HELD:
                    addChild(heldLabel);
                    if (model.service.wheelEnabled) {
                        removeChild(wheelLabel);
                    }
                    else {
                        addChild(wheelLabel);
                    }
                    model.toggleWheel();
                    break;
                case UserInputMessage.GO_BUTTON_RELEASED:
                    addChild(releasedLabel);
                    goTimer.reset();
                    goTimer.start();
                    break;
                default:
                    break;
            }

            addMessage(e.type);
        }

        protected function onGoTimer(e:TimerEvent):void {
            resetGoButtonDisplay();
        }

        protected function resetGoButtonDisplay():void {
            if (contains(pressedLabel)) {
                removeChild(pressedLabel);
            }

            if (contains(heldLabel)) {
                removeChild(heldLabel);
            }

            if (contains(releasedLabel)) {
                removeChild(releasedLabel);
            }
        }

        protected function onWheel(e:UserInputMessage):void {
            if (arrow && contains(arrow) && contains(arrowLabel)) {
                removeChild(arrow);
                removeChild(arrowLabel);
            }

            switch (e.type) {
                case UserInputMessage.WHEEL_UP:
                    if (arrow is UpArrow) {
                        arrowCount++;
                    }
                    else {
                        arrow = new UpArrow();
                        arrowCount = 1;
                    }
                    break;
                case UserInputMessage.WHEEL_DOWN:
                    if (arrow is DownArrow) {
                        arrowCount++;
                    }
                    else {
                        arrow = new DownArrow();
                        arrowCount = 1;
                    }
                    break;
                default:
                    arrow = null;
                    arrowLabel = null;
                    arrowCount = 0;
                    break;
            }

            arrowTimer.reset();

            if (arrow) {
                if (arrowCount == 1) {
                    arrow.x = 180;
                    arrow.y = 105;

                    arrowLabel = new Label();
                    arrowLabel.x = 240;
                    arrowLabel.y = 150;
                }
                else if (arrowCount > 1) {
                    arrowLabel.text = "x" + arrowCount;
                }

                addChild(arrow);
                addChild(arrowLabel);

                arrowTimer.start();
            }

            addMessage(e.type);
        }

        protected function onArrowTimer(e:TimerEvent):void {
            if (arrow) {
                removeChild(arrow);
                removeChild(arrowLabel);
            }
        }
    }
}
