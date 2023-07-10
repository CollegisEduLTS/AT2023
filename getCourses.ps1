# What's the URL for your Learn instance?
$baseUrl = ""

# Add in your token (maybe you want to integrate a function to get your token for you)
$token = ""

try {
    # As an example, we're going to use the courses API to pull back a list of all of the courses in our environment
    $courseURI = "$baseUrl/learn/api/public/v3/courses"
    
    # Let's make our request and see what we get back...
    $courses = Invoke-RestMethod -Headers @{Authorization = ("Bearer $token") } -Uri $courseURI -method "GET" -ContentType 'application/json' -ResponseHeadersVariable responseHeader
    Write-Host "The request returned $($courses.results.count) courses." # Notice the use of an expression to get PowerShell to display a nested value/property - $courses is a variable

    # Learn can only send back 100 responses at a time, so your results may be paginated.  You can tell by checking if there is a Paging propery on the response.
    # Each time you send a request, you'll want to check for this property to see if there are more results, and keep iterating until you no longer get a result with a Paging property
    if (get-member -InputObject $courses -name "Paging" -MemberType Properties) {
        $nextPage = $courses.paging.nextPage
        
        # As an example, we can make another call to get the next set of results
        $moreCourses = Invoke-RestMethod -Headers @{Authorization = ("Bearer $token") } -Uri "$baseUrl/$nextPage" -method "GET" -ContentType 'application/json' -ResponseHeadersVariable responseHeader
        Write-Host "The request returned $($moreCourses.results.count) courses." # Notice the use of an expression to get PowerShell to display a nested value/property - $courses is a variable

        # Now we can combine the results from the first request with the second request.
        $courses.results += $moreCourses.results
        Write-Host "Now we have $($courses.results.count) courses."

        # In a final script, you'd most likely write some logic to check for a nextPage value and keep looping until there are no more pages.
    }
}
catch {
    Write-Error "An error occurred retrieving the courses: $($_.message)"
}