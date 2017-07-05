require './Golfer'
require 'mysql'

class SQLGenerator


  attr_reader :golfers

  def initialize(arrayOfGolfers=[])
    @golfers = arrayOfGolfers
    retrieveGolfersFromDatabase #does exactly what it says


    #sort the array by last name
    #@golferHash = golferHash.sort_by {|key, golfer| golfer.lastname}


    #setup the connection
    #my = Mysql.new(hostname, username, password, databasename)

  end




  def getGolfersPreviousResults(golfer)

    queryString = "SELECT * FROM GOLFER_SCORE WHERE ID=#{golfer.databaseID} ORDER BY CREATED_AT DESC;"
    previousScore = retrieve(queryString)

    scores = []

    previousScore.each_hash do |row|
      scores.push(row["SCORE"])
    end

    return scores

  end



      def retrieve(sql)
        begin
          @con = Mysql.new('localhost', 'dogfight', 'Copperbu$13', 'DOGFIGHT')

          request = @con.query(sql)

        rescue Mysql::Error => e
          puts e.errno
          puts e.error

        ensure
          @con.close if @con
        end

        return request

      end

      def insert(sql)
        begin
          @con = Mysql.new('localhost', 'dogfight', '****', 'DOGFIGHT')

          @con.query(sql)



        rescue Mysql::Error => e
          puts e.errno
          puts e.error

        ensure
          @con.close if @con
        end

      end


  private

    def retrieveGolfersFromDatabase

      begin
        @con = Mysql.new('localhost', 'dogfight', '****', 'DOGFIGHT')

        request = @con.query("SELECT * FROM GOLFER ORDER BY LAST_NAME")

        request.each_hash do |row|
          thisGolfer = Golfer.new(row["FIRST_NAME"], row["LAST_NAME"], row["CURRENT_QUOTA"], row["ID"].to_i)

          @golfers.push thisGolfer
        end

      rescue Mysql::Error => e
        puts e.errno
        puts e.error

      ensure
        @con.close if @con
      end

      @golfers.each do |golfer|

        golfer.previousResults = getGolfersPreviousResults(golfer)
      end


  end


  # def insertScore(golfer)
  #
  #   scores = golfer.previousResults
  #   scores.shift #here we need to remove the first row, because it's the name
  #
  #
  #   scores.each do |score|
  #     sql = "INSERT INTO GOLFER_SCORE (ID, SCORE) VALUES (#{golfer.databaseID}, #{score});"
  #
  #     insert(sql)
  #     sleep 1
  #   end
  #
  # end


  # def insertInitialValues -- should not use anymore
  #   @con = Mysql.new('localhost', 'dogfight', '****')
  #   @golfers.each do |golfer|
  #
  #     queryString = "INSERT INTO GOLFER (FIRST_NAME, LAST_NAME, CURRENT_QUOTA) VALUES (\'#{golfer.firstname}\', \'#{golfer.lastname}\', \'#{golfer.currentQuota}\');"
  #
  #     @con.query(queryString)
  #
  #   end
  #
  #   @con.close
  # end

end
