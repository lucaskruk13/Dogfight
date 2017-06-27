require 'mysql'

class InstallDatabase

  def install

    checkArray = []

    golferSQL = "CREATE TABLE IF NOT EXISTS GOLFER (ID INT AUTO_INCREMENT PRIMARY KEY, FIRST_NAME VARCHAR(40), LASTNAME VARCHAR(40), CURRENT_QUOTA INT, EMAIL VARCHAR(60));"
    golferScoreSql = "CREATE TABLE IF NOT EXISTS GOLFER_SCORE (ID INT, SCORE INT, CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (ID) REFERENCES GOLFER(ID));"

    checkArray.push golferSQL
    checkArray.push golferScoreSql

    checkArray.each do |sql|
      query sql
    end


  end


  def query(sql)
    begin
      @con = Mysql.new('localhost', 'dogfight', 'Copperbu$13', 'DOGFIGHT')

      request = @con.query(sql)


    rescue Mysql::Error => e
      puts e.errno
      puts e.error

    ensure
      @con.close if @con
    end

  end
end
