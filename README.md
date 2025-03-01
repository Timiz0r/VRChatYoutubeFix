# VRChatYouTubeFix
In progress 作成中
完成したら後でちゃんと日本語に翻訳する

## Problem 本来の問題
https://github.com/yt-dlp/yt-dlp/issues/11868

This issue is a mix of two problems:
* A problem with the iOS client -- unrelated to VRChat
* A new bot detection mechanism rolling out that may (temporarily) block IPs

One proposed fix is to use cookies. [This may cause one's account to be blocked](https://github.com/yt-dlp/yt-dlp/issues/10085), so it's recommended to use a throwaway account.

Using [PO tokens](https://github.com/yt-dlp/yt-dlp/wiki/PO-Token-Guide) may work, or may decrease the chance of getting IP blocked.
This fix is mainly for the iOS-related issue. I'm not sure if it helps for the issue affecting VRChat users. At the very least, it may make users look less suspicious to YouTube.


## Installation
Simply run the script in PowerShell, either executing the file or copy-pasting into a PowerShell terminal.
Of course, always beware of running untrusted code -- be it this installation script or the ytdlp plugins it adds.

### Installation details
In order to get PO tokens, [Docker](https://www.docker.com/) is required. The installation script will install it if not found, and you will need to follow any prompts.
The required docker container will also be run and will start automatically when the PC restarts -- as long as Docker is set to start with Windows.

The [two required yt-dlp plugins](https://github.com/yt-dlp/yt-dlp/wiki/PO-Token-Guide#basePlugins) are installed.
The first plugin is simply a framework for running other PO token-related plugins and does nothing on its own.
The second one communicates with the docker container to get PO tokens.

## Uninstallation
If you do not want Docker installed, run `winget uninstall Docker.DockerDesktop`.

To stop the docker container, run `docker rm bgutil-provider --force`.

To remove the yt-dlp plugins, run `Remove-Item "$env:userprofile\AppData\LocalLow\VRChat\VRChat\Tools\yt-dlp-plugins" -Recurse`

## Other notes
### Other potential workarounds
VRChat uses a custom version of yt-dlp with most features removed. This makes it impossible to configure with things like cookies or other extractor args.

It is not practical to replace VRChat's version directly, since it will overwrite it.
It may be possible to use [Image File Execution Option's Debugger feature](https://techcommunity.microsoft.com/blog/askperf/two-minute-drill-configuring-a-debugger-using-image-file-execution-options/373478) to provide our own version, though.
This would allow us to provide cookies or force extractor args.

Interestingly, VRChat's yt-dlp still seems to have its plugin internals in place. However, since verbose logging is disabled, it's hard to tell if it's working.