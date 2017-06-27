require './Golfer'
require './SQLGenerator'

class Menu

  attr_reader :fullMenu

  def initialize
    @fullMenu = Array.new

    @sqler = SQLGenerator.new
    @golfers = @sqler.golferHash
  end




  def fullMenu
    topline = "**************************** DOGFIGHT CONTROL PANEL ****************************\n"
    line1 = "(1) Display Golfers and Quota"
    line2 = "(2) Add Golfer"
    line3 = "(3) Add Current Results for Group"
    line4 = "(4) Manual Adjustment of individual Quota"
    line5 = "(5) Exit the dogfight\n"


    @fullMenu.push(topline)
    @fullMenu.push(line1)
    @fullMenu.push(line2)
    @fullMenu.push(line3)
    @fullMenu.push(line4)
    @fullMenu.push(line5)


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
          lookUpGolfers
          gets()
        when 2
          addGolfer

          #since we added a golfer, we need to update the list
          reloadGolfers
        when 3
          puts ("Input the results from Saturday's dogfight -- Not Implemented\n\n")
        when 4
          puts ("Manual Adjustment of a quota -- Not Implemented\n\n")
        when 5
          continue = false
        else
          puts ("Please enter a number between 1 and 5\n\n")

      end
    end
  end


  private


    def lookUpGolfers

      @golfers.each do |name, golfer|
        puts "Database ID: #{golfer.databaseID}"
        puts "Name: #{golfer.name}"
        puts "Current Quota: #{golfer.getCurrentQuota}"
        puts "\n"
      end

      puts "Press any Key to continue"
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
      @golfers = @sqler.golferHash
    end


end