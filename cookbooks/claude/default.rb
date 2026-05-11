directory "#{ENV['HOME']}/.claude"

link "#{ENV['HOME']}/.claude/settings.json" do
  to File.expand_path('.config/claude/settings.json')
  force true
end
