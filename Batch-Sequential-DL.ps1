<#
.SYNOPSIS
    Batch downloads sequential files from a range of urls
.DESCRIPTION
    Powershell script for batch downloading a sequential range of files.
    ie. https://example.com/0.jpg, https://example.com/1.jpg, etc.
.PARAMETER url
    The url from which the range of urls is generated.
    '{0}' will be replaced with the current number in the range
.PARAMETER start
    The starting number of the range
.PARAMETER end
    The ending number of the range
.PARAMETER outfile
    Template for output filename eg. "{0}.jpg"
    '{0}' will be replaced with the current number in the range
.EXAMPLE
    C:\PS> Batch-Sequential-DL "https://example.com/{0}.jpg" 0 5 "{0}.jpg"
    downloads https://example.com/0.jpg, https://example.com/1.jpg, etc.
.NOTES
    Author: Edward
    Date:   March 20, 2020
#>

workflow Batch-Sequential-DL {
    param(
        [Parameter(Mandatory)]
        [string]$url,
        [Parameter(Mandatory)]
        [int32]$start,
        [Parameter(Mandatory)]
        [int32]$end,
        [Parameter(Mandatory)]
        [string]$outfile
    );
    
    ForEach -Parallel ($i in $start..$end) {
        $dlurl = $url -f $i
        $output = $outfile -f $i
        wget "$dlurl" -OutFile $output
    }
}