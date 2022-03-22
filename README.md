# Get-FileOwner
Examines the ACL of a file and returns the Owner of that file.  Gives the option of either outputting the results to a file asyncronously or outputting the results syncronously to the screen.

This was written due to a need that a business unit had to evaluate the owner of every file on their fileshare, which contained over nine million files.  Knowing that running ```Get-ChildItem -Path <\\file\share> -Recurse``` at the root of this fileshare would cause powershell to eventually consume all the memory on the system and ultimately not return any results, I decided that the only way out of this would be to write the results of my ownership query to a file immediately after the information I required was returned.  As a result, this script was born.

While this script has a pretty narrow scope, the potential it has to be manipulated to accommodate other needs is very high.  Please feel free to use this as a framework for any other fileshare needs you have!

Also, please feel to contribute to the existing script!

## License

MIT
