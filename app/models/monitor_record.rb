class MonitorRecord < ActiveRecord::Base

	def self.recent
		find(	:all,
				:order => 'updated_at DESC', 
				:limit => 100
		)
	end
	
end
