require 'spec_helper'

describe Geocodio::Address do
  let(:geocodio) { Geocodio::Client.new }

  context 'when parsed' do
    subject(:address) do
      VCR.use_cassette('parse') do
        geocodio.parse('54 West Colorado Boulevard Pasadena CA 91105')
      end
    end

    it 'has a number' do
      expect(address.number).to eq('54')
    end

    it 'has a predirectional' do
      expect(address.predirectional).to eq('W')
    end

    it 'has a street' do
      expect(address.street).to eq('Colorado')
    end

    it 'has a suffix' do
      expect(address.suffix).to eq('Blvd')
    end

    it 'has a city' do
      expect(address.city).to eq('Pasadena')
    end

    it 'has a state' do
      expect(address.state).to eq('CA')
    end

    it 'has a zip' do
      expect(address.zip).to eq('91105')
    end

    it 'does not have a latitude' do
      expect(address.latitude).to be_nil
      expect(address.lat).to      be_nil
    end

    it 'does not have a longitude' do
      expect(address.longitude).to be_nil
      expect(address.lng).to       be_nil
    end

    it 'does not have an accuracy' do
      expect(address.accuracy).to be_nil
    end
  end

  context 'when geocoded' do
    subject(:address) do
      VCR.use_cassette('geocode') do
        geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105']).best
      end
    end

    it 'has a number' do
      expect(address.number).to eq('54')
    end

    it 'has a predirectional' do
      expect(address.predirectional).to eq('W')
    end

    it 'has a street' do
      expect(address.street).to eq('Colorado')
    end

    it 'has a suffix' do
      expect(address.suffix).to eq('Blvd')
    end

    it 'has a city' do
      expect(address.city).to eq('Pasadena')
    end

    it 'has a state' do
      expect(address.state).to eq('CA')
    end

    it 'has a zip' do
      expect(address.zip).to eq('91105')
    end

    it 'has a latitude' do
      expect(address.latitude).to eq(34.145760590909)
      expect(address.lat).to      eq(34.145760590909)
    end

    it 'has a longitude' do
      expect(address.longitude).to eq(-118.15204363636)
      expect(address.lng).to       eq(-118.15204363636)
    end

    it 'has an accuracy' do
      expect(address.accuracy).to eq(1)
    end

    context 'with additional fields' do
      subject(:address) do
        VCR.use_cassette('geocode_with_fields') do
          geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school timezone]).best
        end
      end

      it 'has a congressional district' do
        expect(address.congressional_district).to be_a(Geocodio::CongressionalDistrict)
      end

      it 'has a house district' do
        expect(address.house_district).to be_a(Geocodio::StateLegislativeDistrict)
      end

      it 'has a senate district' do
        expect(address.senate_district).to be_a(Geocodio::StateLegislativeDistrict)
      end

      it 'has a unified school district' do
        expect(address.unified_school_district).to be_a(Geocodio::SchoolDistrict)
      end

      it 'could have an elementary school district' do
        expect(address.elementary_school_district).to be_nil
      end

      it 'could have a secondary school district' do
        expect(address.secondary_school_district).to be_nil
      end

      it 'has a timezone' do
        expect(address.timezone).to be_a(Geocodio::Timezone)
      end
    end
  end
end
