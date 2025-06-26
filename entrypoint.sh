SetUsePerfThreads="-useperfthreads "
if [[ $UsePerfThreads == "false" ]]; then
    SetUsePerfThreads=""
fi

SetNoAsyncLoadingThread="-NoAsyncLoadingThread "
if [[ $NoAsyncLoadingThread == "false" ]]; then
    SetNoAsyncLoadingThread=""
fi

MaxServerPlayers="${MaxServerPlayers:-6}"
Port="${Port:-7777}"
QueryPort="${QueryPort:-27015}"
ServerPassword="${ServerPassword:-password}"
SteamServerName="${SteamServerName:-LinuxServer}"
WorldSaveName="${WorldSaveName:-Cascade}"
AdditionalArgs="${AdditionalArgs:-}"
DeleteGamefilesEachBoot="${DeleteGamefilesEachBoot:-false}"

# DIRTY, JUST HOW I LIKE IT 
if [[ $DeleteGamefilesEachBoot == "true" ]]; then
    rm -rf /server/Engine \
    /server/steamapps \
    /server/Manifest* \
    /server/AbioticFactorServer.exe \
    /server/AbioticFactor/Content \
    /server/AbioticFactor/Binaries
    echo "Game files cleared."
fi

# Check for updates/perform initial installation
if [ ! -d "/server/AbioticFactor/Binaries/Win64" ] || [[ $AutoUpdate == "true" ]]; then
    steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /server \
    +login anonymous \
    +app_update 2857200 validate \
    +quit
fi

pushd /server/AbioticFactor/Binaries/Win64 > /dev/null
WINEDEBUG=fixme-all wine AbioticFactorServer-Win64-Shipping.exe $SetUsePerfThreads$SetNoAsyncLoadingThread-MaxServerPlayers=$MaxServerPlayers \
    -PORT=$Port -QueryPort=$QueryPort -ServerPassword=$ServerPassword \
    -SteamServerName="$SteamServerName" -WorldSaveName="$WorldSaveName" -tcp $AdditionalArgs
popd > /dev/null
