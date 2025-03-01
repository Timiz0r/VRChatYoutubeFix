# https://github.com/yt-dlp/yt-dlp/wiki/Extractors#youtube
# > At this time, it is recommended to use provide a PO Token to use with the web client. Refer to the [PO Token Guide] on how to set up yt-dlp for this.
#
# https://github.com/yt-dlp/yt-dlp/wiki/PO-Token-Guide#basePlugins
# > yt-dlp-get-pot by coletdjnz
# >   An experimental basePlugin framework for yt-dlp to support fetching PO Tokens from external providers. Maintained by a yt-dlp maintainer.
# >   https://github.com/coletdjnz/yt-dlp-get-pot/releases
# > bgutil-ytdlp-pot-provider by Brainicism
# >   A yt-dlp-get-pot provider which uses BgUtils to generate PO Tokens. Not affiliated with yt-dlp.
#
# https://github.com/Brainicism/bgutil-ytdlp-pot-provider
# > There are two options for the provider, an always running POT generation HTTP server, and a POT generation script invoked when needed. The HTTP server option is simpler, and comes with a prebuilt Docker image.
# > The provider is a Node.js HTTP server. You have two options for running it: as a prebuilt docker image, or manually as a node application.
# >   docker run --name bgutil-provider -d -p 4416:4416 brainicism/bgutil-ytdlp-pot-provider

if (-not (Get-Command docker.exe)) {
    winget.exe install Docker.DockerDesktop

    $dockerPath = "$env:ProgramFiles\Docker\Docker\resources\bin"
    if (-not (Test-Path $dockerPath)) {
        throw "Unable to find docker."
    }

    # would be done via winget, but dont want to restart console to get new path env var
    $env:path = "$env:path:$dockerPath"
}

docker run --name bgutil-provider -d --restart unless-stopped -p 4416:4416 brainicism/bgutil-ytdlp-pot-provider

$ytdlpLocation = "$env:userprofile\AppData\LocalLow\VRChat\VRChat\Tools"
Set-Location $ytdlpLocation

function AddYtdlpPlugin ([string]$PluginLocation) {
    $pluginZip = [uri]::new($PluginLocation).Segments[-1]
    $pluginPath = "yt-dlp-plugins\$([System.IO.Path]::GetFileNameWithoutExtension($pluginZip))\$pluginZip"
    if (Test-Path $pluginZip) {
        Remove-Item -Path $pluginZip
    }
    if (Test-Path $pluginPath) {
        Remove-Item -Path $pluginPath -Recurse
    }

    Invoke-WebRequest $PluginLocation -OutFile $pluginZip
    Expand-Archive -Path $pluginZip -DestinationPath $pluginPath
}

AddYtdlpPlugin -PluginLocation "https://github.com/coletdjnz/yt-dlp-get-pot/releases/download/v0.3.0/yt-dlp-get-pot.zip"
AddYtdlpPlugin -PluginLocation "https://github.com/Brainicism/bgutil-ytdlp-pot-provider/releases/download/0.7.3/bgutil-ytdlp-pot-provider.zip"
