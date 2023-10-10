#!/usr/bin/osascript

on run argv
  if (count of argv) < 2 then
    return "Not enough input parameters (pwd, directory)."
  end if

	set workdir to quoted form of (item 2 of argv)
	set homedir to quoted form of (get POSIX path of (path to home folder as text))
	
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
			do shell script "cd " & workdir & "&& /Applications/neovide.app/Contents/MacOS/neovide --neovim-bin " & homedir & "nvim-macos/bin/nvim -- --cmd \"lua vim.opt.titlestring=" & workdir & "\""
		end if
	end tell
end run
