# ListFilesWithContent.ps1
$projectPath = "D:\Projects\Portfolio"
$outputFile = "D:\Projects\Portfolio\Utils\ProjectFilesContent.txt"

# Clear the output file if it exists
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# Add the COPILOTWORKSPACE CONTEXT at the beginning of the file
$workspaceContext = @"
# COPILOTWORKSPACE CONTEXT
The current workspace includes the following specific characteristics:
- Projects targeting: '.NET 9'
- The current workspace contains a Blazor project. Prioritize answers matching Blazor over Razor Pages or ASP.NET Core MVC
Consider these characteristics when generating or modifying code, but only if they are directly relevant to the task.

"@
Add-Content -Path $outputFile -Value $workspaceContext

# Initialize a variable to hold the content for the clipboard
$clipboardContent = $workspaceContext

# Get all tracked and untracked files in the project directory, excluding ignored files
$files = git -C $projectPath ls-files --others --exclude-standard --cached

foreach ($file in $files) {
    Write-Output "Processing file: $file"
    $fileContext = "# FILE CONTEXT`nFile: $file`n"
    Add-Content -Path $outputFile -Value $fileContext
    $clipboardContent += $fileContext

    # Add the content of the file
    $fileContent = Get-Content -Path "$projectPath\$file" -Raw
    Add-Content -Path $outputFile -Value $fileContent
    $clipboardContent += $fileContent
}

# Copy the content to the clipboard
$clipboardContent | Set-Clipboard

Write-Output "File list and content have been written to $outputFile and copied to clipboard"


