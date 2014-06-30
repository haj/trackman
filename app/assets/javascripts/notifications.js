function showErrorMessage(msg){
 Messenger().post({
	 message: msg,
	type: 'error',
    showCloseButton: true
	});
}	

function progressMessage(){
	var i = 0;
            Messenger().run({
              errorMessage: 'Error destroying alien planet',
              successMessage: 'Alien planet destroyed!',
              action: function(opts) {
                if (++i < 3) {
                  return opts.error({
                    status: 500,
                    readyState: 0,
                    responseText: 0
                  });
                } else {
                  return opts.success();
                }
              }
            });
}

function showSuccess(msg){
	Messenger().post(msg);
}