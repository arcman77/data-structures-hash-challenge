
function hashTable(){
    this.size = 0;
    this.buckets = 8;
    this.storage = [];
    this.djb2Code = function(str, buckets) {
      var hash = 5381;
      for (i = 0; i < str.length; i++) {
        char = str.charCodeAt(i);
        hash = ((hash << 5) + hash) + char; /* hash * 33 + c */
      }
      return hash % buckets;
    };
    this.djb2Code = this.djb2Code.bind(this);
    this.hash = function(string){
      return this.djb2Code(string,this.buckets);
    }
    this.insert = function(key,value){
      var keyIndex = this.hash(key);
      var bucket   = this.storage[keyIndex]
      if(!bucket){
        this.storage[keyIndex] = [];
        bucket = this.storage[keyIndex];
      } //if the bucket doesnt exist, make it
      for(var i=0; i<bucket.length; i++){
        if(bucket[i][0] === key){
          bucket[i][1] = value;
          return;
        }
      }
      bucket.push([key,value]);
      this.size ++;
      //this.resize();
      if(this.size > this.buckets*0.75)
        this.resize();
    }
    this.delete = function(key){
      var keyIndex = this.hash(key);
      var bucket = this.storage[keyIndex];
      console.log(keyIndex,key)
      if(bucket){
        for(var i = 0; i<bucket.length; i++){
          console.log(bucket[i][0],key);
          if(bucket[i][0] === key){
            bucket[i][0] = undefined;
            bucket[i][1] = undefined;
            this.size --;
            //this.resize();
            if(this.size <= this.buckets / 4)
              this.resize();
            break;
          }
        }//end for
      }else{
        return undefined;
      }
    }//end delete
    this.retrieve = function(key){
      var keyIndex = this.hash(key);
      var bucket   = this.storage[keyIndex];
      if(bucket){
        for(var i=0; i<bucket.length; i++){
          if(bucket[i][0] === key){
            return bucket[i][1];
          }
        }
      }else{
         //console.log(keyIndex,"keyIndex => ",key," ",this.storage);
        return null;
      }
    }//retrieve
    this.resize = function(){
      if(this.size > this.buckets*0.75)
        this.buckets = this.buckets*2;
      if(this.size <= this.buckets / 4)
        this.buckets = Math.floor(this.buckets/2);
    }//resize
  }









////////////////////////////////////////////////////////////
///////////////  DO NOT TOUCH TEST BELOW!!!  ///////////////
////////////////////////////////////////////////////////////

var expect = require('chai').expect;

describe('hash table class ', function(){

  describe('hashTable properties', function(){
    it('should have properties storage, buckets, and size', function(){
      var test = new hashTable();

      expect(test).to.have.property('storage');
      expect(test).to.have.property('buckets');
      expect(test).to.have.property('size');
      expect(test.storage.length).to.equal(0);
      expect(test.size).to.equal(0);
    });
  });

  describe('hashTable methods existence', function(){
    it('should have methods hash, insert, delete, and retrieve', function(){
      var test = new hashTable();

      expect(test).to.respondTo('hash');
      expect(test).to.respondTo('insert');
      expect(test).to.respondTo('delete');
      expect(test).to.respondTo('retrieve');
    });
  });

  describe('hashTable hash method', function(){
    it('should return an index from an inputted string', function(){
      var test = new hashTable();

      var expected = test.hash('hello');
      expect(expected).to.equal(1);
    })
  });

  describe('hashTable insert method', function(){
    it('should be able to insert a key-value pair', function(){
      var test = new hashTable();

      expect(test.storage.length).to.equal(0);
      expect(test.size).to.equal(0);

      test.insert('hello', 5);

      expect(test.size).to.equal(1);
      expect(test.storage[1][0][0]).to.equal('hello');
      expect(test.storage[1][0][1]).to.equal(5);
    });

    it('should be able to insert a second key-value pair', function(){
      var test = new hashTable();

      expect(test.storage.length).to.equal(0);
      expect(test.size).to.equal(0);

      test.insert('hello', 5);

      expect(test.size).to.equal(1);
      expect(test.storage[1][0][0]).to.equal('hello');
      expect(test.storage[1][0][1]).to.equal(5);

      test.insert('good', 10);

      expect(test.size).to.equal(2);
      expect(test.storage[6][0][0]).to.equal('good');
      expect(test.storage[6][0][1]).to.equal(10);
    });

    it('should be able to handle collisions', function(){
      var test = new hashTable();

      expect(test.storage.length).to.equal(0);
      expect(test.size).to.equal(0);

      test.insert('good', 5);

      expect(test.size).to.equal(1);
      expect(test.storage[6][0][0]).to.equal('good');
      expect(test.storage[6][0][1]).to.equal(5);

      test.insert('back', 10);

      expect(test.size).to.equal(2);
      expect(test.storage[6][1][0]).to.equal('back');
      expect(test.storage[6][1][1]).to.equal(10);
    });
  });

  describe('hashTable delete method', function(){
    it('should delete a key-value pair', function(){
      var test = new hashTable();

      expect(test.storage.length).to.equal(0);
      expect(test.size).to.equal(0);

      test.insert('hello', 5);

      expect(test.size).to.equal(1);
      expect(test.storage[1][0][0]).to.equal('hello');
      expect(test.storage[1][0][1]).to.equal(5);

      test.delete('hello');

      expect(test.size).to.equal(0);
      expect(test.storage[1][0][0]).to.equal(undefined);
      expect(test.storage[1][0][1]).to.equal(undefined);

    });

    it('should not modify the size when deleting a key-value pair that does not exist', function(){
      var test = new hashTable();
      test.insert('hello', 5);
      test.insert('good', 10);

      expect(test.size).to.equal(2);

      test.delete('great');

      expect(test.size).to.equal(2);
    });
  });

  describe('hashTable retrieve method', function(){
    it('should return value for a key-value pair that exists', function(){
      var test = new hashTable();

      test.insert('hello', 5);
      // console.log("storage: ",test.storage);
      // console.log(test.retrieve('key'));
      expect(test.retrieve('hello')).to.equal(5);


    });

    it('should return null for a key-value pair that does not exist', function(){
      var test = new hashTable();

      test.insert('hello', 5);

      expect(test.retrieve('good')).to.equal(null);
    });
  });

  describe('hashTable resize method', function(){
    it('should double the number of buckets when the size exceeds 75% of buckets capacity', function(){
      var test = new hashTable();

      test.insert('hello', 5);
      test.insert('good', 7);
      test.insert('haha', 10);
      test.insert('blah', 2);
      test.insert('foo', 3);
      test.insert('bar', 8);
      test.insert('taste', 1);

      expect(test.buckets).to.equal(16);


    });

    it('should halve the number of buckets when the size drops below 25% of bucket capacity', function(){
      var test = new hashTable();

      test.insert('hello', 5);
      test.insert('good', 7);
      test.insert('haha', 10);
      test.insert('blah', 2);
      test.insert('foo', 3);
      test.insert('bar', 8);
      test.insert('taste', 1);
      console.log(test.size);
      expect(test.buckets).to.equal(16);

      test.delete('hello');
      test.delete('good');
      test.delete('haha');
      test.delete('blah');
      console.log(test.size);
      console.log(test.storage)

      expect(test.buckets).to.equal(8);

    });
  });

})