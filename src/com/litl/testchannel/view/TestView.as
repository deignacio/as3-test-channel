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
    import com.litl.control.VerticalList;
    import com.litl.helpers.view.ViewBase;
    import com.litl.testchannel.model.TestModel;

    public class TestView extends ViewBase
    {
        protected var model:TestModel;
        protected var viewLabel:Label;
        protected var sizeLabel:Label;
        protected var _slideshowKey:String;
        protected var _color:uint;

        protected var messages:VerticalList;

        public function TestView(model:TestModel, color:uint) {
            this._color = color;
            this.model = model;

            _slideshowKey = "";

            viewLabel = new Label();
            viewLabel.move(25, 10);
            addChild(viewLabel);

            sizeLabel = new Label();
            sizeLabel.move(25, 35);
            addChild(sizeLabel);

            messages = new VerticalList();
            messages.verticalScrollPolicy = "off";
            messages.itemSize = 20;
            messages.setSize(400, 100);
            messages.move(10, 60);
            messages.dataProvider = model.messages;
            //addChild(messages);
            updateDisplay();
        }

        public function onResume():void {
        }

        public function onPause():void {
        }

        protected function addMessage(msg:String):void {
            model.addMessage(msg);
            messages.refresh();
        }

        protected function updateDisplay():void {
            messages.refresh();
            sizeLabel.text = "(" + width + ", " + height + ")";

            viewLabel.text = slideshowKey;
            viewLabel.validateNow();
        }

        override public function setSize(newWidth:Number, newHeight:Number):void {
            super.setSize(newWidth, newHeight);

            graphics.clear();
            graphics.beginFill(this._color);
            graphics.drawRect(0, 0, newWidth, newHeight);
            graphics.endFill();

            updateDisplay();
        }

        public function set slideshowKey(value:String):void {
            _slideshowKey = value;

            this.updateDisplay();
        }

        public function get slideshowKey():String {
            return _slideshowKey;
        }
    }
}
