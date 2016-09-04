ready = ->
	$("#js-tmp-attachment-file").fileupload
    dataType: 'json'
    url: '/tmp_attachments.json?from=xml_destination'
    sequentialUploads: true
    maxChunkSize: 10000000 
    dropZone: $("#js-tmp-attachment-file")
    add: (e, data)->
      name = []
      _.map(data.files, (val)->
        name.push(val.name)
      )
      name.join(" ")
      $('body').waitMe
        effect : 'stretch'
        text : "Uploading ... #{name}"
        color : '#000'
        maxSize : ''
        source : ''  
      data.submit()
    done: (e, data) ->
      $("body").waitMe("hide")      
    success: (e, data)->
    	$("#js-tmp-attachment-id").val(e.object.id)
    	$("#new-order").submit()
$(document).ready(ready)
$(document).on('page:load', ready)