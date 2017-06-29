class Golfer
  attr_accessor :firstname
  attr_accessor :lastname
  attr_accessor :currentQuota
  attr_accessor :previousResults
  attr_accessor :databaseID
  attr_accessor :handicap

  def initialize(firstName, lastName, currentQuota, id=0)
    @firstname = firstName
    @lastname = lastName
    @currentQuota = currentQuota
    @databaseID = id
    @previousResults = []
    @handicap = handicap
  end



  def buildQuota # We need to build a quota for a new golfer.

    #easiest way to do this is just add 36 minus the handicap to the previousResults 10 times
    10.times do
      @previousResults.push (36 - @handicap)
    end
  end

  def info
    "#{@lastname}, #{@firstname}\nQuota: #{@currentQuota}\n\n"
  end


  def name
    return "#{lastname}, #{firstname}"
  end


  def getCurrentQuota
    latestTen = previousResults[-10..-1]

    sum = 0

    latestTen.each do |value|
      sum += value.to_i
    end

    return (sum/10)
  end

  private


end

