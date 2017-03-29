#!/bin/ruby

#--------------------------
# Array
#--------------------------
def test_array()
	
	puts "******* array *******"
	
	# 初期化
	a = Array::new
	fruits = ["apple", "orange", "lemon"]
	
	# 要素数の取得
	p fruits.size
	p fruits.length
	
	# 要素の追加
	fruits << "pear"
	fruits.push("grape")
	fruits.unshift("strawberry")
	p fruits
	
	# ブロック実行
	fruits.each {|x|
		p x
	}
	
	# データ型の混在
	scores = ["55", 49, 5.5, "150", 0]
	p scores
	scores.each {|x|
		puts "#{x} : #{x.class}"
	}

end


#--------------------------
# Hash
#--------------------------
def test_hash()

	puts "******* hash *******"
	
	# 初期化
	h = Hash::new
	price = {
		"apple" => 398,
		"orange" => 600,
		"banana" => 10000
	}
	
	# 要素数の取得
	p price.size
	p price.length
	
	# 要素の追加
	price["pear"] = 444
	price.store("grape", 2000)
	p price
	
	# ブロック実行
	price.each_pair {|key, val|
		printf("%s => %d\n", key, val)
	}
end

test_array()
test_hash()
