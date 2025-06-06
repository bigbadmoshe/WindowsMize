#=================================================================================================================
#                                       File Explorer - Misc > Show Gallery
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowGallery
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowGallery
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowGallery -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 or delete (default) | off: 0
        $ShowGallery = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}'
            Entries = @(
                @{
                    Name  = 'System.IsPinnedToNameSpaceTree'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Show Gallery' to '$State' ..."
        Set-RegistryEntry -InputObject $ShowGallery
    }
}
