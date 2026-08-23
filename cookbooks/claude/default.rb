directory "#{ENV['HOME']}/.claude"

link "#{ENV['HOME']}/.claude/settings.json" do
  to File.expand_path('.config/claude/settings.json')
  force true
end

link "#{ENV['HOME']}/.claude/skills" do
  to File.expand_path('.config/claude/skills')
  force true
end

execute 'copy CLAUDE.md if missing' do
  command "cp #{File.expand_path('.config/claude/CLAUDE.md')} #{ENV['HOME']}/.claude/CLAUDE.md"
  not_if "test -e #{ENV['HOME']}/.claude/CLAUDE.md"
end
