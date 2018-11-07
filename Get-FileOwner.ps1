Function Get-FileOwner {
    <#
    .SYNOPSIS
        Examines the ACL of a file and returns the Owner of that file
    .DESCRIPTION
        Examines the ACL of a file and returns the Owner of that file.  Gives the option of either outputting the results to a file asyncronously or outputting the results syncronously to the screen.
    .EXAMPLE
        PS C:\> Get-FileOwner -Path 'C:\temp\'
        
        Returns the file owners for the path "c:\temp\"
    .EXAMPLE
        PS C:\> Get-FileOwner -Path 'C:\temp\' -Recurse

        Recursively returns the file owners for the path "c:\temp\"
    .EXAMPLE
        PS C:\> Get-FileOwner -Path 'C:\temp\' -WriteToFileAsync -OutFilePath 'c:\temp\balls.txt' -Recurse

        Recursively returns the file owners for the path "c:\temp\" and outputs the results to a file asyncronously.
    .PARAMETER Path
        Folder path to search for owners.  Must be a folder, not a file.
    .PARAMETER WriteToFileAsync
        Switch to determine if the caller should output the results to a file instead of the screen.
    .PARAMETER OutFilePath
        File path to output the results.
    .PARAMETER Recurse
        Specifies whether or not to query ownership info recursively
    .Notes
        Cmdlet version: 1.0
        Written by @charltonstanley
    #>
    [CmdletBinding(DefaultParameterSetName='WriteToScreen')]
    param (
        $Path
        ,
        [switch]$Recurse
        ,
        [Parameter(ParameterSetName='WriteToFile')]
        [switch]$WriteToFileAsync
        ,
        [Parameter(ParameterSetName='WriteToFile')]
        $OutFilePath
    )
    $Files = Get-ChildItem $path -File
    $return =@()
    foreach ($file in $Files){
        $obj = New-Object system.object
        $acl = Get-Acl $File.fullname
        $obj|Add-Member -NotePropertyName Path -NotePropertyValue $File.Fullname
        $obj|Add-Member -NotePropertyName Owner -NotePropertyValue $acl.Owner
        if ($PSCmdlet.ParameterSetName -like 'WriteToFile'){
            $obj|Export-Csv -Path $OutFilePath -NoTypeInformation -Append
        }
        else{
            $return += $obj
        }
    }
    if($Recurse){
        $directories = Get-ChildItem $path -Directory
        if ($PSCmdlet.ParameterSetName -like 'WriteToFile'){
            foreach ($directory in $directories){
                Get-FileOwner -path $directory.fullname -Recurse -WriteToFileAsync -OutFilePath $OutFilePath
            }
        }
        else{
            foreach ($directory in $directories){
                $return += Get-FileOwner -path $directory.fullname -Recurse
            }
        }
    }
    return $return
}