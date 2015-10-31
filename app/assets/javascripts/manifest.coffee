site_name = window.location.hostname.match(/(w{3}\.)?(.*)/)[2]
site_code_location = "http://testing-sites.realtorminis.com/custom_domains/"+window.location.hostname.replace(/^www\./, '')+".html"

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