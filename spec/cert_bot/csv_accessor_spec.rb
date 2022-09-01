require "spec_helper"
require_relative "../../lib/cert_bot/csv_accessor"

describe CertBot::CsvAccessor do


  describe ".read_csv" do
    context "given a csv file path" do
      it "open the file and read its data" do
        csv_accessor = CertBot::CsvAccessor.new(TEST_DATA.join("test_data.csv").expand_path, ";")
        csv_accessor.read_csv
        expect(csv_accessor.data.size).to eq(3)
        expect(csv_accessor.data[1][1]).to eq("test11")
      end
    end
  end

  describe ".read_csv" do
    context "given an invalid csv file path" do
      it "try to open the file and run into an exception" do
        expect { 
          csv_accessor = CertBot::CsvAccessor.new(TEST_DATA.join("invalid.csv").expand_path, ";")
          csv_accessor.read_csv
        }.to raise_error(IOError)
      end
    end
  end

  describe ".append_row" do
    context "given a csv formatted row" do
      it "create the file and write data" do
        csv_accessor = CertBot::CsvAccessor.new(TEST_DATA.join("output_data.csv").expand_path, ";")
        csv_accessor.append_row(["output00", "output01", "output02"])

        expect(FileUtils.compare_file(File.new(TEST_DATA.join("output_data.csv")), File.new(TEST_DATA.join("check_data.csv")))).to be_truthy
        
        # clean up data from the test and catch errors since they should not let the test fail
        File.delete(TEST_DATA.join("output_data.csv"))
      end
    end
  end

end
