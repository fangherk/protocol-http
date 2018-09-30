#!/usr/bin/env ruby

# Copyright, 2012, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'http/protocol/reference'

RSpec.describe HTTP::Protocol::Reference do
	context 'empty query string' do
		subject {described_class.new('/', '', nil, {})}
		
		it 'it should not append query string' do
			expect(subject.to_s).to_not include('?')
		end
	end
	
	context 'empty fragment' do
		subject {described_class.new('/', nil, '', nil)}
		
		it 'it should not append query string' do
			expect(subject.to_s).to_not include('#')
		end
	end
	
	describe HTTP::Protocol::Reference.parse('path with spaces/image.jpg') do
		it "encodes whitespace" do
			expect(subject.to_s).to be == "path%20with%20spaces/image.jpg"
		end
	end
	
	describe HTTP::Protocol::Reference.parse('path', array: [1, 2, 3]) do
		it "encodes array" do
			expect(subject.to_s).to be == "path?array[]=1&array[]=2&array[]=3"
		end
	end
	
	describe HTTP::Protocol::Reference.parse('path_with_underscores/image.jpg') do
		it "doesn't touch underscores" do
			expect(subject.to_s).to be == "path_with_underscores/image.jpg"
		end
	end
	
	describe HTTP::Protocol::Reference.parse('index', 'my name' => 'Bob Dole') do
		it "encodes query" do
			expect(subject.to_s).to be == "index?my%20name=Bob%20Dole"
		end
	end
	
	describe HTTP::Protocol::Reference.parse('index#All Your Base') do
		it "encodes fragment" do
			expect(subject.to_s).to be == "index\#All%20Your%20Base"
		end
	end
	
	describe HTTP::Protocol::Reference.parse('I/❤️/UNICODE', face: '😀') do
		it "encodes unicode" do
			expect(subject.to_s).to be == "I/%E2%9D%A4%EF%B8%8F/UNICODE?face=%F0%9F%98%80"
		end
	end
	
	describe HTTP::Protocol::Reference.parse("foo?bar=10&baz=20", yes: 'no') do
		it "can use existing query parameters" do
			expect(subject.to_s).to be == "foo?bar=10&baz=20&yes=no"
		end
	end
	
	describe HTTP::Protocol::Reference.parse('foo#frag') do
		it "can use existing fragment" do
			expect(subject.fragment).to be == "frag"
			expect(subject.to_s).to be == 'foo#frag'
		end
	end
end
