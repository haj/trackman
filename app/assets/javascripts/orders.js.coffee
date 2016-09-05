ready = ->
  $("#js-tmp-attachment-file").fileupload
    dataType: 'json'
    url: '/tmp_attachments.json?from=xml_destination'
    sequentialUploads: true
    maxChunkSize: 25028609
    dropZone: $("#js-tmp-attachment-file")
    add: (e, data)->
      uploadErrors = []
      acceptFileTypes = /\/(xml)$/i
      if data.originalFiles[0]['type'].length and !acceptFileTypes.test(data.originalFiles[0]['type'])
        uploadErrors.push 'Not an accepted file type'
      if data.originalFiles[0]['size'] > 25028609
        uploadErrors.push 'Filesize is too big. Maximum 25MB'
      if uploadErrors.length > 0
        swal('Error', uploadErrors.join('\n'), 'error')
      else
        name = []
        _.map(data.files, (val) ->
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
    success: (e, data) ->
      $("#js-tmp-attachment-id").val(e.object.id)
      $("#new-order").submit()
$(document).ready(ready)
$(document).on('page:load', ready)