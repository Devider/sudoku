

# HARD
arr = [
  [0,0,8, 0,0,7, 0,0,0],
  [3,0,0, 5,4,0, 2,0,0],
  [6,0,0, 0,0,0, 0,0,0],

  [0,4,1, 0,0,2, 0,0,0],
  [0,2,0, 8,1,3, 0,4,0],
  [0,0,0, 9,0,0, 6,2,0],

  [0,0,0, 0,0,0, 0,0,5],
  [0,0,7, 0,6,1, 0,0,2],
  [0,0,0, 2,0,0, 1,0,0]
]

#SIMLE
# arr = [
# [5,0,1, 8,0,0, 2,9,0],
# [0,2,0, 0,0,1, 0,7,0],
# [0,9,4, 0,0,3, 0,0,5],
# 
# [9,4,6, 0,0,8, 0,0,7],
# [0,1,0, 0,0,0, 0,6,0],
# [3,0,0, 6,0,0, 4,2,1],
# 
# [6,0,0, 7,0,0, 8,3,0],
# [0,3,0, 9,0,0, 0,1,0],
# [0,7,9, 0,0,2, 5,0,6]
# ]

#EXAMPLE
# arr = [
  # [2,0,0, 0,7,0, 0,3,8],
  # [0,0,0, 0,0,6, 0,7,0],
  # [3,0,0, 0,4,0, 6,0,0],
# 
  # [0,0,8, 0,2,0, 7,0,0],
  # [1,0,0, 0,0,0, 0,0,6],
  # [0,0,7, 0,3,0, 4,0,0],
# 
  # [0,0,4, 0,8,0, 0,0,9],
  # [0,6,0, 4,0,0, 0,0,0],
  # [9,1,0, 0,6,0, 0,0,2]
# ]

SIZE = 9
ALL = [1,2,3,4,5,6,7,8,9]
class Sudoku
  def initialize(arr)
    @arr = []
    (0...SIZE).each {|y|
      row = []
      (0...SIZE).each {|x|
        row << Item.new(x, y, arr[y][x])
      }
      @arr << row
    }
  end

  def row_at(num)
    @arr[num]
  end

  def column_at(num)
    arr = []
    (0...SIZE).each {|y|
      arr << @arr[y][num]
    }
    arr
  end

  def box_at(col, row)
    x_arr = (0...SIZE).to_a.select {|k| k / 3 == (col) / 3}
    y_arr = (0...SIZE).to_a.select {|k| k / 3 == (row) / 3}
    block = []
    y_arr.each{|y|
      x_arr.each{|x|
        block << @arr[y][x]
      }
    }
    block
  end
  
  # 1 2 3
  # 4 5 6
  # 7 8 9
  
  def box(number)
    n = number - 1
   
    x_arr = (0...SIZE).to_a.select {|k| k / 3 == (n) % 3}
    y_arr = (0...SIZE).to_a.select {|k| k / 3 == (n) / 3}
    block = []
    y_arr.each{|y|
      x_arr.each{|x|
        block << @arr[y][x]
      }
    }
    block
  end

  def used_numbers_for(col, row)
    to_array(row_at(row) | column_at(col) | box_at(col,row)) - [@arr[row][col].value]
  end
  
  def to_string
    puts
    puts '----------------------------------------------------'
     out = ""
    (0...SIZE).each {|y|
      out << "\n" if y%3 == 0 && y != 0
      tmp = @arr[y].map{|item| item.value > 0 ? item.value.to_s + "                          " : item.poss_vals.to_s + (" " * ((item.imposs_vals.size*3) ))}.join(" ") + "\n"
      out << tmp 
    }
    out   
  end

  def to_s
    out = ""
    (0...SIZE).each {|y|
      out << "\n" if y%3 == 0 && y != 0
      tmp = @arr[y].map{|item| item.value > 0 ? item.value : "?"}.join(" ") + "\n"
      tmp.insert(6, ' ')
      tmp.insert(12, ' ')
      out << tmp 
    }
    out
  end

  def do_simple_check
    result = false
    begin
    result = false
    (0...SIZE).each {|row|
    (0...SIZE).each {|col|
        next if @arr[row][col].is_ok
        @arr[row][col].imposs_vals=used_numbers_for(col, row)
        result = true if @arr[row][col].is_ok
      }
    }
    end while result
  end

  def do_last_stand_check
    result = false
    begin
    result = false
    (0...SIZE).each {|row|
    (0...SIZE).each {|col|
        check_for_last_stand(col,row)
      }
    }
    end while result
  end
  
  def do_stripted_pair_check
    (0..8).each {|n|
      arr = box(n)
      pairs = check_for_pairs(arr)
      clean_block(arr, pairs)
       
      
      arr = column_at(n)
      pairs = check_for_pairs(arr)
      clean_block(arr, pairs)

      arr = row_at(n)
      pairs = check_for_pairs(arr)
      clean_block(arr, pairs) 
    }    
  end
  
  private
  
  def clean_block(arr, hash)
    hash.each {|key, value|
      p "key=#{key} value=#{value} arr.size=#{arr.size}" 
      (arr - value).each{|item|
        p "col=#{item.col} row=#{item.row} item.add_imposs_vals(#{key})" 
        item.add_imposs_vals(key)
      }
    }
  end
  
  def check_for_pairs (arr)
    hash = {}
    arr.each do |item|
      pos_vals = item.poss_vals
      if (pos_vals.size == 2)
        hash[pos_vals] = (hash[pos_vals] || 0) + 1
      end
    end 
    
    result = {}  
    hash.each {|key, value| 
      #p "key=#{key} value=#{value} " if value > 1
      result[key] = arr.select{|item| item.poss_vals == key} if (value >= key.size) && (value > 1) 
    }
    result
  end

  def check_for_last_stand(col,row)
    return false if @arr[row][col].is_ok
    rows = row_at(row) - [@arr[row][col]]
    val = check_array_for_last_stand(rows)
    @arr[row][col].value=val if val > 0
    return true if val > 0
    
    
    cols = column_at(col) - [@arr[row][col]]
    val = check_array_for_last_stand(cols)
    @arr[row][col].value=val if val > 0
    return true if val > 0
    
    box = box_at(col,row) - [@arr[row][col]]
    val = check_array_for_last_stand(box)
    @arr[row][col].value=val if val > 0
    return true if val > 0
    return false
  end  
    
  def check_array_for_last_stand(arr)
    result = Array.new(SIZE + 1, 0)
    arr.each do |item|
      item.imposs_vals.each do |value|
        result[value] += 1
      end
    end
    for i in 1...SIZE
      return i if result[i] == SIZE-1 
    end
    return 0
  end

  def to_array (arr)
    arr.map{|item| item.value}.select{|i| i > 0}
  end
end

class Item
  
  attr_reader :is_ok, :value, :imposs_vals, :row, :col
  def value=(val)
    @value = val
    @imposs_vals = ALL - [val]
    @is_ok = true if @value > 0
  end
  
  def poss_vals
    (ALL - @imposs_vals).sort
  end

  def imposs_vals=(arr)
    @imposs_vals |= arr
    return if @is_ok
    if (@imposs_vals.size == SIZE-1)
      @value = (ALL - @imposs_vals)[0]
      @is_ok = true
    end
  end
  
  def add_imposs_vals(vals)
    self.imposs_vals=vals
  end

  def initialize(col, row, val)
    @col, @row = col, row
    if (val == 0)
      @value = 0
      @is_ok = false
      @imposs_vals = []
    else
      @value = val
      @is_ok = true
      @imposs_vals = ALL - [val]
    end
  end
  
  def inspect
    "col=#{col}  row=#{row} pos_vals=#{poss_vals}"
  end
  
  def to_s
    pv = poss_vals
    if @value > 0
      @value.to_s
    elsif  pv.size == 2
      pv.to_s
    else
      "[....]"
    end
  end
end

s = Sudoku.new(arr)
s.do_simple_check
s.do_last_stand_check
s.do_simple_check
s.do_last_stand_check
s.do_stripted_pair_check
puts s.to_string

# puts '-------------------'
# s.do_simple_check
# s.do_last_stand_check
# s.do_simple_check
# s.do_last_stand_check
# s.do_simple_check
# s.do_last_stand_check
# s.do_simple_check
# s.do_last_stand_check
# puts '-------------------'
