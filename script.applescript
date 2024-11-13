# Things To dos Exporter - for exporting Things projects to any folder as single Markdown files with all relevant metadata.

tell application "Things3"
	try
		-- Get project name from user
		set projectName to text returned of (display dialog "Enter project name to export:" default answer "")
		
		-- Find the project
		set targetProject to project projectName
		
		-- Setup output file
		set outputFile to choose file name with prompt "Save markdown export as:" default name (projectName & ".md")
		set fileRef to open for access outputFile with write permission
		
		-- Write markdown header
		set mdHeader to "# " & projectName & " Tasks" & return & return
		write mdHeader to fileRef
		
		-- Get todos from specific project
		set projectTodos to to dos of targetProject
		
		-- Process todos
		repeat with currentTodo in projectTodos
			-- Basic todo info
			set todoName to name of currentTodo
			set todoNotes to notes of currentTodo
			set todoCreated to creation date of currentTodo
			set todoModified to modification date of currentTodo
			set todoDue to due date of currentTodo
			set todoStatus to status of currentTodo
			set todoTags to tag names of currentTodo
			
			-- Format todo as markdown
			set todoMD to "## " & todoName & return
			set todoMD to todoMD & "**Status:** " & todoStatus & return
			if todoDue is not missing value then
				set todoMD to todoMD & "**Due:** " & todoDue & return
			end if
			set todoMD to todoMD & "**Created:** " & todoCreated & return
			set todoMD to todoMD & "**Modified:** " & todoModified & return
			
			if length of todoTags is greater than 0 then
				set todoMD to todoMD & "**Tags:** " & my joinList(todoTags, ", ") & return
			end if
			
			if length of todoNotes is greater than 0 then
				set todoMD to todoMD & return & todoNotes & return
			end if
			
			set todoMD to todoMD & return & "---" & return & return
			
			-- Write to file
			write todoMD to fileRef
		end repeat
		
		-- Cleanup
		close access fileRef
		
		display dialog "Export complete!" buttons {"OK"} default button "OK"
		
	on error errMsg
		display dialog "Error: " & errMsg buttons {"OK"} default button "OK"
		try
			close access fileRef
		end try
	end try
end tell

-- Helper function to join list items with separator
on joinList(theList, theDelimiter)
	set oldDelimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to theDelimiter
	set theString to theList as string
	set AppleScript's text item delimiters to oldDelimiters
	return theString
end joinList