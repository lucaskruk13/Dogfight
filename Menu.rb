require './Golfer'
require './SQLGenerator'
require './InstallDatabase'
require 'terminal-table'
require 'date'

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
    line4 = "(4) Add a Golfer to This Week's Dog Fight"
    line5 = "(5) Add Current Results for Group"
    line6 = "(6) Manual Adjustment of individual Quota"
    line7 = "(7) Install Initial Database"
    line8 = "(8) Exit the dogfight\n"


    @fullMenu.push(topline)
    @fullMenu.push(line1)
    @fullMenu.push(line2)
    @fullMenu.push(line3)
    @fullMenu.push(line4)
    @fullMenu.push(line5)
    @fullMenu.push(line6)
    @fullMenu.push(line7)
    @fullMenu.push(line8)


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
          puts ("Input the results from Saturday's dogfight -- Not Implemented\n\n")
        when 6
          puts ("Manual Adjustment of a quota -- Not Implemented\n\n")
        when 7
          installDB
        when 8
          continue = false
        else
          puts ("Please enter a number between 1 and #{@fullMenu.count - 1}\n\n") # -1 for the topline

      end
    end
  end


  private

    def getDate
      puts "Enter a Date (YYYY/MM/DD)"

      #TODO impement the date formatter. Currently throwing an error
      date = gets.chomp.strftime("%d/%m/%Y")

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
        puts "You Selected Course #{courseHash[course]}"

        #TODO implment the get date properly
        puts getDate
      else

        puts "Invalid Selection"
      end


      # rows = []
      #
      # @golfers.each do |golfer|
      #   rows << [golfer.databaseID, golfer.name, golfer.currentQuota]
      # end
      #
      # puts Terminal::Table.new :headings => ['ID', 'Golfer', 'Quota'], :rows => rows
      # puts


    end

#TODO: Finish Implementing
#TODO add exit command
    def addGolferToThisWeeksLineup

      puts "Add a golfer (By ID) to this week's lineup"
      puts "Enter 'exit' to cancel\n\n"

      ###### Need to implement DOGIFHT_COURSE creation menu element
      ###### Need to choose which dogfight we are adding to

      dogfightDate= gets.chomp

      golferID = gets.chomp.to_i

      thisGolfer = @golfers.find {|g| g.databaseID == golferID}

      sqler.insert("INSERT INTO CURRENT_GOLFER_LINEUP (ID")
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


    # Need to Implement Next

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
