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

    public class ChannelView extends TestView {
        public function ChannelView(model:TestModel) {
            super(model);

            messages.setSize(600, 600);

            model.service.addEventListener(UserInputMessage.GO_BUTTON_HELD, onGoButton);
            model.service.addEventListener(UserInputMessage.GO_BUTTON_PRESSED, onGoButton);
            model.service.addEventListener(UserInputMessage.GO_BUTTON_RELEASED, onGoButton);
            model.service.addEventListener(UserInputMessage.WHEEL_UP, onWheel);
            model.service.addEventListener(UserInputMessage.WHEEL_DOWN, onWheel);

        }

        override protected function updateDisplay():void {
            super.updateDisplay();

            viewLabel.text = "channel view";
        }

        protected function onGoButton(e:UserInputMessage):void {
            switch (e.type) {
                case UserInputMessage.GO_BUTTON_PRESSED:
                    break;
                case UserInputMessage.GO_BUTTON_HELD:
                    _model.toggleWheel();
                    break;
                case UserInputMessage.GO_BUTTON_RELEASED:
                    break;
                default:
                    break;
            }

            addMessage(e.type);
        }

        protected function onWheel(e:UserInputMessage):void {
            addMessage(e.type);
        }
    }
}
