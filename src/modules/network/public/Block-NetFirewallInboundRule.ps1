#=================================================================================================================
#                                      Network - Block Firewall Inbound Rule
#=================================================================================================================

# Firewall rules are defined in 'private\NetFirewallRules.ps1'
# Block these ports/programs/services from external access (Internet) while maintaining local functionality.

<#
.SYNTAX
    Block-NetFirewallInboundRule
        [-Name] {CDP | DCOM | NetBiosTcpIP | SMB | MiscProgSrv}
        [<CommonParameters>]
#>

function Block-NetFirewallInboundRule
{
    <#
    .DESCRIPTION
        Specifying a group to the firewall rule will add the following info banner to the GUI properties:
          This is a predefined rule and some of its properties cannot be modified.

        i.e. The GUI properties 'Protocols and Ports' and 'Programs and Services' will be grayed out.
        Use Set-NetFirewallRule to modify these properties.

    .EXAMPLE
        PS> Block-NetFirewallInboundRule -Name 'CDP', 'NetBiosTcpIP'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('CDP', 'DCOM', 'NetBiosTcpIP', 'SMB', 'MiscProgSrv')]
        [string[]] $Name
    )

    process
    {
        foreach ($Item in $Name)
        {
            $ItemData = $NetFirewallRules.$Item
            $RulesDisplayName = $ItemData.Rules.DisplayName -join "`n             "

            Write-Verbose -Message 'Adding firewall rules:'
            Write-Verbose -Message "    $RulesDisplayName"

            Remove-NetFirewallRule -Group $ItemData.Group -ErrorAction 'SilentlyContinue'

            $RuleProperties = @{
                Action    = 'Block'
                Direction = 'Inbound'
                Group     = $ItemData.Group
            }
            foreach ($Rule in $ItemData.Rules)
            {
                New-NetFirewallRule @RuleProperties @Rule | Out-Null
            }
        }
    }
}
