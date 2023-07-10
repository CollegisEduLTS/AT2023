# What's the URL for your Learn instance?
$baseUrl = ""

# We'll need the key and secret from the Bb Developer Portal
$key = ""
$secret = ""

# And noting the application ID here, while not necessary, is handy to save it for use in your Bb environment
# Application ID - 

# To format the key and secret properly for use with invoke-restmethod, we need to convert it into base64
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $key, $secret)))
	
# Following the spec, set the grant type
$requestbody = "grant_type=client_credentials"
	
$oauthuri = "$baseUrl/learn/api/public/v1/oauth2/token"

# And finally, we can get 
try {
    $oauthresponse = Invoke-RestMethod -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo) } -body $requestbody -Uri $oauthuri -Method Post
    $token = $oauthresponse.access_token
    Write-Host "Token: $token, expires in $($oauthresponse.expires_in) seconds ($($(get-date).AddSeconds($oauthresponse.expires_in)))"
}
catch {
    Write-Error "An error occurred retrieving a token: $($_.message)"
}