Properties {
    $settings = Import-PowerShellDataFile -Path ./Settings.psd1

    $DockerUserName = $settings.DockerUserName
    $Repository = $settings.Variations.$Variation.Repository
    $Dockerfile = $settings.Variations.$Variation.Dockerfile
}

Task DockerLogin {
    $DockerPassword = Get-Secret -name DockerPassword -AsPlainText
    Exec { docker login --username $DockerUserName --password $DockerPassword }
}

Task EstimateNextVersion {

    $versions = Invoke-RestMethod -Method Get -Uri "https://registry.hub.docker.com/v1/repositories/$Repository/tags"
    $versions = $versions | Select-Object -ExpandProperty name
    $versions = $versions | ForEach-Object { [version]$_ }
    if ($null -eq $versions) {
        $version = [version]'1.0.0'
    }
    else {
        $version = $versions | Sort-Object -Descending | Select-Object -First 1
        if ($MajorRelease) {
            $version = [version]::new($version.Major + 1, 0, 0)    
        }
        elseif ($MinorRelease) {
            $version = [version]::new($version.Major, $version.Minor + 1, 0)    
        }
        elseif ($PatchRelease) {
            $version = [version]::new($version.Major, $version.Minor, $version.Build + 1)    
        }
        else {
            Assert ($false) "Unable to estimate version."
        }
    }

    Remove-Variable -name NextVersion -Scope Script -Force -ErrorAction Ignore
    Set-Variable -Name NextVersion -Value $version -Option ReadOnly -Scope Script -Visibility Public

    Assert ( $script:NextVersion.Revision -eq -1 ) 'Revision must be -1'
    Assert ( $script:NextVersion.Build -ge 0 ) 'Build must be greater than or equal to 0'

    Remove-Variable -Name NextVersionTag -Scope Script -Force -ErrorAction Ignore
    Set-Variable -Name NextVersionTag -Value ($script:NextVersion.ToString()) -Option ReadOnly -Scope Script -Visibility Public
}

Task BuildDockerImage -depends EstimateNextVersion {
    $tag = "$($Repository):$script:NextVersionTag"

    Exec { docker build --file $Dockerfile --tag $tag . }
}

Task PushDockerImage -depends BuildDockerImage, DockerLogin {
    $tag = "$($Repository):$script:NextVersionTag"

    Exec { docker push $tag }
}
