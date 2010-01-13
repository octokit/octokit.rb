module Octopussy
  class Event 
  
    def self.load_from_atom(entry)
      entry = entry.to_mash if entry.is_a?(Hash)
    
      event = Hashie::Mash.new({:user => entry.author, :title => entry.title})
      event.published = (entry.published.is_a?(String) ? DateTime.parse(entry.published) : entry.published)
      event.id = entry.id.split("/").pop.to_i
      
      event.links = entry.links
      event.content = entry.content
      
      case entry.id
      when /CreateEvent/
        case entry.title 
        when /created tag/
          event.event_type = 'tag'
          event.tag = entry.links.first.split('/').pop
        when /created branch/
          event.event_type = 'branch'
          event.branch = entry.links.first.split('/').pop
        when /created repository/
          event.event_type = 'repo'
        end
        
      when /MemberEvent/
        event.event_type = 'member'
        event.target_user = entry.title.split(" ")[2]
      when /PushEvent/
        event.event_type = 'push'
        event.branch = entry.links.first.split('/').pop
      when /ForkApplyEvent/
        event.event_type = 'fork_apply'
        event.branch = entry.links.first.split('/').pop
      when /ForkEvent/
        event.event_type = 'fork'
        segments = entry.title.split(" ")
        event.forked_from = Repo.new(segments.last)
      when /WatchEvent/
        event.event_type = 'watch'
        
      when /FollowEvent/
        event.event_type = 'follow'
        event.target_user = entry.links.first.split("/").pop
      when /IssuesEvent/
        event.event_type = 'issue'
        event.action = entry.title[/closed|opened|reopened/]
        event.issue_number = entry.title[/\s\d+\s/].strip.to_i
      when /GistEvent/
        event.event_type = 'gist'
        event.gist_number = entry.links.first.split('/').pop.to_i
      when /WikiEvent/
        event.event_type = 'wiki'
        event.page = entry.links.first.split('/').pop
      when /CommitCommentEvent/
        event.event_type = 'comment'
      when /DeleteEvent/
        event.event_type = 'delete'
        segments = entry.title.split(' ')
        event.branch = segments[3]
        event.repo = Repo.new(segments[5])
      when /PublicEvent/
        event.event_type = 'public'
        event.repo = Repo.new(entry.title.split(" ")[3])
      when /DownloadEvent/
        event.event_type = 'download'
        segments = entry.title.split(' ')
        event.repo = Repo.new(segments[5])
      else
        puts "Unknown event type: #{entry.id}"
      end
      event.repo = Repo.from_url(entry.links.first) unless %w(follow gist delete public download).include?(event.event_type)
      event
    end
  end
end