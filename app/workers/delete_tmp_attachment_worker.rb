class DeleteTmpAttachmentWorker
  include Sidekiq::Worker
  sidekiq_options queue: "low"

  def perform
    tmp_attachments = TmpAttachment.includes(:attachment).
      where(attachments: { id: nil }).
      where('tmp_attachments.created_at < ?', Time.now - 20.minutes)

    tmp_attachments.destroy_all
  end
end