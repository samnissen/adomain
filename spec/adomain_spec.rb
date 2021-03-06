RSpec.describe Adomain do
  it "has a version number" do
    expect(Adomain::VERSION).not_to be nil
  end

  describe "#[]" do
    context "subdomains the string by default" do
      subject { Adomain["http://abc.google.com"] }
      it { is_expected.to eq "abc.google.com" }
    end

    context "domains when no subdomain is present" do
      subject { Adomain["http://google.com"] }
      it { is_expected.to eq "google.com" }
    end

    context "domains the string with www subdomain" do
      subject { Adomain["http://www.google.com"] }
      it { is_expected.to eq "google.com" }
    end

    context "domains the string when first boolean is true" do
      subject { Adomain["http://abc.google.com", true] }
      it { is_expected.to eq "google.com" }
    end

    context "subdomain_www the string when both booleans false, true" do
      subject { Adomain["http://www.google.com", false, true] }
      it { is_expected.to eq "www.google.com" }
    end
  end

  describe "#domain" do
    context "string represents a URL" do
      subject { Adomain.domain "http://www.name.com" }
      it { is_expected.to eq "name.com" }
    end

    context "string represents an invalid URL" do
      it "should return nil for partial urls" do
        expect( Adomain.domain "http://aloha" ).to be_nil
      end

      it "should return nil for wholly irrelevant strings" do
        expect( Adomain.domain "::::::::::" ).to be_nil
      end

      it "should return nil for Addressable-breaking strings" do
        expect{ Adomain.domain "{}" }.not_to raise_error
        expect( Adomain.domain "{}" ).to be_nil
      end
    end
  end

  describe "#subdomain" do
    context "string represents a URL" do
      subject { Adomain.subdomain "http://sam.name.com" }
      it { is_expected.to eq "sam.name.com" }
    end

    context "string represents an invalid URL" do
      it "should return nil for partial urls" do
        expect( Adomain.subdomain "http://aloha" ).to be_nil
      end

      it "should return nil for wholly irrelevant strings" do
        expect( Adomain.subdomain "::::::::::" ).to be_nil
      end
    end
  end

  describe "#subdomain_www" do
    context "string represents a URL" do
      subject { Adomain.subdomain_www "http://www.name.com" }
      it { is_expected.to eq "www.name.com" }
    end

    context "string represents an invalid URL" do
      it "should return nil for partial urls" do
        expect( Adomain.subdomain_www "http://aloha" ).to be_nil
      end

      it "should return nil for wholly irrelevant strings" do
        expect( Adomain.subdomain_www "::::::::::" ).to be_nil
      end
    end
  end

  describe "#scheme" do
    context "string represents a URL" do
      subject { Adomain.scheme "http://www.name.com" }
      it { is_expected.to eq "http" }
    end

    context "string represents an invalid URL" do
      it "should return scheme even for partial urls" do
        expect( Adomain.scheme "http://aloha" ).to eq("http")
      end

      it "should return nil for wholly irrelevant strings" do
        expect( Adomain.scheme "::::::::::" ).to be_nil
      end
    end
  end

  describe "#path" do
    context "string represents a URL" do
      subject { Adomain.path "http://www.name.com/custom/path" }
      it { is_expected.to eq "/custom/path" }
    end

    context "string represents a partial URL with www" do
      subject { Adomain.path "www.name.com/custom/path" }
      it { is_expected.to eq "/custom/path" }
    end

    context "string represents a partial URL with other subdomain" do
      subject { Adomain.path "abc.name.co.uk/custom/path" }
      it { is_expected.to eq "/custom/path" }
    end

    context "string represents a partial URL with no subdomain" do
      subject { Adomain.path "name.co.nz/custom/path" }
      it { is_expected.to eq "/custom/path" }
    end

    context "string represents an invalid URL" do
      it "should return an empty string for partial urls" do
        expect( Adomain.path "http://aloha" ).to eq("")
      end

      it "should return nil for wholly irrelevant strings" do
        expect( Adomain.scheme "::::::::::" ).to be_nil
      end
    end
  end

  describe "#query_values" do
    context "string represents a URL" do
      subject { Adomain.query_values "http://www.name.com/custom/path?params=123&other=abc" }
      it { is_expected.to eq({"params" => "123", "other" => "abc"}) }
    end

    context "string represents an invalid URL" do
      it "should return empty strings for partial urls" do
        expect( Adomain.query_values "http://aloha?&=" ).to eq({"" => ""})
      end

      it "should return nil for wholly irrelevant strings" do
        expect( Adomain.query_values ":::::::::?:" ).to be_nil
      end
    end
  end

end
