#!/bin/ruby

#-----------------------------------------------------------
# main
#-----------------------------------------------------------
def main()
	
	#--------------------------
	# Array
	#--------------------------
	
	# 初期化
	a = Array::new
	fruits = ["apple", "orange", "lemon"]
	
	# 要素数の取得
	p fruits.size
	p fruits.length
	
	# 要素の追加
	puts "before"
	p fruits
	
	fruits << "pear"
	fruits.push("grape")
	fruits.unshift("strawberry")
	
	puts "after"
	p fruits
	
	# ブロック実行
	fruits.each {|x|
		p x
	}
	
	scores = ["55", 49, 100, "150", 0]
	p scores
	scores.each {|x|
		puts x.class
	}
	
	#--------------------------
	# Hash
	#--------------------------
	
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
	puts "before"
	p price
	
	price["pear"] = 444
	price.store("grape", 2000)
	
	puts "after"
	p price
	
	# ブロック実行
	price.each_pair {|key, val|
		printf("%s => %d\n", key, val)
	}
end


main()
