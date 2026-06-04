directory "#{ENV['HOME']}/.claude"

link "#{ENV['HOME']}/.claude/settings.json" do
  to File.expand_path('.config/claude/settings.json')
  force true
end

link "#{ENV['HOME']}/.claude/skills" do
  to File.expand_path('.config/claude/skills')
  force true
end
