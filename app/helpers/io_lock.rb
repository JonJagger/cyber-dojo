
def io_lock(path)
	File.open(path, 'r') do |fd|
		success = fd.flock(File::LOCK_EX)
		if success
			begin
				yield fd
			ensure
				fd.flock(File::LOCK_UN)				
			end
		end	
		return success
	end
end

