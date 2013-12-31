require './item.rb'


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
      tmp = @arr[y].map{|item| item.value > 0 ? item.value.to_s + (" " * 26) : item.poss_vals.to_s + (" " * ((item.imposs_vals.size*3) ))}.join(" ") + "\n"
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

  def to_array (arr)
    arr.map{|item| item.value}.select{|i| i > 0}
  end
  
  def [](col,row)
    @arr[row][col]
  end
end

# s = Sudoku.new(arr)
# s.do_simple_check
# s.do_last_stand_check
# s.do_simple_check
# s.do_last_stand_check
# s.do_stripted_pair_check
# puts s.to_string

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
