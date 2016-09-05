require_relative '../../app/workers/delete_tmp_attachment_worker'

task :delete_tmp_attachment => :environment do
  DeleteTmpAttachmentWorker.perform_async
end
