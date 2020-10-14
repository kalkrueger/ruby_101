1) [1, 2, 3] the last object, 'hi', is "truthy"

2) It considers the truthiness of the blocks values. We can find this in the Ruby docs

3) [1, 2, 3] the return of a puts will always be nil

4) { "a" => "ant", "b" => "bear", "c" => "cat" }
    We are asking it to create a hash and set the key to the fisrt letter of each word

5) It removes {a: 'ant'} from the hash.  
    We can look up 'shift' in the Ruby Docs under the Hash class

6) 11. We are asking for the size of the item that was removed with 'pop'

7) Block = true, the block will return the last expression in the blocks
    any? = true, there are odd values in the array

8) 'take' returns the first specified number of elements in the array. It is not destructive.
    We can find this by looking up 'take' in the Array class in Ruby docs

9) [nil, bear] it returns the value of any value longer than 3 but it must return an
    array equal to the length of the original array

10) [1, nil, nil]  puts num will return nil 
