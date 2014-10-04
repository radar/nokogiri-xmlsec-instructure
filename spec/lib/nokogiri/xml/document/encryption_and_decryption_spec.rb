require 'spec_helper'

describe "encryption and decryption:" do
  subject do
    Nokogiri::XML(fixture('sign2-doc.xml'))
  end

  describe 'encrypting with an RSA public key' do
    before do
      @original = subject.to_s
      subject.encrypt! key: fixture('rsa.pub'), name: 'test'
    end

    # it generates a new key every time so will never match the fixture
    specify { expect(subject.to_s == @original).to be_falsey }
    specify { expect(subject.to_s =~ /Hello.*World/i).to be_falsey }
    # specify { subject.to_s.should == fixture('encrypt2-result.xml') }

    describe 'decrypting with the RSA private key' do
      before do
        subject.decrypt! key: fixture('rsa.pem'), name: 'test'
      end

      specify { subject.to_s.should == fixture('sign2-doc.xml') }
    end
  end

end
