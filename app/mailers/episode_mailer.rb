class EpisodeMailer < RadioMailer  
  def schedule(episode)
    @episode = episode
    mail(:to =>"thredden@gmail.com", :subject => "IMI's TechTalk - Schedule - #{@episode.recording_description}")
  end

=begin
  
  def script(episode, pdf)
    @episode = episode
    attachments[@episode.script_name] = pdf
    self.instance_variable_set(:@lookup_context, nil)
    mail(:to =>"thredden@gmail.com", :subject => "IMI's TechTalk - Script- #{@episode.title} - #{@episode.recording_description}")
  end

=end

  def script(episode)
    @episode = episode
    subject = "IMI's TechTalk - Script- #{@episode.title} - #{@episode.recording_description}"
    mail(:to =>"thredden@gmail.com", :subject => subject) do |format|
      format.text
      format.html
      format.pdf do
        attachments["script.pdf"] = WickedPdf.new.pdf_from_string(
          render_to_string(
            :pdf => "script",
            :template => 'episodes/script.haml',
            :layout => false, 
            :header => {
              :left => "#{@episode.live? ? 'LIVE': 'PRERECORD'} - #{@episode.recording_datetime.to_date.to_s(:short)}",
              :center => "Guest: #{@episode.guest_name}",
              :right => "TECHTALK"
            },
            :footer => {
              :left => "IMI Group",
              :center => 'Page [page]/[topage]'
            }            
          )
        )
      end
    end
  end

  def needed_items(episode)
    @episode = episode
    mail(:to =>"thredden@gmail.com", :subject => "IMI's TechTalk - Needed Items - #{@episode.title}")
  end
end
