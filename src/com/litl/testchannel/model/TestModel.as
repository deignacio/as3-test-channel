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

package com.litl.testchannel.model {
    import com.litl.sdk.service.LitlService;

    public class TestModel {
        protected var _service:LitlService;

        protected var _messages:Array;

        protected var _itemCount:int;
        public var currentItem:int;

        public function TestModel(service:LitlService) {
            _service = service;

            _messages = new Array();
        }

        public function get service():LitlService {
            return _service;
        }

        public function setTitle(value:String):void {
            _service.channelTitle = value;
        }

        public function set itemCount(value:int):void {
            _itemCount = value;
            _service.channelItemCount = value;
            currentItem = 0;
        }

        public function get itemCount():int {
            return _itemCount;
        }

        public function moveNextItem():int {
            currentItem = (currentItem + 1) % itemCount;
            return currentItem;
        }

        public function movePrevItem():int {
            currentItem = (currentItem -1) % itemCount;
            return currentItem;
        }

        public function toggleWheel():void {
            if (_service.wheelEnabled) {
                _service.disableWheel();
            } else {
                _service.enableWheel();
            }
        }

        public function get messages():Array {
            return _messages;
        }

        public function addMessage(msg:String):void {
            var now:Date = new Date();
            _messages.unshift("[" + now.getTime() + "]" + msg);
        }
    }
}
