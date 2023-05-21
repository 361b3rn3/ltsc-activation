$Username = Read-Host "Enter the local username (without the domain):"
    
    $RegKeyProfileList = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
    $RegKeyInstaller = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData"
    $RegKeyAppxAllUserStore = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore"
    
    try {
        $SID = (Get-WmiObject -Class Win32_UserProfile -ErrorAction Stop | Where-Object { $_.LocalPath.split('\')[-1] -eq $Username }).SID
    }
    catch {
        Write-Warning "Failed to retrieve SID for user profile, $UserPath"
      
    }
    
    if ($SID) {
        $UserPath = Join-Path -Path "C:\Users" -ChildPath $Username
        
        if ($PSCmdlet.ShouldProcess($UserPath, "Delete")) {
            try {
                Remove-Item -Path $UserPath -Recurse -Force -ErrorAction Stop
            }
            catch {
                Write-Warning "Failed to delete user profile, $UserPath"
            }
        }
        
        $RegPathProfileList = Join-Path -Path $RegKeyProfileList -ChildPath $SID
        
        if ($PSCmdlet.ShouldProcess($RegPathProfileList, "Delete")) {
            try {
                Remove-Item -Path $RegPathProfileList -Recurse -Force -ErrorAction Stop
            }
            catch {
                Write-Warning "Failed to delete registry key, $RegPathProfileList"
            }
        }
        
        $RegPathInstaller = Join-Path -Path $RegKeyInstaller -ChildPath $SID
        
        if ($PSCmdlet.ShouldProcess($RegPathInstaller, "Delete")) {
            try {
                Remove-Item -Path $RegPathInstaller -Recurse -Force -ErrorAction Stop
            }
            catch {
                Write-Warning "Failed to delete registry key, $RegPathInstaller"
            }
        }
        
        $RegPathAppxAllUserStore = Join-Path -Path $RegKeyAppxAllUserStore -ChildPath $SID
        
        if ($PSCmdlet.ShouldProcess($RegPathAppxAllUserStore, "Delete")) {
            try {
                Remove-Item -Path $RegPathAppxAllUserStore -Recurse -Force -ErrorAction Stop
            }
            catch {
                Write-Warning "Failed to delete registry key, $RegPathAppxAllUserStore"
            }
        }
        
        Write-Output "Profile for $Username has been deleted."
    }
    else {
        Write-Output "Profile for $Username was not found."
    }
