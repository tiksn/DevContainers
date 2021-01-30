Properties {
    $settings = Import-PowerShellDataFile -Path ./Settings.psd1

    $DockerUserName = $settings.DockerUserName
    $Repository = $settings.Variations.$Variation.Repository
}

Task EstimateNextVersion {

}

Task BuildDockerImage -depends EstimateNextVersion {

}

Task PushDockerImage -depends BuildDockerImage {

}
