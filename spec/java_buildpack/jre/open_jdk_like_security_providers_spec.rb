# Cloud Foundry Java Buildpack
# Copyright 2013-2017 the original author or authors.
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
require 'component_helper'
require 'fileutils'
require 'java_buildpack/jre/open_jdk_like_security_providers'

describe JavaBuildpack::Jre::OpenJDKLikeSecurityProviders do
  include_context 'component_helper'

  it 'adds extension directories with no JRE default to system properties' do
    component.release

    expect(java_opts).to include('-Djava.ext.dirs=$PWD/.java-buildpack/open_jdk_like_security_providers/' \
                                 'test-extension-directory-1:$PWD/.java-buildpack/open_jdk_like_security_providers/' \
                                 'test-extension-directory-2')
  end

  it 'adds security providers' do

    FileUtils.mkdir_p(java_home.root + 'lib/security')
    FileUtils.cp 'spec/fixtures/java.security', java_home.root + 'lib/security'

    component.compile

    expect(security_providers).to eq %w[sun.security.provider.Sun
                                        test-security-provider-1
                                        test-security-provider-2
                                        sun.security.rsa.SunRsaSign sun.security.ec.SunEC
                                        com.sun.net.ssl.internal.ssl.Provider
                                        com.sun.crypto.provider.SunJCE
                                        sun.security.jgss.SunProvider
                                        com.sun.security.sasl.Provider
                                        org.jcp.xml.dsig.internal.dom.XMLDSigRI
                                        sun.security.smartcardio.SunPCSC
                                        apple.security.AppleProvider]
  end

  it 'writes new security properties' do
    component.compile

    expect(sandbox + 'java.security').to exist
  end

  it 'adds extension directories with JRE default to system properties' do
    FileUtils.mkdir_p(java_home.root + 'lib/security/java.security')

    component.release

    expect(java_opts).to include('-Djava.ext.dirs=$PWD/.java-buildpack/open_jdk_like_security_providers/' \
                                 'test-extension-directory-1:$PWD/.java-buildpack/open_jdk_like_security_providers/' \
                                 'test-extension-directory-2:$PWD/.test-java-home/lib/ext')
  end

  it 'adds extension directories with Server JRE default to system properties' do
    FileUtils.mkdir_p(java_home.root + 'jre/lib/security/java.security')

    component.release

    expect(java_opts).to include('-Djava.ext.dirs=$PWD/.java-buildpack/open_jdk_like_security_providers/' \
                                 'test-extension-directory-1:$PWD/.java-buildpack/open_jdk_like_security_providers/' \
                                 'test-extension-directory-2:$PWD/.test-java-home/jre/lib/ext')
  end

  it 'adds security properties to system properties' do
    component.release

    expect(java_opts).to include('-Djava.security.properties=$PWD/.java-buildpack/open_jdk_like_security_providers/' \
                                 'java.security')
  end

end
