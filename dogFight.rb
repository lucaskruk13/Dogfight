require './Golfer'
require './DogfightSpreadSheetReader'
require './SQLGenerator'
require './Menu'
require './InstallDatabase'

#Were setting up the initial database. Will reuse, do not remove
spreadSheet = DogfightSpreadSheetReader.new('./DogFight.xlsx')

sqler = SQLGenerator.new()

menu = Menu.new
puts menu.printMenu





############### No Longer Needed ####################

# golferHash.each do |key, golfer|
#   #puts "#{golfer.name} -> #{golfer.previousResults.join("\s")}\ncount = #{golfer.previousResults.size}\n\n"
#   puts "#{golfer.name} -> #{golfer.getCurrentQuota}"
# end
#

# #need To create Brodi Because Pete's spreadsheet doesnt account for it
# brodi = Golfer.new("Brodi", "LaFleur", 25)
# @golfers.push(brodi)

#for some reason there is a guest - Not used anymore

# # Setup the golfer's previous results
# @previousResults.each do |result|
#
#   #Get the name of the previous result for lookup
#   playerNameArray = result.first.split(" ")
#   playerNameArray.delete(0)
#
#   # check for dummy names (guest/player)
#   if playerNameArray.length >1
#     #get the first and last name
#     firstName = playerNameArray.first
#     lastName = playerNameArray.last
#
#     #look up the current golfer for this result
#     thisGolfer = golferHash[playerNameArray.join(" ")]
#
#     #set the results for the current golfer
#     thisGolfer.previousResults = result
#   end
#
# end


# ONE TIME USE - Put the Golfer's previous scores in the DB - Complete

# golferHash.each do |key, value|
#   sqler.insertScore(golferHash[key])
# end


# @golfers.each do |golfer|
#   puts golfer.firstname
#   puts golfer.lastname + "\n\n"
# end


#sqler = SQLGenerator.new(@golfers)
#sqler.insertInitialValues -- no need to redo this

# @previousResults.each do |result|
#
#   # Get the name of the previous result for lookup
#   playerNameArray = result.first.split(" ")
#   playerNameArray.delete(0)
#
#   #check for dummy names (guest/player)
#   if playerNameArray.length > 1
#
#     #get the first and last name
#     firstName = playerNameArray.first
#     lastName = playerNameArray.last
#
#     #look up the current golfer for this result
#     thisGolfer = @golfers.find {|golfer| golfer.firstname == firstName && golfer.lastname == lastName}
#
#     #set the results for the current golfer
#     thisGolfer.previousResults = result
#
#     #puts "This Golfer (Last Name: #{lastName}) should find: = #{thisGolfer.firstname} #{thisGolfer.lastname} | Quota: #{thisGolfer.currentQuota}"
#   end
#
# end


# #test the current quotas
# @golfers.each do |golfer|
#   puts "#{golfer.fullname} | #{golfer.getCurrentQuota}"
# end

#lets get the hash of golfers from the db
