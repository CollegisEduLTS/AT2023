# What's the URL for your Learn instance?
$baseUrl = ""

# Add in your token (maybe you want to integrate a function to get your token for you)
$token = ""

# Enter the course_id for the course you'd like to update
$courseId = "TEST-AT2023-03"

# I've found that creating a custom object to match the Bb data model works really well.
# Depending on the complexity of the object, like updating the duration values, you may need to do nested custom objects.

# In a simple case...
$updatedCourse = [PSCustomObject]@{
    name = "Anthology Together Test Course 3 (Updated)"
}

# Or more complex...
# Start with the most deeply nested property, and work up from there
$duration = [PSCustomObject]@{
    type  = "DateRange"
    start = "2023-07-01"
    end   = "2023-08-01"
}
$availability = [PSCustomObject]@{
    available = "Yes"
    duration  = $duration
}
$updatedCourse = [PSCustomObject]@{
    name         = "Anthology Together Test Course 3 (Updated)"
    availability = $availability
}

# This will then need to be converted to json to be processed by Learn
# By default, convertto-json only contains 2 levels deep, so depending on your changes, you may need to increase this.  The maximum is 10.
try {
    $jsonBody = $updatedCourse | ConvertTo-Json -depth 5

    # Tech Tip! If you have special characters in your json, you can convert it to a bytestream, and Learn will process it properly.  This is especially handy when updating content with HTML.
    $requestbody = [System.Text.Encoding]::UTF8.GetBytes($jsonBody)

    # Finally, let's apply our updates to the course.
    $courseURI = "$baseUrl/learn/api/public/v3/courses/courseId:$courseId"

    # But wait, let's show another way we can set up our parameters, called splatting
    # We can set up a hashtable with our parameters, which may be easier to read and update
    $requestParameters = @{
        Headers = @{
            Authorization = ("Bearer $token")
        }
        Uri = $courseURI
        Method = "PATCH"
        contentType = 'application/json'
        body = $requestbody
    }
    # $course = Invoke-RestMethod -Headers @{Authorization = ("Bearer $token") } -Uri $courseURI -method "PATCH" -ContentType 'application/json' -body $requestbody -ResponseHeadersVariable responseHeader
    $course = Invoke-RestMethod @requestParameters # Note that there's an @ instead of a $ for the splatted hashtable
    
    # Learn will respond with the updated course object, so you can validate that your changes were applied.
    # We can use a pipeline like this to take the json response from Bb and display it as a table
    $course | Format-Table | Out-String |% {Write-Host $_}
}
catch {
    Write-Error "An error occurred: $_"
}


 

