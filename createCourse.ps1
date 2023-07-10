# What's the URL for your Learn instance?
$baseUrl = ""

# Add in your token (maybe you want to integrate a function to get your token for you)
$token = ""

# I've found that creating a custom object to match the Bb data model works really well.
# Depending on the complexity of the object, like updating the duration values, you may need to do nested custom objects.

$newCourseName = "Anthology Together Test Course 4"
$newCourseId = "TEST-AT2023-04"

# In a simple case...
$newCourse = [PSCustomObject]@{
    courseId = $newCourseId
    name     = $newCourseName
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
$newCourse = [PSCustomObject]@{
    courseId     = $newCourseId
    name         = $newCourseName  
    availability = $availability
}

# This will then need to be converted to json to be processed by Learn
# By default, convertto-json only contains 2 levels deep, so depending on your changes, you may need to increase this.  The maximum is 10.
try {
    $jsonBody = $newCourse | ConvertTo-Json -depth 5

    # Tech Tip! If you have special characters in your json, you can convert it to a bytestream, and Learn will process it properly.  This is especially handy when updating content with HTML.
    $requestbody = [System.Text.Encoding]::UTF8.GetBytes($jsonBody)

    # Finally, let's create our course!
    $courseURI = "$baseUrl/learn/api/public/v3/courses"
    $course = Invoke-RestMethod -Headers @{Authorization = ("Bearer $token") } -Uri $courseURI -method "POST" -ContentType 'application/json' -body $requestbody -ResponseHeadersVariable responseHeader
    
    # Learn will respond with the new course object.
    Write-Host $course
}
catch {
    Write-Error "An error occurred: $_"
}


 

