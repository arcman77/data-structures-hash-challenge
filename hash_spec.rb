require_relative 'hash'

describe MyHash do
  before do
    @test = MyHash.new()
  end

  it "should return an instance of class MyHash" do
    expect(MyHash.new).not_to eq(nil)
  end

  it "should have properties/attributes: :buckets,:storage and :size" do
    expect(@test).to have_attributes(:buckets => 8)
    expect(@test).to have_attributes(:storage => [])
    expect(@test).to have_attributes(:size    => 0)
  end

  it "should have methods: :hash_algo, :set, :get, :remove, :iterate, :hash_key?" do
    expect(@test).to respond_to(:hash_algo)
    expect(@test).to respond_to(:set)
    expect(@test).to respond_to(:remove)
    expect(@test).to respond_to(:get)
    expect(@test).to respond_to(:iterate)
    expect(@test).to respond_to(:has_key?)
  end

  it ":hashing_algo should be able to return an almost unique integer given a unique string input" do
    expect(@test.hash_algo('hello', 8)).to eq(1)
  end

  it ":set method should be able to insert a new value with a given key" do
    expect(@test.size).to eq(0)
    expect(@test.storage.length).to eq(0)

    @test.set('hello', 5)
    expect(@test.size).to eq(1)
    expect(@test.storage[1][0][0]).to eq('hello')
    expect(@test.storage[1][0][1]).to eq(5)
  end

  it ":set method should be able to insert a second key-value pair " do
    expect(@test.size).to eq(0)
    expect(@test.storage.length).to eq(0)

    @test.set('hello', 5)
    expect(@test.size).to eq(1)
    expect(@test.storage[1][0][0]).to eq('hello')
    expect(@test.storage[1][0][1]).to eq(5)

    @test.set('good', 10)
    expect(@test.size).to eq(2)
    expect(@test.storage[6][0][0]).to eq('good')
    expect(@test.storage[6][0][1]).to eq(10)
  end

  it ":has_key? method should return true for a key that exists and false for keys that don't" do
    expect(@test.size).to eq(0)
    expect(@test.storage.length).to eq(0)

    @test.set('hello', 5)
    expect(@test.size).to eq(1)
    expect(@test.storage[1][0][0]).to eq('hello')
    expect(@test.storage[1][0][1]).to eq(5)

    expect(@test.has_key?('hello')).to eq(true)
    expect(@test.has_key?('lobster_buffet_all_day')).to eq(false)
  end

  it "MyHash should be able to handle hash collisions" do
    expect(@test.size).to eq(0)
    expect(@test.storage.length).to eq(0)

    @test.set('back', 5)
    expect(@test.size).to eq(1)
    expect(@test.storage[6][0][0]).to eq('back')
    expect(@test.storage[6][0][1]).to eq(5)

    @test.set('good', 10)
    expect(@test.size).to eq(2)
    expect(@test.storage[6][1][0]).to eq('good')
    expect(@test.storage[6][1][1]).to eq(10)
  end

  it ":remove method should be able to remove key-value pairs" do
    expect(@test.size).to eq(0)
    expect(@test.storage.length).to eq(0)

    @test.set('hello', 5)
    expect(@test.size).to eq(1)
    expect(@test.storage[1][0][0]).to eq('hello')
    expect(@test.storage[1][0][1]).to eq(5)
    #should not change the hash size when removing a key that doesn't exist
    @test.remove('YOLO')
    expect(@test.size).to eq(1)

    @test.remove('hello')
    expect(@test.size).to eq(0)
    expect(@test.storage[1][0][0]).to eq(nil)
    expect(@test.storage[1][0][1]).to eq(nil)
  end

  it ":iterate method should yield each key-value pair" do
    @test.set('hello',5)
    @test.set('back',10)

    expect(@test.size).to eq(2)
    expect(@test.storage[1][0][0]).to eq('hello')
    expect(@test.storage[1][0][1]).to eq(5)
    expect(@test.storage[6][0][0]).to eq('back')
    expect(@test.storage[6][0][1]).to eq(10)

    keys_and_values = []
    counter = 0

    @test.iterate do |key,value|
      keys_and_values << [key,value]
    end
    @test.storage.each_with_index do |arr,index|
      if arr
        arr.each do |array|
           expect(array[0]).to eq(keys_and_values[counter][0])
           expect(array[1]).to eq(keys_and_values[counter][1])
           counter +=1
        end
      end
    end
  end

  it ":resize method should either double or half the number of buckets depending on much space is being used" do
    #write your tests here!
  end
end





