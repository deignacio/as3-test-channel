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
    import com.litl.control.TextButton;
    import com.litl.sdk.enum.PropertyScope;
    import com.litl.sdk.message.OptionsStatusMessage;
    import com.litl.sdk.message.PropertyMessage;
    import com.litl.sdk.service.LitlService;
    import com.litl.testchannel.model.TestModel;

    import flash.events.Event;

    public class FocusView extends TestView {
        protected var zipcode:TextButton;

        public function FocusView(model:TestModel) {
            super(model);

            messages.setSize(600, 600);

            zipcode = new TextButton();
            zipcode.move(250, 20);
            zipcode.text = "click to refresh zipcode";
            zipcode.addEventListener(Event.SELECT, onZipcodeClick, false, 0, true);
            addChild(zipcode);

            //model.service.addEventListener(PropertyMessage.PROPERTY_CHANGED, onProperties);
            model.service.addEventListener(OptionsStatusMessage.OPTIONS_STATUS, onOptions);
        }

        override protected function updateDisplay():void {
            super.updateDisplay();

            viewLabel.text = "focus view";
        }

        protected function onZipcodeClick(e:Event):void {
            zipcode.text = "device zipcode = " + _model.service.zipCode;
        }

        protected function onOptions(e:OptionsStatusMessage):void {
            addMessage("options open? " + e.optionsOpen);
        }

        protected function onProperties(e:PropertyMessage):void {
            if (e.propertyScope == PropertyScope.GLOBAL) {
                trace("global properties changed.  refreshing zipcode");
                zipcode.text = "device zipcode = " + _model.service.zipCode;
            }
        }
    }
}
