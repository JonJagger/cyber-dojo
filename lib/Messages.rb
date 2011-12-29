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
        
  end
  
end