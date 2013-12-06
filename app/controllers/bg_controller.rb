class BgController < ApplicationController
  
  def index
    
    #if we're already runing an update, note it and exit
    #(or dh killed the process...)
    @lastRecord = MonitorRecord.find :first, :conditions => { :completed=>false }
    if(@lastRecord)
      @lastRecord.overruns = (@lastRecord.overruns) ? @lastRecord.overruns.next : 1
      @lastRecord.save
      if(@lastRecord.overruns <5)
        render :inline => "Update already in progress! (#{@lastRecord.overruns} overrun#{@lastRecord.overruns>1? 's':''}.) Exiting."
      else 
        @lastRecord.completed = true
        @lastRecord.save
        render :inline => "#{@lastRecord.overruns} overruns reached. Marking the record as complete and restarting rails."
        FileUtils.touch '/home/nfriedly/twittermentionmonitor.com/tmp/restart.txt'
      end
      return
    end
      
    @record = MonitorRecord.new
    @record.completed = false #check if this is necessary
    @record.save
    
    start = Time.now
  
    #clean up the database every night at 3 am
    # deletes "good" records, leaves anything that had an overrun or is currently in progress
    if(start.hour == 3 && start.min == 0)
      MonitorRecord.delete_all({:complete => true, :overruns => 0})
    end
    
    mm = twitter_mm # defined in application_controller.rb using keys from enviroment config
    
    debug "our client: " + mm.inspect
    
    users = User.find :all
    
    debug "users: " + users.inspect
    
    debug ""
    
    sent = 0
    
    users.each {|user|
      debug "checking mentions for user #{user.username} (#{user.id}) who's last mention id was #{user.last_mention_id}"
      
      user.mentions.each { |mention|
        
        debug " - found mention id: #{mention['id']} from #{mention['user']['screen_name']}, forwarding"
        
        #user.follow(MM_USERNAME) # nevermind that. if a user breaks our service then it'll stay broken until theye fix it
        
        # this could condievably break the 140 character limit..  twitter will handle that for us.
        mm.message(user.username, '@' + mention['user']['screen_name'] + ': ' + mention['text'])
        sent = sent.next
        
        # reguardless of the list order, this will make sure we have the highest id
        if(user.last_mention_id < mention['id'])
          debug " - updating user's last mention id from #{user.last_mention_id} to #{mention[id]}"
          user.last_mention_id = mention['id']
          user.save
        end
      }
      debug ""
    }
    #todo: monitor elapsed time and do something if it's breaking 30 seconds
    elapsed = Time.now - start
    debug "total time: " + elapsed.to_s + " seconds."
    @record.runtime = elapsed
    @record.tweets_sent = sent
    @record.completed = true
    @record.save
    render :inline => @output
  end
  
  def debug (msg="")
    @output = (@output) ? @output : "<pre>Updating Mentions\n\n"
    @output = @output + msg + "\n"
  end
    
end
