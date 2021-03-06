require 'mysql'

class InstallDatabase

  def install

    checkArray = []

    golferSQL = "CREATE TABLE IF NOT EXISTS GOLFER (ID INT AUTO_INCREMENT PRIMARY KEY, FIRST_NAME VARCHAR(40), LASTNAME VARCHAR(40), CURRENT_QUOTA INT, EMAIL VARCHAR(60));"
    golferScoreSql = "CREATE TABLE IF NOT EXISTS GOLFER_SCORE (ID INT, SCORE INT, CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (ID) REFERENCES GOLFER(ID));"
    currentLineupSQL = "CREATE TABLE IF NOT EXISTS CURRENT_GOLFER_LINEUP (ID INT NOT NULL, COURSE INT, DATE DATE NOT NULL, FOREIGN KEY (ID) REFERENCES GOLFER(ID));"
    courseSQL = "CREATE TABLE IF NOT EXISTS COURSE (ID INT PRIMARY KEY AUTO_INCREMENT, NAME VARCHAR(40) NOT NULL);"
    dogfightCourseSQL = "CREATE TABLE IF NOT EXISTS DOGFIGHT_DATE (ID INT PRIMARY KEY AUTO_INCREMENT, COURSE INT NOT NULL, DATE DATE NOT NULL, CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (COURSE) REFERENCES COURSE(ID));"


    checkArray.push golferSQL
    checkArray.push golferScoreSql
    checkArray.push currentLineupSQL
    checkArray.push courseSQL
    checkArray.push dogfightCourseSQL

    checkArray.each do |sql|
      query sql
    end


  end


  def query(sql)
    begin
      @con = Mysql.new('localhost', 'dogfight', '****', 'DOGFIGHT')

      request = @con.query(sql)


    rescue Mysql::Error => e
      puts e.errno
      puts e.error
      puts sql

    ensure
      @con.close if @con
    end

  end
end
