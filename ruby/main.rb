class SlotGame
  
  def initialize
    preset
  end
  
  def preset
    @coin = 100
    @score = 0
    
    @vertical = 3
    @horizontal = 3
  end
  
  def show_coin_and_score
    puts "coin: #{@coin}"
    puts "score: #{@score}"
  end
  
  def input_amount_message
    show_coin_and_score
    puts "0(10コイン) 1(30コイン) 2(50コイン) 3(やめる)"
  end
  
  def num_to_amount(num)
    case num
    when 0
      return 10
    when 1
      return 30
    when 2
      return 50
    when 3
      return "stop"
    end
  end
  
  def get_input_amount
    isLoop = true
    while isLoop
      input_amount_message
      input_amount = gets.chomp.to_i
      if input_amount >= 0 && input_amount <= 3 then
        isLoop = false
      end
    end
    @amount = num_to_amount(input_amount)
  end
  
  def finish_message
    puts "ゲームを終了します"
    show_coin_and_score
  end
  
  def isStart
    if @amount == "stop" then
      @isLoopToSlot = false
      finish_message
      return false
    elsif @coin < @amount then
      puts "所持コインが足りません"
      return false
    end
    
    return true
  end
    
  def isContinue
    if @coin < 10 then
      finish_message
      @isLoopToSlot = false
    end
  end
  
  def show_slot(ary)
    @horizontal.times do |hor_time|
      @vertical.times do |vert_time|
        print "|#{ary[vert_time][hor_time]}|"
      end
      puts ""
    end
  end
  
  def slot_message
    puts("Enterキーを#{@horizontal}回押して")
    gets
  end
  
  def generate_slot_ary
    element = []
    @vertical.times do
      element.push(rand(10))
    end
    return element
  end
  
  def slot
    ary = Array.new(@horizontal, Array.new(@vertical))

    @horizontal.times do |time|
      slot_message
      
      ary[time] = generate_slot_ary
      
      show_slot(ary)
    end
    
    @slot_ary = ary
    
  end
  
  def reward(num)
    puts "#{num}が揃いました！"
    earned_coin = @amount * 10
    earned_score = @amount * 25
    
    if num == 7 then
      earned_coin *= 2
      earned_score *= 2
      puts "ラッキー7で獲得コイン、スコアが２倍！"
    end
    
    puts "#{earned_coin}コインゲット!"
    puts "#{earned_score}スコアゲット!"
    
    @coin += earned_coin
    @score += earned_score
    
  end

  def evaluation_hor
    @vertical.times do |vert_time|
      for i in 0..@horizontal - 2 do
        if !(@slot_ary[i][vert_time] == @slot_ary[i + 1][vert_time]) then
          break
        elsif i == @horizontal - 2 then
          reward(@slot_ary[i][vert_time])
        else
          next
        end
      end
    end
  end
  
  def evaluation_closs
    if @horizontal == @vertical then
      for i in 0..@horizontal - 2 do
        if !(@slot_ary[i][i] == @slot_ary[i + 1][i + 1]) then
          break
        elsif i == @horizontal - 2 then
          reward(@slot_ary[i][i])
          puts "a"
        else
          next
        end
      end
      for i in 0..@horizontal - 2 do
        hor = @horizontal - 1 - i
        
        if !(@slot_ary[hor][i] == @slot_ary[hor - 1][i + 1]) then
          break
        elsif i == @horizontal - 2 then
          reward(@slot_ary[hor][i])
          puts "b"
        else
          next
        end
      end
    end
  end
  
  def evaluation
    evaluation_hor
    evaluation_closs
  end
  
  def slot_game
    get_input_amount
    
    if isStart then
      @coin -= @amount
      
      slot
      evaluation
      
    end
  end
  
  def start
    @isLoopToSlot = true
    while @isLoopToSlot
      slot_game
      isContinue
    end
  end
end

game = SlotGame.new()
game.start