module Messages
  
  class MessageAutoPoster

    def initialize(avatar)
      @avatar = avatar
    end
    
    def post_run_test_messages()
      all_incs = Increment.all(@avatar.increments)
      dojo.post_message(name, "#{name} just passed their first test") if just_passed_first_test?(all_incs)
      dojo.post_message(name, "looks like #{name} is on a hot refactoring streak!") if refactoring_streak?(all_incs)      
    end
    
    def post_heartbeat_messages()
      all_incs = Increment.all(@avatar.increments)
      if reluctant_to_run_tests?(all_incs, dojo.messages)
        dojo.post_message(name, "looks like #{name} is reluctant to run tests", :test_reluctance)
      else
      end
    end

    #----------------------------------------
    
    def dojo
      @avatar.dojo
    end
    
    def name
      @avatar.name
    end
    
    def just_passed_first_test?(increments)
      increments.count { |inc| inc.passed? } == 1 and increments.last.passed?
    end
    
    def refactoring_streak?(increments)
      streak_count = 0
      reversed = increments.reverse
      while streak_count < reversed.length && reversed[streak_count].passed?
        streak_count += 1
      end
      streak_count != 0 && streak_count % 5 == 0
    end
    
    def reluctant_to_run_tests?(increments, messages)
      relevant_messages = messages.select do |message|
        message[:type] == :test_reluctance && 
          message[:sender] == name &&
            DateTime.new(*message[:created]) > 10.minutes.ago
      end
      return false unless relevant_messages.empty?
      !increments.empty? and increments.last.old?
    end
    
  end
  
end