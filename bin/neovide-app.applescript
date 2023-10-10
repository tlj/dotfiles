set workdir to "src/svap"

set running_pid to 0
tell application "System Events"
	set pids to get unix id of every application process whose visible is true and name is "neovide"
	repeat with pid in pids
		set is_running to (do shell script "ps -p " & pid & " | grep '" & workdir & "' || echo 'not_found'")
		if is_running = "not_found" then
		else
			set running_pid to pid
		end if
	end repeat
end tell

tell application "System Events"
	if running_pid > 0 then
		set frontmost of every process whose unix id is running_pid to true
	else
		do shell script "/Applications/neovide.app/Contents/MacOS/neovide --neovim-bin /Users/tjohnsen/nvim-macos/bin/nvim /Users/tjohnsen/" & workdir
	end if
end tell
