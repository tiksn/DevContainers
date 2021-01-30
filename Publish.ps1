[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ParameterSetName = 'BaseMajor')]
    [Parameter(Mandatory = $true, ParameterSetName = 'BaseMinor')]
    [Parameter(Mandatory = $true, ParameterSetName = 'BasePatch')]
    [switch]
    $Base,
    [Parameter(Mandatory = $true, ParameterSetName = 'BaseMajor')]
    [switch]
    $MajorRelease,
    [Parameter(Mandatory = $true, ParameterSetName = 'BaseMinor')]
    [switch]
    $MinorRelease,
    [Parameter(Mandatory = $true, ParameterSetName = 'BasePatch')]
    [switch]
    $PatchRelease
)

if ($Base) {
    Invoke-psake -buildFile ./PsakeFile.ps1 -taskList PushDockerImage -parameters @{
        Variation    = 'Base'
        MajorRelease = $MajorRelease.IsPresent
        MinorRelease = $MinorRelease.IsPresent
        PatchRelease = $PatchRelease.IsPresent
    }
}