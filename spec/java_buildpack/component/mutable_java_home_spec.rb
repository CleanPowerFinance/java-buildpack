# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require 'droplet_helper'
require 'java_buildpack/component/mutable_java_home'

describe JavaBuildpack::Component::MutableJavaHome do
  include_context 'droplet_helper'

  let(:mutable_java_home) { described_class.new droplet.root }

  it 'should qualify root' do
    mutable_java_home.root = droplet.root + 'foo/bar'
    expect(mutable_java_home.root).to eq('$PWD/foo/bar')
  end

end