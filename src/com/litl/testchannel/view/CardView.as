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

    public class CardView extends TestView {
        public function CardView(model:TestModel) {
            super(model);

            model.service.addEventListener(UserInputMessage.MOVE_NEXT_ITEM, handleMove);
            model.service.addEventListener(UserInputMessage.MOVE_PREVIOUS_ITEM, handleMove);

            updateDisplay();
        }



        private function handleMove(e:UserInputMessage):void {
            switch (e.type) {
                case UserInputMessage.MOVE_NEXT_ITEM:
                        _model.moveNextItem();
                    break;
                case UserInputMessage.MOVE_PREVIOUS_ITEM:
                        _model.movePrevItem();
                    break;
                default:
                    break;
            }
            addMessage("[" + _model.currentItem + "/" + _model.itemCount +"] " + e.type + " item");
        }

        override protected function updateDisplay():void {
            super.updateDisplay();

            viewLabel.text = "card view";
        }
    }
}
