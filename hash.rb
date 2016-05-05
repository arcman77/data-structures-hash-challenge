

class MyHash
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

end
