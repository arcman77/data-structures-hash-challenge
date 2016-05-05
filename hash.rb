class MyHash
  #attr_accessor
  attr_reader :size, :buckets, :storage
  def initialize
    @size = 0;
    @buckets = 8;
    @storage = [];
  end

  def set(key,value)
    key_index = hash_algo(key,@buckets)
    bucket    = @storage[key_index]
    # if the bucket doesn't exist yet, create it
    if !bucket
      @storage[key_index] = []
      bucket = @storage[key_index]
    end
    bucket.each_with_index do |arr,index|
      if bucket[index][0] == key
        bucket[index][1] = value
        return
      end
    end
    bucket << [key,value]
    @size += 1
    if @size > @buckets*0.75
      @resize
    end
  end

  def remove(key)
    key_index = hash_algo(key, @buckets)
    bucket    = @storage[key_index]
    if bucket
      bucket.each_with_index do |arr,index|
        if bucket[index][0] === key
          bucket[index][0] = nil
          bucket[index][1] = nil
          @size -= 1
          if @size <= buckets*0.75
            resize
          end
          break
        end
      end
    else
      return nil
    end
  end

  def get(key)
    key_index = hash_algo(key,@buckets)
    bucket    = @storage[key_index]
    if bucket
      bucket.each_with_index do |arr,index|
        if bucket[index][0] === key
          return bucket[index][1]
        end
      end
    else
      return nil
    end
  end

  def has_key?(key)
    key_index = hash_algo(key,@buckets)
    bucket    = @storage[key_index]
    if bucket
      bucket.each_with_index do |arr,index|
        if bucket[index][0] === key
          return true
        end
      end
    end
    return false
  end

  def iterate
    @storage.each_with_index do |arr,index|
      if arr
        arr.each do |array|
                #key     #value
          yield array[0],array[1]
        end
      end
    end
  end

  #bonus points for resize method
  def resize
    #stretch challenge points re-index buckets when the size of the hash table exceeds 75% of the total buckets
    # - increase the number of buckets
  end

  def hash_algo(str, buckets)
    #Hashing function to hash a string, using an implementation of Dan Bernstein's djb2
    # for more details see http://www.aaronsw.com/weblog/djb and/or http://www.cse.yorku.ca/~oz/hash.html


    #arbitrary large prime number to initialize, hash = 5381
    # Input: str - a string that is to be hashed
    # Output: integer between 0 and buckets-1 (inclusive)
    prime = 5381
    str.split("").each do |i|
        char = i
        prime = ((prime << 5) + prime) + char.ord
    end
    return prime % buckets
  end
    # I think a basic hashing algorithm should be given by default to the students for this challenge. For starters, asking the students to create their own hashing algorithm is setting them down a rabbit hole that never ends - there is no perfect hashing function that can ever perfectly avoid collisions and generate index values that stay within the bounds of the number of buckets the hash table holds.
    # I also think it distracts from the main purpose of the challenge. Hashes are built off of using a one way hashing function, and using that function to effectively give constant look up time for all operations is whats actually cool about it. In my implementation of the MyHash you'll see how I used the hashing algo in pretty much every method. That alone is a good start to understanding the Hash class.

    #If anything the hashing algorithm should be a stretch challenge to complete afterwards.
end






