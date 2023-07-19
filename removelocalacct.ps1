<#   
.SYNOPSIS   
    Interactive menu that allows a user to connect to a local or remote computer and remove a local profile. 
.DESCRIPTION 
    Presents an interactive menu for user to first make a connection to a remote or local machine.  After making connection to the machine,  
    the user is presented with all of the local profiles and then is asked to make a selection of which profile to delete.   
.NOTES   
    Name: Remove-LocalProfile 
    Author: Boe Prox (orginal creator of)
    DateCreated: 26JAN2011
    Line 32, if need to work on older/newer version of windows change 10.0 to needed ver       
.EXAMPLE  
Remove-LocalProfile 
  
Description 
----------- 
Presents a text based menu for the user to interactively remove a local profile on local or remote machine.    
#> 
  
#Prompt for a computer to connect to 
$computer = Read-Host "Please enter a computer name"
#Test network connection before making connection 
If ($computer -ne $Env:Computername) { 
    If (!(Test-Connection -comp $computer -count 1 -quiet)) { 
        Write-Warning "$computer is not accessible, please try a different computer or verify it is powered on."
        Break
        } 
    } 
Try {     
    #Verify that the OS Version is 10.0 and above, otherwise the script will fail 
    If ((Get-WmiObject -ComputerName $computer Win32_OperatingSystem -ea stop).Version -lt 10.0) { 
        Write-Warning "The Operating System of the computer is not supported.`nChange version number to try to connect."
        Break
        } 
    } 
Catch { 
    Write-Warning "$($error[0])"
    Break
    }     
Do {     
#Gather all of the user profiles on computer 
Try { 
    [array]$users = Get-WmiObject -ComputerName $computer Win32_UserProfile -filter "LocalPath Like 'C:\\Users\\%'" -ea stop 
    } 
Catch { 
    Write-Warning "$($error[0]) "
    Break
    }     
#Cache the number of users 
$num_users = $users.count 
  
Write-Host -ForegroundColor Green "User profiles on $($computer):"
  
    #Begin iterating through all of the accounts to display 
    For ($i=0;$i -lt $num_users; $i++) { 
        Write-Host -ForegroundColor Green "$($i): $(($users[$i].localpath).replace('C:\Users\',''))"
        } 
    Write-Host -ForegroundColor Green "q: Quit"
    #Prompt for user to select a profile to remove from computer 
    Do {     
        $account = Read-Host "Select a number to delete local profile or 'q' to quit"
        #Find out if user selected to quit, otherwise answer is an integer 
        If ($account -NotLike "q*") { 
            $account = $account -as [int]
            } 
        }         
    #Ensure that the selection is a number and within the valid range 
    Until (($account -lt $num_users -AND $account -match "\d") -OR $account -Like "q*") 
    If ($account -Like "q*") { 
        Break
        } 
    Write-Host -ForegroundColor Yellow "Deleting profile: $(($users[$account].localpath).replace('C:\Users\',''))"
    #Remove the local profile 
    ($users[$account]).Delete() 
    Write-Host -ForegroundColor Green "Profile:  $(($users[$account].localpath).replace('C:\Users\','')) has been deleted"
  
    #Configure yes choice 
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Remove another profile."
  
    #Configure no choice 
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Quit profile removal"
  
    #Determine Values for Choice 
    $choice = [System.Management.Automation.Host.ChoiceDescription[]] @($yes,$no) 
  
    #Determine Default Selection 
    [int]$default = 0 
  
    #Present choice option to user 
    $userchoice = $host.ui.PromptforChoice("","Remove Another Profile?",$choice,$default) 
    } 
#If user selects No, then quit the script     
Until ($userchoice -eq 1)
# SIG # Begin signature block
# MIIWqgYJKoZIhvcNAQcCoIIWmzCCFpcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUB2fDueDDIIvcSgGZdmYu2htY
# csigghD0MIIDBjCCAe6gAwIBAgIQEjggoh62NZlNAgb8En1w0zANBgkqhkiG9w0B
# AQsFADAbMRkwFwYDVQQDDBBBVEEgQXV0aGVudGljb2RlMB4XDTIyMDgxNTEzMzAy
# NloXDTIzMDgxNTEzNTAyNlowGzEZMBcGA1UEAwwQQVRBIEF1dGhlbnRpY29kZTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMckklirnxyxt2ttRYp7HH5A
# jMlupALTV0S//dMYLKk9wvuzMU/0EBc2PrX+EfNPrmRm2fsYq6vjFUtO3fuHfC1h
# BMtui2wwaAdMCSrI6Os5XUnWp5iNB4DG7WkdZIMjGZ3HRRJmqxvCd0rmykyiHlGG
# BZx6WdX0oaN3x7YcgZwVJlM6L2WFXAQxrOrV03ovOiOPypFtBfWOmbGLImqfk6tn
# zPuyJqCCGCgeNLY5nFdE129jxVjwTEpKlpBfXHRlrun98L4dNtb84Wplb6Cj9SSK
# tY6bItbgyHjP2pogvkrciQI7GOd5lIy1Fn16TsIKCDHrpMr8TGWxzv7HEDbLCRUC
# AwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0G
# A1UdDgQWBBQWXI8mZKbpbdMVUVl6oxNlvqZnJTANBgkqhkiG9w0BAQsFAAOCAQEA
# QMYdcvc9v4zsmXWNcoIibOZRMtvzaCr/fFIFfFxSLEV5xSOr6YK5YrWJVddc9paP
# YNyNlLWT+xLY6/P8KEUC+YT95vYbG5aAeQ+bNbIpRMGY35zvcbBBH83Fdysw3mmm
# 8iI/NU2AUm3u1K7IWvoOAKdBejHO7lbLjlRpoRfUXC3R8wQ4TqV1H4YYKE1pNRVC
# ARFC6QFAns2fPioWkxOeA0hOLLAPazMETW2O3JVpEKEC0BOsMOaBK/h8NyLfk8ff
# as3EYvo/7/nMDOJgOxvt5qa7SZV2ceDUDJjbUMAeyl+gOuaQedz8pvR3JEs70XlT
# tbKpnvg5ROGgEkJQFgvLgDCCBuwwggTUoAMCAQICEDAPb6zdZph0fKlGNqd4Lbkw
# DQYJKoZIhvcNAQEMBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVy
# c2V5MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVT
# VCBOZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRpZmljYXRpb24g
# QXV0aG9yaXR5MB4XDTE5MDUwMjAwMDAwMFoXDTM4MDExODIzNTk1OVowfTELMAkG
# A1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMH
# U2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0
# aWdvIFJTQSBUaW1lIFN0YW1waW5nIENBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8A
# MIICCgKCAgEAyBsBr9ksfoiZfQGYPyCQvZyAIVSTuc+gPlPvs1rAdtYaBKXOR4O1
# 68TMSTTL80VlufmnZBYmCfvVMlJ5LsljwhObtoY/AQWSZm8hq9VxEHmH9EYqzcRa
# ydvXXUlNclYP3MnjU5g6Kh78zlhJ07/zObu5pCNCrNAVw3+eolzXOPEWsnDTo8Tf
# s8VyrC4Kd/wNlFK3/B+VcyQ9ASi8Dw1Ps5EBjm6dJ3VV0Rc7NCF7lwGUr3+Az9ER
# CleEyX9W4L1GnIK+lJ2/tCCwYH64TfUNP9vQ6oWMilZx0S2UTMiMPNMUopy9Jv/T
# UyDHYGmbWApU9AXn/TGs+ciFF8e4KRmkKS9G493bkV+fPzY+DjBnK0a3Na+WvtpM
# YMyou58NFNQYxDCYdIIhz2JWtSFzEh79qsoIWId3pBXrGVX/0DlULSbuRRo6b83X
# hPDX8CjFT2SDAtT74t7xvAIo9G3aJ4oG0paH3uhrDvBbfel2aZMgHEqXLHcZK5OV
# mJyXnuuOwXhWxkQl3wYSmgYtnwNe/YOiU2fKsfqNoWTJiJJZy6hGwMnypv99V9sS
# dvqKQSTUG/xypRSi1K1DHKRJi0E5FAMeKfobpSKupcNNgtCN2mu32/cYQFdz8HGj
# +0p9RTbB942C+rnJDVOAffq2OVgy728YUInXT50zvRq1naHelUF6p4MCAwEAAaOC
# AVowggFWMB8GA1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQW
# BBQaofhhGSAPw0F3RSiO0TVfBhIEVTAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/
# BAgwBgEB/wIBADATBgNVHSUEDDAKBggrBgEFBQcDCDARBgNVHSAECjAIMAYGBFUd
# IAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2VydHJ1c3QuY29tL1VT
# RVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUFBwEB
# BGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJU
# cnVzdFJTQUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51
# c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBDAUAA4ICAQBtVIGlM10W4bVTgZF13wN6
# MgstJYQRsrDbKn0qBfW8Oyf0WqC5SVmQKWxhy7VQ2+J9+Z8A70DDrdPi5Fb5WEHP
# 8ULlEH3/sHQfj8ZcCfkzXuqgHCZYXPO0EQ/V1cPivNVYeL9IduFEZ22PsEMQD43k
# +ThivxMBxYWjTMXMslMwlaTW9JZWCLjNXH8Blr5yUmo7Qjd8Fng5k5OUm7Hcsm1B
# bWfNyW+QPX9FcsEbI9bCVYRm5LPFZgb289ZLXq2jK0KKIZL+qG9aJXBigXNjXqC7
# 2NzXStM9r4MGOBIdJIct5PwC1j53BLwENrXnd8ucLo0jGLmjwkcd8F3WoXNXBWia
# p8k3ZR2+6rzYQoNDBaWLpgn/0aGUpk6qPQn1BWy30mRa2Coiwkud8TleTN5IPZs0
# lpoJX47997FSkc4/ifYcobWpdR9xv1tDXWU9UIFuq/DQ0/yysx+2mZYm9Dx5i1xk
# zM3uJ5rloMAMcofBbk1a0x7q8ETmMm8c6xdOlMN4ZSA7D0GqH+mhQZ3+sbigZSo0
# 4N6o+TzmwTC7wKBjLPxcFgCo0MR/6hGdHgbGpm0yXbQ4CStJB6r97DDa8acvz7f9
# +tCjhNknnvsBZne5VhDhIG7GrrH5trrINV0zdo7xfCAMKneutaIChrop7rRaALGM
# q+P5CslUXdS5anSevUiumDCCBvYwggTeoAMCAQICEQCQOX+a0ko6E/K9kV8IOKlD
# MA0GCSqGSIb3DQEBDAUAMH0xCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVy
# IE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28g
# TGltaXRlZDElMCMGA1UEAxMcU2VjdGlnbyBSU0EgVGltZSBTdGFtcGluZyBDQTAe
# Fw0yMjA1MTEwMDAwMDBaFw0zMzA4MTAyMzU5NTlaMGoxCzAJBgNVBAYTAkdCMRMw
# EQYDVQQIEwpNYW5jaGVzdGVyMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxLDAq
# BgNVBAMMI1NlY3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcgU2lnbmVyICMzMIICIjAN
# BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAkLJxP3nh1LmKF8zDl8KQlHLtWjpv
# AUN/c1oonyR8oDVABvqUrwqhg7YT5EsVBl5qiiA0cXu7Ja0/WwqkHy9sfS5hUdCM
# WTc+pl3xHl2AttgfYOPNEmqIH8b+GMuTQ1Z6x84D1gBkKFYisUsZ0vCWyUQfOV2c
# sJbtWkmNfnLkQ2t/yaA/bEqt1QBPvQq4g8W9mCwHdgFwRd7D8EJp6v8mzANEHxYo
# 4Wp0tpxF+rY6zpTRH72MZar9/MM86A2cOGbV/H0em1mMkVpCV1VQFg1LdHLuoCox
# /CYCNPlkG1n94zrU6LhBKXQBPw3gE3crETz7Pc3Q5+GXW1X3KgNt1c1i2s6cHvzq
# cH3mfUtozlopYdOgXCWzpSdoo1j99S1ryl9kx2soDNqseEHeku8Pxeyr3y1vGlRR
# bDOzjVlg59/oFyKjeUFiz/x785LaruA8Tw9azG7fH7wir7c4EJo0pwv//h1epPPu
# FjgrP6x2lEGdZB36gP0A4f74OtTDXrtpTXKZ5fEyLVH6Ya1N6iaObfypSJg+8kYN
# abG3bvQF20EFxhjAUOT4rf6sY2FHkbxGtUZTbMX04YYnk4Q5bHXgHQx6WYsuy/Rk
# LEJH9FRYhTflx2mn0iWLlr/GreC9sTf3H99Ce6rrHOnrPVrd+NKQ1UmaOh2DGld/
# HAHCzhx9zPuWFcUCAwEAAaOCAYIwggF+MB8GA1UdIwQYMBaAFBqh+GEZIA/DQXdF
# KI7RNV8GEgRVMB0GA1UdDgQWBBQlLmg8a5orJBSpH6LfJjrPFKbx4DAOBgNVHQ8B
# Af8EBAMCBsAwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDBK
# BgNVHSAEQzBBMDUGDCsGAQQBsjEBAgEDCDAlMCMGCCsGAQUFBwIBFhdodHRwczov
# L3NlY3RpZ28uY29tL0NQUzAIBgZngQwBBAIwRAYDVR0fBD0wOzA5oDegNYYzaHR0
# cDovL2NybC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBVGltZVN0YW1waW5nQ0EuY3Js
# MHQGCCsGAQUFBwEBBGgwZjA/BggrBgEFBQcwAoYzaHR0cDovL2NydC5zZWN0aWdv
# LmNvbS9TZWN0aWdvUlNBVGltZVN0YW1waW5nQ0EuY3J0MCMGCCsGAQUFBzABhhdo
# dHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAgEAc9rtaHLL
# wrlAoTG7tAOjLRR7JOe0WxV9qOn9rdGSDXw9NqBp2fOaMNqsadZ0VyQ/fg882fXD
# eSVsJuiNaJPO8XeJOX+oBAXaNMMU6p8IVKv/xH6WbCvTlOu0bOBFTSyy9zs7WrXB
# +9eJdW2YcnL29wco89Oy0OsZvhUseO/NRaAA5PgEdrtXxZC+d1SQdJ4LT03EqhOP
# l68BNSvLmxF46fL5iQQ8TuOCEmLrtEQMdUHCDzS4iJ3IIvETatsYL254rcQFtOiE
# CJMH+X2D/miYNOR35bHOjJRs2wNtKAVHfpsu8GT726QDMRB8Gvs8GYDRC3C5VV9H
# vjlkzrfaI1Qy40ayMtjSKYbJFV2Ala8C+7TRLp04fDXgDxztG0dInCJqVYLZ8roI
# ZQPl8SnzSIoJAUymefKithqZlOuXKOG+fRuhfO1WgKb0IjOQ5IRT/Cr6wKeXqOq1
# jXrO5OBLoTOrC3ag1WkWt45mv1/6H8Sof6ehSBSRDYL8vU2Z7cnmbDb+d0OZuGkt
# fGEv7aOwSf5bvmkkkf+T/FdpkkvZBT9thnLTotDAZNI6QsEaA/vQ7ZohuD+vprJR
# VNVMxcofEo1XxjntXP/snyZ2rWRmZ+iqMODSrbd9sWpBJ24DiqN04IoJgm6/4/a3
# vJ4LKRhogaGcP24WWUsUCQma5q6/YBXdhvUxggUgMIIFHAIBATAvMBsxGTAXBgNV
# BAMMEEFUQSBBdXRoZW50aWNvZGUCEBI4IKIetjWZTQIG/BJ9cNMwCQYFKw4DAhoF
# AKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisG
# AQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcN
# AQkEMRYEFNyjiRxNWmy4zhRyvm4oWlueMvYHMA0GCSqGSIb3DQEBAQUABIIBADVd
# KHUoIuYbWPYNBSX1hDGZNyXxJRXeOVCDFCD2p1ZCUFWyusVtEPaZOTWYT4bheH9O
# PGR31h5F4fUVcKPFp2zjuCZUCWUJPHfUA08jH6NgXodGbNw+LLUQIlk+M6lx7+MI
# jqJtLpV7ojraxiA1jwx9nSfTqgMIzzCXSGz7fK+K8pNLo8/VIPcffm6BVeJHuYxx
# uuHnGOedko68WO7/PmDCSZAQg3oecypkdWa/ba1zvBCh6vww4i/5eJNFIsT7syfL
# k0xVoqV7XSqS8afFYyHpgFxsZpGNIHbiIObsTE6IhwcFH8+29etF7YhhdAMyMyem
# xmFpr/lyiqerbOaLXiShggNMMIIDSAYJKoZIhvcNAQkGMYIDOTCCAzUCAQEwgZIw
# fTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
# A1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQD
# ExxTZWN0aWdvIFJTQSBUaW1lIFN0YW1waW5nIENBAhEAkDl/mtJKOhPyvZFfCDip
# QzANBglghkgBZQMEAgIFAKB5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
# KoZIhvcNAQkFMQ8XDTIyMDgxNTEzNDIxMlowPwYJKoZIhvcNAQkEMTIEMKmlDx14
# silVTnVous+p8KZXrH+7BSAognFv/GYZCzmuOUAQDpEONDaqDbuDxhN61jANBgkq
# hkiG9w0BAQEFAASCAgAiJV6/f4tb2MDiu1hZ9qY7WmsKcNUULX7HAxt05CVlxNRP
# icr1FF7YCvHV361GFqNdvWufj+XnFn6iARIworeVsQmlPtY6HOC0m8a9mRnRWrAG
# K2dBF/yQ+PpEDfOYF7510Gw8aoocNJiE5UOX9Zppd1y89Hs0U9AjJleGHI89uzKr
# 8M9WvxR4WiZ0HNJZAfsCjB9qHTZML3a623uNyRxinFWmnIyEJbwsieFO8UcM1sCM
# n4dcTg3eMHp+LHbvifWauQzFxnuicStXa1J8NZAU1ylNOVneeXxb9SnNDdBJeGkK
# i1+cR6yyWKmk2iixB9jX75JFtG0CAo+1M3VPvl4mZzm2T99P3MPHd2IFEDjFDxo0
# x1q1TTQFDwWcueUNbNBDP6K8km2UTQ7vsFZ4gaYcaScgc5EPqg8SksJyXTiNrDSC
# NEPghiAjD/+PmdmMPj4ed7cRy/QmTSyl3wvO5fCMw/nAkvJmZ3pGsdsbl5wPLss5
# ltfYPa7WXVHp1I9wJ1amjoX87Y+eKsTD9hfkk262zMkFWnuDEKxroj7jgTMzrrFH
# V2n3EkEUv1ueZynevP9G/v8a+lXkPg+7qFo86j0GmxA24yJDM4e6NE4PBjBnbDmF
# 7itVNfcukojL4m6b+8nYukwKpTm2Jj8+kUdXNzWrCTZInQjrB1tgrRGHM0Q4jw==
# SIG # End signature block
