shared_examples_for "#require_all syntactic sugar" do
  before :each do
    @file_list = [
            "#{@base_dir}/module1/a.rb",
            "#{@base_dir}/module2/longer_name.rb",
            "#{@base_dir}/module2/module3/b.rb"
    ]
  end

  it "accepts files with and without extensions" do
    is_expected.not_to be_loaded("Autoloaded::Module2::LongerName")
    expect(send(@method, @base_dir + '/module2/longer_name')).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module2::LongerName")

    is_expected.not_to be_loaded("Autoloaded::Module1::A")
    expect(send(@method, @base_dir + '/module1/a.rb')).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A")
  end

  it "accepts lists of files" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    expect(send(@method, @file_list)).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "is totally cool with a splatted list of arguments" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    expect(send(@method, *@file_list)).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "will load all .rb files under a directory without a trailing slash" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
    expect(send(@method, @base_dir)).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
  end

  it "will load all .rb files under a directory with a trailing slash" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
    expect(send(@method, "#{@base_dir}/")).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
  end

  it "will load all files specified by a glob" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
    expect(send(@method, "#{@base_dir}/**/*.rb")).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
  end

  it "returns false if an empty input was given" do
    expect(send(@method, [])).to be_falsey
    expect(send(@method)).to be_falsey
  end

  it "throws LoadError if no file or directory found" do
    expect {send(@method, "not_found")}.to raise_error(LoadError)
  end

  it "can handle empty directories" do
    expect {send(@method, "#{@base_dir}/empty_dir")}.to_not raise_error
    expect {send(@method, "#{@base_dir}/nested")}.to_not raise_error
  end
end
