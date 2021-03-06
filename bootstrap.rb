# To bootstrap bartlett, run the following:
# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/collectiveidea/bartlett/master/bootstrap.rb)"

INSTALL_DIR = "~/.bartlett"
GIT_URL = "https://github.com/collectiveidea/bartlett"


unless File.directory? INSTALL_DIR
  `git clone #{GIT_URL} #{INSTALL_DIR}`
end

`chmod +x ~/.bartlett/bin/bart`

puts "\n\n\n"
puts "Add the following to your .bashrc or .zshrc"
puts "PATH=$PATH:$HOME/.bartlett/bin"
