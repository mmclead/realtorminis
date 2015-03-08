site_code_location = document.getElementsByName(window.location.hostname)[0].value
console.log site_code_location

siteReq = new XMLHttpRequest()

siteReq.addEventListener 'readystatechange', ->
  if siteReq.readyState is 4
    successResultCodes = [200, 304]
    if siteReq.status in successResultCodes
      document.open('text/html')
      document.write(siteReq.responseText)
      document.close()
    else
      console.log 'Error loading data...'

siteReq.open 'GET', site_code_location, false
siteReq.send()