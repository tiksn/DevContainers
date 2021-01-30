[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ParameterSetName = 'Base')]
    [switch]
    $Base
)

if ($Base) {
    Invoke-psake -buildFile ./PsakeFile.ps1 -taskList PushDockerImage -parameters @{Variation = 'Base' }
}