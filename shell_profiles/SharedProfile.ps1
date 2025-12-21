oh-my-posh init pwsh | Invoke-Expression

Set-PSReadLineOption -EditMode Vi

# Complex aliases as functions

function show
{
    param(
        [parameter(Position = 0)]
        [string] $Path
    )

    Get-Content "$Path"
}

function dds
{
    [CmdletBinding()]
    param(
        [parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string] $File1,
        [parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrWhiteSpace()]
        [string] $File2
    )

    if (-not (Test-Path -LiteralPath $File1 -PathType Leaf))
    {
        throw "File '$File1' couldn't be found. Either it does not exist, access is denied or it's not a file"
    }

    if (-not (Test-Path -LiteralPath $File2 -PathType Leaf))
    {
        throw "File '$File2' couldn't be found. Either it does not exist, access is denied or it's not a file"
    }

    delta --side-by-side "$File1" "$File2"
}

function env
{
    Get-ChildItem ENV:
}

function dirf
{
    Get-ChildItem -Directory -Recurse | Select-Object -ExpandProperty FullName | fzf `
        --preview='eza -1 "{}"' `
        --border `
        --prompt="Select directory: "
}

function cdf
{
    Set-Location "$(Get-ChildItem -Directory -Recurse | Select-Object -ExpandProperty FullName | fzf --preview='eza -1 "{}"' --border --prompt="Select directory: ")"
}

function nvimf
{
    nvim "$(fzf)"
}

function execf
{
    Write-Output "-File `".\$(fzf)`""
    #Start-Process -FilePath "pswh" -ArgumentList "-File `".\$(fzf)`""
}

# Aliases

New-Alias -Name f -Value fzf -Force
New-Alias -Name new -Value New-Item

# Fuzzy Finder

$env:FZF_DEFAULT_OPTS = @'
--bind=ctrl-j:down,ctrl-k:up,ctrl-u:half-page-up,ctrl-d:half-page-down
--border --padding 1,2
--border-label ' Fuzzy Finder ' --input-label ' Input ' --header-label ' File Type '
--preview 'bat --style=numbers --color=always --line-range :100 {}'
--bind 'ctrl-r:change-list-label( Reloading the list )+reload(timeout /t 5 >nul & git ls-files)'
--color 'border:#aaaaaa,label:#cccccc'
--color 'preview-border:#9999cc,preview-label:#ccccff'
--color 'list-border:#669966,list-label:#99cc99'
--color 'input-border:#996666,input-label:#ffcccc'
--color 'header-border:#6699cc,header-label:#99ccff'
--prompt="Select file: "
'@

#$env:FZF_DEFAULT_OPTS = @'
#--bind=ctrl-j:down,ctrl-k:up,ctrl-u:half-page-up,ctrl-d:half-page-down
#--border --padding 1,2
#--border-label ' Demo ' --input-label ' Input ' --header-label ' File Type '
#--preview 'bat --style=numbers --color=always --line-range :100 {}'
#--bind 'result:transform-list-label:cmd -C "IF NOT DEFINED $FZF_QUERY ( echo  $FZF_MATCH_COUNT matches for [$FZF_QUERY] ) ELSE ( echo $FZF_MATCH_COUNT items )"'
#--bind 'focus:transform-preview-label:cmd -C "IF EXISTS \"{}\" ( echo Previewing [{}] )"'
#--bind 'focus:+transform-header:cmd -C "IF NOT EXISTS \"{}\" ( echo No file selected )"'
#--bind 'ctrl-r:change-list-label( Reloading the list )+reload(cmd -C "timeout /t 5 >nul & git ls-files")'
#--color 'border:#aaaaaa,label:#cccccc'
#--color 'preview-border:#9999cc,preview-label:#ccccff'
#--color 'list-border:#669966,list-label:#99cc99'
#--color 'input-border:#996666,input-label:#ffcccc'
#--color 'header-border:#6699cc,header-label:#99ccff'
#'@
