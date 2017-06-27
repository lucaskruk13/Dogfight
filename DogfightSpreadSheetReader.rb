require 'roo'
require './Golfer'

class DogfightSpreadSheetReader

  attr_reader :currentQuota


  def initialize(filePath)
    @filePath = filePath

    @xlsx = Roo::Spreadsheet.open(filePath)
    @currentQuota = @xlsx.sheet('Current Quota')
    @previousResults = @xlsx.sheet('Quota Calc')
    @golfers = []

  end

  def info
   @xlsx.info
  end

  def getGolfersAndQuota

    #starting at 4 becuase pete has a gap there
    (2..@currentQuota.last_row).each do | index |

      fullname = @currentQuota.cell('A', index).split(' ')


      thisGolfer = Golfer.new(fullname.first, fullname.last, @currentQuota.cell('B', index))

      @golfers.push(thisGolfer)
    end

    return @golfers
  end




  def getPreviousResultsInfo
    return @previousResults
  end

end
