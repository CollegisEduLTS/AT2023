# In this example, we'll demonstrate using an external config file to store data
if (Test-Path .\config.ini) {
    $config = Get-Content .\config.ini | ConvertFrom-StringData # The ConvertFrom-StringData reads in a key/value pair from a text file and creates a hashtable

    $baseUrl = $config.base_url
    $token = $config.token

    $courseId = "TEST-AT2023-04"

    # Let's go ahead and delete our course.
    try {
        $courseURI = "$baseUrl/learn/api/public/v3/courses/courseId:$courseId"
        $course = Invoke-RestMethod -Headers @{Authorization = ("Bearer $token") } -Uri $courseURI -method "DELETE" -ContentType 'application/json' -ResponseHeadersVariable responseHeader
        # Learn will respond with the a task status URL, which you could use to monitor the status of the delete.  The url will be returned in the Location header.
        Write-Host "You can send a GET request to $($responseHeader.location) to monitor the status of the delete."
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}
else {
    Write-Error "No config file was found.  Exiting the script."
}


 

