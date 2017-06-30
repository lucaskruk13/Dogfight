require './Golfer'
require './SQLGenerator'
require './InstallDatabase'
require 'terminal-table'
require 'date'
require 'active_support/inflector'

class Menu

  attr_reader :fullMenu

  def initialize
    @fullMenu = Array.new

    @sqler = SQLGenerator.new
    @golfers = @sqler.golfers

  end




  def fullMenu
    topline = "**************************** DOGFIGHT CONTROL PANEL ****************************\n"
    line1 = "(1) Display Golfers and Quota"
    line2 = "(2) Add A New Golfer to the Database"
    line3 = "(3) Add A Dogfight to the Schedule"
    line4 = "(4) Add a Golfer to This Week's Dogfight"
    line5 = "(5) Delete a Golfer from this Weeks Dogfight"
    line6 = "(6) Display the dogfight"
    line7 = "(7) Add Current Results for Group"
    line8 = "(8) Install Initial Database"
    line9 = "(9) Exit the dogfight\n"


    @fullMenu.push(topline)
    @fullMenu.push(line1)
    @fullMenu.push(line2)
    @fullMenu.push(line3)
    @fullMenu.push(line4)
    @fullMenu.push(line5)
    @fullMenu.push(line6)
    @fullMenu.push(line7)
    @fullMenu.push(line8)
    @fullMenu.push(line9)

    return @fullMenu.join("\n")
  end




  def printMenu
    # let's design a menu
    continue = true
    theMenu = fullMenu

    while continue
      puts theMenu
      puts"\nWhat can I do for you? Enter the Number of your choice"
      action = gets.chomp.to_i
      puts "\n\n"

      case action
        when 1
          printGolferList
          puts "Press Any Key To Continue"
          gets()
        when 2
          addGolfer

          #since we added a golfer, we need to update the list
          reloadGolfers
        when 3
          addDogfight
        when 4
          printGolferList
          addGolferToThisWeeksLineup
        when 5
          deleteFromThisWeeksLineup
        when 6
          prizeMoney displayCurrentDogfightList

          puts "Press Any Key To Continue"
          gets
        when 7
          scoreInput
        when 8
          installDB
        when 9
          continue = false
        else
          puts ("Please enter a number between 1 and #{@fullMenu.count - 1}\n\n") # -1 for the topline

      end
    end
  end


  private

    #TODO TEST THIS METHOD THIS WEEKEND AFTER SCORES ARE GAINED!
    def scoreInput

      results = @sqler.retrieve "SELECT A.ID, GOLFER.LAST_NAME, GOLFER.FIRST_NAME, GOLFER.CURRENT_QUOTA FROM CURRENT_GOLFER_LINEUP A LEFT JOIN GOLFER ON A.ID = GOLFER.ID" #retrieve the results from the db

      #we'll iterate through the results and try to stay in the loop.
      results.each_hash do |row|


        puts "Enter #{row["LAST_NAME"]}, #{row["FIRST_NAME"]}\'s result for this week\'s Dogfight.\n-Please enter 0 to skip this Golfer. After Score is entered, this Golfer WILL BE REMOVED from this week's dogfight.\n-If an adjustment is needed to the score, SQL will be needed on the GOLFER_SCORE table"
        quota = gets.chomp.to_i

        if quota > 0
          insertSQL = "INSERT INTO GOLFER_SCORE (ID, SCORE) VALUES (#{row["ID"]}, #{quota});"
          deleteSQL = "DELETE FROM CURRENT_GOLFER_LINEUP WHERE ID = #{row["ID"]};"

          puts "#{insertSQL}\n#{deleteSQL}\n\n"
        else
          puts "Skipped"
        end
      end

    end

    def prizeMoney(numOfGolfers=0)

      prizeMoneyHash = {}
      prizeMoneyHash[6] = {1 => 50, 2 => 30}
      prizeMoneyHash[7] = {1 => 50, 2 => 30, 3 => 15}
      prizeMoneyHash[8] = {1 => 55, 2 => 35, 3 => 20}
      prizeMoneyHash[9] = {1 => 60, 2 => 40, 3 => 25}
      prizeMoneyHash[10] = {1 => 60, 2 => 40, 3 => 25, 4 => 15}
      prizeMoneyHash[11] = {1 => 60, 2 => 45, 3 => 30, 4 => 20}
      prizeMoneyHash[12] = {1 => 65, 2 => 45, 3 => 35, 4 => 25}
      prizeMoneyHash[13] = {1 => 65, 2 => 45, 3 => 35, 4 => 25, 5 => 15}
      prizeMoneyHash[14] = {1 => 70, 2 => 50, 3 => 35, 4 => 25, 5 => 20}
      prizeMoneyHash[15] = {1 => 70, 2 => 55, 3 => 40, 4 => 30, 5 => 20}
      prizeMoneyHash[16] = {1 => 75, 2 => 55, 3 => 45, 4 => 35, 5 => 20}
      prizeMoneyHash[17] = {1 => 80, 2 => 60, 3 => 50, 4 => 35, 5 => 20}
      prizeMoneyHash[18] = {1 => 80, 2 => 60, 3 => 55, 4 => 40, 5 => 25}
      prizeMoneyHash[19] = {1 => 80, 2 => 60, 3 => 55, 4 => 40, 5 => 25, 6 => 15}
      prizeMoneyHash[20] = {1 => 85, 2 => 65, 3 => 55, 4 => 40, 5 => 25, 6 => 20}
      prizeMoneyHash[21] = {1 => 90, 2 => 70, 3 => 55, 4 => 40, 5 => 30, 6 => 20}
      prizeMoneyHash[22] = {1 => 90, 2 => 70, 3 => 55, 4 => 40, 5 => 30, 6 => 20, 7 => 15}
      prizeMoneyHash[23] = {1 => 95, 2 => 75, 3 => 60, 4 => 40, 5 => 30, 6 => 20, 7 => 15}
      prizeMoneyHash[24] = {1 => 95, 2 => 75, 3 => 60, 4 => 40, 5 => 30, 6 => 20, 7 => 20, 8 => 10}


      puts "\nNumber of Golfers: #{numOfGolfers}\n\n"

      if numOfGolfers < 6 || numOfGolfers > 24
        puts "Invalid Number of Golfers. Dogfight is setup for between 6 - 24 golfers"
      else

        sum = 0 # So we can sum the total pot
        thisDogFight = prizeMoneyHash[numOfGolfers] # get the correct prize money hash

        puts "PAYOUTS: "
        thisDogFight.each do |key, value|
          sum += value
          puts "#{key}#{ordinal(key)} place: $#{value}"
        end

        puts "Stableford Pot: $#{sum}\n\n"


      end

    end

    def ordinal(number)
      abs_number = number.to_i.abs

      if (11..13).include?(abs_number % 100)
        "th"
      else
        case abs_number % 10
          when 1; "st"
          when 2; "nd"
          when 3; "rd"
          else    "th"
        end
      end
    end

    def displayCurrentDogfightList

      rows = [] #for the table
      results = @sqler.retrieve "SELECT A.ID, GOLFER.LAST_NAME, GOLFER.FIRST_NAME, GOLFER.CURRENT_QUOTA FROM CURRENT_GOLFER_LINEUP A LEFT JOIN GOLFER ON A.ID = GOLFER.ID ORDER BY GOLFER.LAST_NAME;"
      results.each do |row|

        rows << row #add the row to the table master array. It takes an array of arrays
      end

      dogfightDateHash = getCurrentDogfightDate #This should be a Hash of the Dogfight
      courseHash = getCourseByID(dogfightDateHash["COURSE"])

      puts "The Current Dogfight is Scheduled for #{dogfightDateHash['DATE']} on #{courseHash['NAME']}\nIf this is incorrect, please add the new dogfight to the list\n\n"

      puts "#{Terminal::Table.new :title => "Dogfight for #{dogfightDateHash['DATE']} on #{courseHash['NAME']}", :headings => ['ID', 'LAST NAME', 'FIRST NAME', 'QUOTA'], :rows => rows}\n"

      #return the count, we dont have to use it, but it is needed for the prize money
      return rows.count
    end


    def deleteFromThisWeeksLineup

      displayCurrentDogfightList
      puts 'Enter an ID To Delete'
      deleteID = gets.chomp.to_i

      puts 'Are Your Sure? (y/n)'
      answer = gets.chomp

      if answer.downcase == 'y'
        @sqler.insert("DELETE FROM CURRENT_GOLFER_LINEUP WHERE ID = #{deleteID};")
      else
          puts "Canceling"
      end

    end

    def getDate
      puts "Enter a Date (YYYY-MM-DD)"


      date = gets.chomp
      date = Date.parse date

      return date

    end

    def addDogfight



      courseHash = {}
      rows = [] # for the terminal-table
      sql = "SELECT * FROM COURSE;"
      results = @sqler.retrieve(sql)

      results.each_hash do |row|
        rows << [row["ID"], row["NAME"]]
        courseHash[row["ID"].to_i] = row["NAME"]
      end

      puts "#{Terminal::Table.new :headings => ['ID', 'COURSE'], :rows => rows}\n"

      puts "Enter a course ID"
      course = gets.chomp.to_i

      if (1..3).include? course
        puts "You Selected Course #{courseHash[course]}\n"

        addDogfightQuery = "INSERT INTO DOGFIGHT_DATE (COURSE, DATE) VALUES (#{course}, '#{getDate}');"

        @sqler.insert addDogfightQuery

        puts "Dogfight Added"
      else

        puts "Invalid Selection"
      end

    end

    def getCurrentDogfightDate

      #General Get of the latest dogfight row, return the hash, which there will be only one
      dogfightSql = "SELECT MAX(ID), COURSE, DATE FROM DOGFIGHT_DATE GROUP BY ID"

      result = @sqler.retrieve(dogfightSql)

      result.each_hash do |row| # returning a hash
        return row
      end
    end

    def getCourseByID(id)
      courseSQL = "SELECT ID, NAME FROM COURSE WHERE ID = #{id.to_i};"
      result = @sqler.retrieve courseSQL

      result.each_hash do |row|
        return row
      end

    end



    def addGolferToThisWeeksLineup

      dogfightDateHash = getCurrentDogfightDate #This should be a Hash of the Dogfight
      courseHash = getCourseByID(dogfightDateHash["COURSE"])

      displayCurrentDogfightList

      puts "Add a golfer (By ID) to this week's lineup"
      puts "Enter '-1' to cancel\n\n"

      golferID = gets.chomp.to_i

      if @golfers.any? {|golfer| golfer.databaseID == golferID}

        @sqler.insert("INSERT INTO CURRENT_GOLFER_LINEUP VALUES (#{golferID}, #{courseHash['ID']}, '#{dogfightDateHash['DATE']}');")
        puts "Added"

        puts "Add another? (y/n)"
        answer = gets.chomp.downcase

        if answer == 'y'
          addGolferToThisWeeksLineup # Yay, recursive call!!
        end

      else
        puts "Invalid Selection"
      end
    end

    def printGolferList

      rows = []

      @golfers.each do |golfer|
        rows << [golfer.databaseID, golfer.name, golfer.currentQuota]
      end

      puts Terminal::Table.new :headings => ['ID', 'Golfer', 'Quota'], :rows => rows
      puts
    end

    def addGolferToLineup

    end

    def installDB
      puts "Setting up database"
      initDB = InstallDatabase.new
      initDB.install

    end


    def addGolfer

      $stdout.sync = true

      puts "Add a Golfer"
      puts "\nEnter 'exit' to cancel\n\n"

      print "First Name: "
      firstname = gets().chomp

      if firstname.downcase == "exit"
        return false
      end

      print "Last Name: "
      lastname = gets.chomp

      if lastname.downcase == "exit"
        return false
      end

      continue = true
      handicap = 0
      while continue
        print "Handicap (For plus Handicaps, use the minus symbol (-)....just makes it easier to code for): "
        handicap = gets.chomp.to_i

          if handicap.between?(-9, 36)
            continue = false
          else
            puts "invalid Handicap"
          end
        end


      # Now we've recieved the input, and error checked it.
      # Lets build the golfer

      newGolfer = Golfer.new(firstname, lastname, 0) # We leave the database ID 0 because the sql needs to assign it
      newGolfer.handicap = handicap # Need to manuall set the handicap
      newGolfer.buildQuota # we need to build the quota for a new golfer
      SQLNewGolfer(newGolfer)



    end

    def SQLNewGolfer(golfer)

      databaseID = 0

      sql= "INSERT INTO GOLFER (FIRST_NAME, LAST_NAME, CURRENT_QUOTA) VALUES ('#{golfer.firstname}', '#{golfer.lastname}', #{golfer.getCurrentQuota});"

      @sqler
      @sqler.insert(sql)

      # We need the DB ID for the golfer, so let's retrieve that
      request = @sqler.retrieve"SELECT ID FROM GOLFER WHERE LAST_NAME = '#{golfer.lastname}' AND FIRST_NAME = '#{golfer.firstname}'"

      # We need to get the newly created databaseID so we can update the previous results table
      request.each_hash do |row|
        databaseID = row["ID"]
      end

      print "["
      10.times do
        @sqler.insert"INSERT INTO GOLFER_SCORE (ID, SCORE) VALUES (#{databaseID}, #{golfer.getCurrentQuota});"
        sleep 1
        print "="
      end
      puts "]\n"


    end


  private
    def reloadGolfers
      @sqler = SQLGenerator.new
      @golfers = @sqler.golfers
    end


end
